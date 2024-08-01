const std = @import("std");

// pub fn main() !void {
//     const file = try std.fs.cwd().createFile(
//         "positions.csv",
//         .{ .read = true },
//     );

//     defer file.close();

//     var writer = file.writer();
//     // defer writer.flush();

//     try writer.print("HELLO", .{});
// }

pub fn systemToXYZ(filename: []const u8, system: *System) !void {
    const file = try std.fs.cwd().createFile(filename, .{});
    defer file.close();

    var writer = file.writer();

    try writer.print("{}\n\n", .{system.nParticles()});
}
