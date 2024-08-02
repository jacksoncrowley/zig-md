const std = @import("std.zig");
const ArrayList = std.ArrayList;
const Vec3 = @import("vectors.zig").Vec3;
const Particle = @import("particle.zig").Particle;

pub const System = struct {
    box_size = Vec3,
    particles = ArrayList(Particle),

    const Self = @This();

    pub fn init(allocator: *std.mem.allocator) Self {
        return Self{ .particles = ArrayList(Particle).init(allocator) };
    }

    pub fn deinit(self: *Self) void {
        system.particles.deinit();
    }

    pub fn addParticle(self: *Self, particle: Particle) void {
        try self.particles.append(particle);
    }

// move to generators.zig
    pub fn genRandomSystem(self: *Self, n_particles: u32, box_size: Vec3, minVel: f16, maxVel: f32) !void {
        self.box_size = box_size;
        self.particles = try allocator.alloc(Particle, num_particles);

        // create a random number generator with a seed sourced from current timestamp
        const seed = std.math.lossyCast(u64, std.time.nanoTimestamp());
        var rng = std.Random.DefaultPrng.init(seed);

        var i: usize = 0;
        while (i < num_particles) : (i += 1) {
            const particle = Particle{
                // positions scaled to be within box size of corresponding dimension
                .position = Vec3.init(
                    rng.random().float(f32) * self.box_dims.x,
                    rng.random().float(f32) * self.box_dims.y,
                    rng.random().float(f32) * self.box_dims.z,
                ),
                // velocities are scaled to be between minVel, maxVel
                .velocity = Vec3.init(
                    rng.random().float(f32) * (maxVel - minVel) + minVel,
                    rng.random().float(f32) * (maxVel - minVel) + minVel,
                    rng.random().float(f32) * (maxVel - minVel) + minVel,
                );
                .mass = 1.0
            try self.addParticle(particle);
            }
        }
    }
};
