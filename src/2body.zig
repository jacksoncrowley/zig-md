const std = @import("std");
const Vec3 = @import("modules.zig").Vec3;
const Particle = @import("particle.zig").Particle;
const System = @import("system.zig").System;
const ArrayList = std.ArrayList;

pub fn main() !void {
    // allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var system = System.init(allocator, Vec3.init(10, 10, 10));
    defer system.deinit();

    try system.genTwoBodySystem();

    const n_steps: u32 = 10000;
    var current_step: u32 = 0;
    while (current_step <= n_steps) : (current_step += 1) {
        try system.velocityVerlet(0.01);
        try system.writeTrajectoryXYZ("traj.xyz");
    }
}
