const std = @import("std");
const Vec3 = @import("modules.zig").Vec3;
const Particle = @import("modules.zig").Particle;
const System = @import("modules.zig").System;

pub fn main() !void {
    // allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var allocator = gpa.allocator();
    // box_dims

    var system = System{
        .box_dims = Vec3.init(1, 1, 1),
        .particles = &[_]Particle{},
    };
    try system.genRandomSystem(&allocator, 5, 1, -1);

    try system.reset_forces();

    try system.calculate_forces();

    try system.leapFrog(0.0000001);
    // for (system.particles) |particle| {
    //     std.debug.print("{} ", .{particle.velocity[0]});
    // }
    allocator.free(system.particles);
}
