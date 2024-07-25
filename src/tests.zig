const std = @import("std");
const Particle = @import("modules.zig").Particle;
const Simulator = @import("modules.zig").Simulator

// pub fn main() !void {
//     var p = Particle{
//         .position = .{ 0, 0, 0 },
//         .velocity = .{ 1, 1, 1 },
//         .force = .{ 0, 0, 0 },
//         .mass = 1.0,
//     };

//     const ke = p.kineticEnergy();
//     std.debug.print("Kinetic energy: {any}\n", .{ke});
// }

pub fun main() void {
    var simulation = Simulator{100, }
}