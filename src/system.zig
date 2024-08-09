const std = @import("std");
const ArrayList = std.ArrayList;
const Vec3 = @import("modules.zig").Vec3;
const Particle = @import("particle.zig").Particle;

pub const System = struct {
    particles: ArrayList(Particle),
    box_dims: Vec3,
    energies: ArrayList(f32),

    pub fn genRandomSystem(self: *System, allocator: *std.mem.Allocator, particle_count: usize, maxVel: f16, minVel: f16) !void {
        self.particles = try allocator.alloc(Particle, particle_count);

        const seed = std.math.lossyCast(u64, std.time.nanoTimestamp());
        var rng = std.Random.DefaultPrng.init(seed);

        for (self.particles) |*particle| {
            particle.position = Vec3.init(
                rng.random().float(f32) * self.box_dims.x,
                rng.random().float(f32) * self.box_dims.y,
                rng.random().float(f32) * self.box_dims.z,
            );

            particle.velocity = Vec3.init(
                rng.random().float(f32) * (maxVel - minVel) + minVel,
                rng.random().float(f32) * (maxVel - minVel) + minVel,
                rng.random().float(f32) * (maxVel - minVel) + minVel,
            );
            particle.mass = 1.0;
        }
    }

    pub fn genTwoBodySystem(self: *System, allocator: *std.mem.Allocator) !void {
        self.particles = try allocator.alloc(Particle, 2);
        self.box_dims = Vec3.init(10, 10, 10);
        // Particle 1: at rest at origin
        self.particles[0] = Particle{
            .position = Vec3.init(5, 0, 0),
            .velocity = Vec3.init(1, 0, 0),
            .force = Vec3.init(0, 0, 0),
            .mass = 1.0,
        };

        // Particle 2: at x=1, with initial velocity in -x direction
        self.particles[1] = Particle{
            .position = Vec3.init(6, 0, 0),
            .velocity = Vec3.init(-1, 0, 0),
            .force = Vec3.init(0, 0, 0),
            .mass = 1.0,
        };
    }

    pub fn nParticles(self: *System) usize {
        return self.particles.len;
    }

    pub fn reset_forces(self: *System) !void {
        for (self.particles) |*particle| {
            particle.force = Vec3.init(0, 0, 0);
        }
    }

    pub fn interactionPBC(r: Vec3, box_dims: Vec3) Vec3 {
        // the minimum image convention
        return Vec3.init(
            r.x - box_dims.x * @round(r.x / box_dims.x),
            r.y - box_dims.y * @round(r.y / box_dims.y),
            r.z - box_dims.z * @round(r.z / box_dims.z),
        );
    }

    pub fn forceLJ(self: *System) !void {
        // const energyNan = error{nan};
        var energy: f32 = 0.0;
        for (self.particles[0 .. self.particles.len - 1], 0..) |*particle_i, i| {
            for (self.particles[i + 1 ..]) |*particle_j| {
                var r = Vec3.subtract(particle_i.position, particle_j.position);
                r = interactionPBC(r, self.box_dims);
                // I suppose after this step we'd cut-off?
                const r2 = Vec3.dot(r, r);
                const r2i = 1 / r2;
                const r6i = std.math.pow(f32, r2i, 3);
                const r12i = std.math.pow(f32, r2i, 6);

                const lj_energy = 4 * (r12i - r6i); // no epsilon or sigma for now, I'm lazy
                energy += lj_energy;

                const lj_force = 48 * r2i * r6i * (r6i - 0.5);
                const force = Vec3.scale(r, lj_force);
                particle_i.force = Vec3.subtract(particle_i.force, force);
                particle_j.force = Vec3.add(particle_j.force, force);
            }
        }
        // std.debug.print("{}\n", .{energy}); // add a warning if energy = nan
        if (std.math.isNan(energy)) return error.energyNan;
        try self.energies.append(energy);
    }

    pub fn harmonic2Body(self: *System) !void {
        if (self.nParticles() != 2) return error.not2Particles;
        var energy: f32 = 0.0;
        const k = 1.0;

        var r = Vec3.subtract(self.particles[1].position, self.particles[0].position);
        r = interactionPBC(r, self.box_dims);

        const r2 = @sqrt(Vec3.dot(r, r));
        const force_mag = k * (r2 - 1.0);

        const force = Vec3.scale(r, -force_mag / r2);
        self.particles[0].force = Vec3.scale(force, -1);
        self.particles[1].force = force;
        energy = 0.5 * k * std.math.pow(f32, r2 - 1.0, 2);

        try self.energies.append(energy);
    }

    pub fn velocityVerlet(self: *System, ts: f16) !void {
        var ke: f32 = 0.0;
        if (self.energies.items.len == 0) {
            try self.reset_forces();
            try self.harmonic2Body();
        }

        for (self.particles) |*particle| {
            // update the velocities to t + 1/2 dt
            particle.velocity = Vec3.add(particle.velocity, Vec3.scale(particle.force, (ts / (2 * particle.mass))));
        }

        for (self.particles) |*particle| {
            // then update positions
            particle.position = Vec3.add(particle.position, Vec3.scale(particle.velocity, ts));
            // // apply PBC
            particle.position = Vec3.wrapPBC(particle.position, self.box_dims);
        }

        try self.reset_forces();
        try self.harmonic2Body();

        for (self.particles) |*particle| {
            // update the velocities to t + dt
            particle.velocity = Vec3.add(particle.velocity, Vec3.scale(particle.force, (ts / (2 * particle.mass))));
            ke += Vec3.dot(particle.velocity, particle.velocity);
        }
        // // Calculate total energy
        // const nparticles = @as(f32, @floatFromInt(self.nParticles()));
        // const pe = self.energies.getLast();
        // const etot = (pe + (ke / 2)) / nparticles;
        // const temp = ke / (3 * nparticles);
        // std.debug.print("Total Energy per Particle: {}\n", .{etot});
        // std.debug.print("Instantaneous Temperature: {}\n", .{temp});
    }

    pub fn systemToXYZ(self: *System, filename: []const u8) !void {
        const file = try std.fs.cwd().createFile(filename, .{});
        defer file.close();

        var writer = file.writer();

        try writer.print("{}\n\n", .{self.nParticles()});

        for (self.particles) |particle| {
            try writer.print("H\t{:.3} {:.3} {:.3}\n", .{ particle.position.x, particle.position.y, particle.position.z });
        }
    }

    pub fn writeTrajectoryXYZ(self: *System, filename: []const u8) !void {
        const file = try std.fs.cwd().createFile(filename, .{ .truncate = false });
        defer file.close();
        try file.seekFromEnd(0);

        var writer = file.writer();

        try writer.print("{}\n", .{self.nParticles()});
        try writer.print("Frame of trajectory\n", .{});

        for (self.particles) |particle| {
            try writer.print("H\t{:.3} {:.3} {:.3}\n", .{ particle.position.x, particle.position.y, particle.position.z });
        }
    }
};
