const std = @import("std");
const Vec3 = @import("src/vectors.zig").Vec3;
const Particle = @import("src/particle.zig").Particle;
const System = @import("src/system.zig").System;
const ArrayList = std.ArrayList;

pub fn main() !void {
    // allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();
    var system = System{
        .box_dims = Vec3.init(10, 10, 10),
        .particles = &[_]Particle{},
        .energies = ArrayList(f32).init(allocator),
    };
    try system.genTwoBodySystem(&allocator);

    try system.systemToXYZ("system.xyz");

    defer allocator.free(system.particles);
    defer system.energies.deinit();

    const n_steps: u32 = 10000;
    var current_step: u32 = 0;
    while (current_step <= n_steps) : (current_step += 1) {
        try system.velocityVerlet(0.01);
        try system.writeTrajectoryXYZ("traj.xyz");
    }
}
