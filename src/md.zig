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
    try system.genRandomSystem(&allocator, 100, 1, -1);

    const n_steps: u32 = 100000000;
    var current_step: u32 = 0;
    while (current_step <= n_steps) {
        try system.leapFrog(0.0001);
        current_step += 1;
    }
    // for (system.particles) |particle| {
    //     std.debug.print("{} ", .{particle.velocity[0]});
    // }
    allocator.free(system.particles);
    system.energies.deinit();
}
