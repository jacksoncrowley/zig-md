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

pub const Simulator = struct {
    particles: []Particle,
    box_dims: [3]f32,
    ts: f32,

    pub fn init_random()
};
