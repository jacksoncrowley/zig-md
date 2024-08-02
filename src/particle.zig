const Vec3 = @import("vectors.zig").Vec3;

pub const Particle = struct {
    position: Vec3,
    velocity: Vec3,
    force: Vec3,
    mass: f32,
};
