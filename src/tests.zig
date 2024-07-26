const std = @import("std");
const Particle = @import("modules.zig").Particle;
const System = @import("modules.zig").System;

pub fn main() !void {
    var allocator = std.heap.page_allocator;
    const box_dims: [3]f32 = .{ 1, 1, 1 };
    var system = System{
        .box_dims = box_dims,
        .particles = &[_]Particle{},
    };
    try system.genRandomSystem(&allocator, 10, 1, -1);

    for (system.particles) |particle| {
        std.debug.print("{} ", .{particle.velocity[0]});
    }
}
