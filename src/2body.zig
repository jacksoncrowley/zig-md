const std = @import("std");
const Vec3 = @import("modules.zig").Vec3;
const Particle = @import("modules.zig").Particle;
const System = @import("modules.zig").System;
const ArrayList = std.ArrayList;

pub fn main() !void {
    // allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();
    var system = System{
        .box_dims = Vec3.init(100, 100, 100),
        .particles = &[_]Particle{},
        .energies = ArrayList(f32).init(allocator),
    };
    try system.genTwoBodySystem(&allocator);

    const n_steps: u32 = 10000;
    var current_step: u32 = 0;
    while (current_step <= n_steps) {
        try system.velocityVerlet(0.1);
        current_step += 1;
        std.debug.print("\n", .{});
    }
    // for (system.particles) |particle| {
    //     std.debug.print("{} ", .{particle.velocity[0]});
    // }
    allocator.free(system.particles);
    system.energies.deinit();
}
