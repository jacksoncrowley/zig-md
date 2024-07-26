const std = @import("std");

pub const Particle = struct {
    position: [3]f32,
    velocity: [3]f32,
    force: [3]f32,
    mass: f32,

    pub fn kineticEnergy(self: Particle) f32 {
        return 0.5 * self.mass * (self.velocity[0] * self.velocity[0] +
            self.velocity[1] * self.velocity[1] +
            self.velocity[2] * self.velocity[2]);
    }
};

pub const System = struct {
    particles: []Particle,
    box_dims: [3]f32,

    pub fn genRandomSystem(self: *System, allocator: *std.mem.Allocator, particle_count: usize, maxVel: f16, minVel: f16) !void {
        self.particles = try allocator.alloc(Particle, particle_count);

        const seed = std.math.lossyCast(u64, std.time.nanoTimestamp());
        var rng = std.Random.DefaultPrng.init(seed);

        for (self.particles) |*particle| {
            for (0..3) |i| {
                particle.position[i] = (rng.random().float(f32) * self.box_dims[i]);
                particle.velocity[i] = (rng.random().float(f32) * (maxVel - minVel) + minVel);
            }
            particle.mass = 1.0;
        }
    }
};
