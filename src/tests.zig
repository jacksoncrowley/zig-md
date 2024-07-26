const std = @import("std");
const Particle = @import("modules.zig").Particle;
const System = @import("modules.zig").System;

pub fn main() !void {
    // allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();
    // box_dims
    const box_dims: [3]f32 = .{ 1, 1, 1 };

    var system = System{
        .box_dims = box_dims,
        .particles = &[_]Particle{},
    };
    try system.genRandomSystem(&allocator, 5, 1, -1);

    try system.reset_forces();

    try system.calculate_forces(1);
    // for (system.particles) |particle| {
    //     std.debug.print("{} ", .{particle.velocity[0]});
    // }
    allocator.free(system.particles);
}
