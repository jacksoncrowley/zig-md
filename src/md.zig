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

    try system.genRandomSystem(10, -1, 1);
    std.debug.print("{}", .{system.particles.items[0]});

    const n_steps: u32 = 100;
    var current_step: u32 = 0;
    while (current_step <= n_steps) {
        try system.velocityVerlet(0.0001);
        current_step += 1;
    }
    // for (system.particles) |particle| {
    //     std.debug.print("{} ", .{particle.velocity[0]});
    // }
}
