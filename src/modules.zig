const std = @import("std");
const ArrayList = std.ArrayList;

pub const Vec3 = struct {
    x: f32,
    y: f32,
    z: f32,

    pub fn init(x: f32, y: f32, z: f32) Vec3 {
        return Vec3{ .x = x, .y = y, .z = z };
    }

    pub fn add(a: Vec3, b: Vec3) Vec3 {
        return Vec3{
            .x = a.x + b.x,
            .y = a.y + b.y,
            .z = a.z + b.z,
        };
    }

    pub fn subtract(a: Vec3, b: Vec3) Vec3 {
        return Vec3{
            .x = a.x - b.x,
            .y = a.y - b.y,
            .z = a.z - b.z,
        };
    }

    pub fn dot(a: Vec3, b: Vec3) f32 {
        return a.x * b.x + a.y * b.y + a.z * b.z;
    }

    pub fn scale(a: Vec3, factor: f32) Vec3 {
        return Vec3{ .x = a.x * factor, .y = a.y * factor, .z = a.z * factor };
    }

    fn wrapCoord(coord: f32, box_dim: f32) f32 {
        if (coord < 0) {
            return coord + box_dim * @ceil(@abs(coord) / box_dim);
        } else if (coord >= box_dim) {
            return coord - box_dim * @ceil(coord / box_dim);
        } else {
            return coord;
        }
    }

    pub fn wrapPBC(a: Vec3, box_dims: Vec3) Vec3 {
        return Vec3{
            .x = wrapCoord(a.x, box_dims.x),
            .y = wrapCoord(a.y, box_dims.y),
            .z = wrapCoord(a.z, box_dims.z),
        };
    }
};

pub const Particle = struct {
    position: Vec3,
    velocity: Vec3,
    force: Vec3,
    mass: f32,
};

pub const System = struct {
    particles: []Particle,
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

    pub fn calculate_forces(self: *System) !void {
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
        try self.energies.append(energy);
    }

    pub fn leapFrog(self: *System, ts: f16) !void {
        for (self.particles) |*particle| {
            // update the velocities to t - 1/2 dt
            // std.debug.print("{}\n", .{particle.velocity});
            particle.velocity = Vec3.add(particle.velocity, Vec3.scale(particle.force, (ts / particle.mass)));
            // std.debug.print("{}\n", .{particle.velocity});
            // then update positions
            std.debug.print("Old: {}\n", .{particle.position.x});
            particle.position = Vec3.add(particle.position, Vec3.scale(particle.velocity, ts));
            std.debug.print("New: {}\n", .{particle.position.x});
            // // apply PBC
            particle.position = Vec3.wrapPBC(particle.position, self.box_dims);
            std.debug.print("PBC: {}\n\n", .{particle.position.x});
        }
    }
};
