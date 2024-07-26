const std = @import("std");

pub const Vec3 = struct {
    x: f32,
    y: f32,
    z: f32,

    pub fn init(x: f32, y: f32, z: f32) Vec3 {
        return Vec3{ .x = x, .y = y, .z = z };
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
    box_dims: [3]f32,

    pub fn genRandomSystem(self: *System, allocator: *std.mem.Allocator, particle_count: usize, maxVel: f16, minVel: f16) !void {
        self.particles = try allocator.alloc(Particle, particle_count);

        const seed = std.math.lossyCast(u64, std.time.nanoTimestamp());
        var rng = std.Random.DefaultPrng.init(seed);

        for (self.particles) |*particle| {
            particle.position = Vec3.init(
                rng.random().float(f32) * self.box_dims[0],
                rng.random().float(f32) * self.box_dims[1],
                rng.random().float(f32) * self.box_dims[2],
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

    pub fn calculate_forces(self: *System, timestep: f16) !void {
        std.debug.print("{}", .{timestep});
        var n_x: u8 = 0; //number of pair-wise interactions
        for (self.particles[0 .. self.particles.len - 1], 0..) |*particle_i, i| {
            for (self.particles[i + 1 ..], i + 1..) |*particle_j, j| {
                std.debug.print("{} {} \n", .{ particle_i.position.x, particle_j.position.x });
                std.debug.print("{} {} \n\n", .{ i + 1, j + 1 });
                n_x += 1;
            }
        }
        std.debug.print("{}\n", .{n_x});
    }
};
