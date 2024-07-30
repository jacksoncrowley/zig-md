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
        .box_dims = Vec3.init(10, 10, 10),
        .particles = &[_]Particle{},
        .energies = ArrayList(f32).init(allocator),
    };
    try system.genRandomSystem(&allocator, 5, 1, -1);

    const n_steps: u32 = 1000;
    var current_step: u32 = 0;
    while (current_step <= n_steps) {
        try system.step(0.01);
        current_step += 1;
    }
    // for (system.particles) |particle| {
    //     std.debug.print("{} ", .{particle.velocity[0]});
    // }
    allocator.free(system.particles);
    system.energies.deinit();
}
