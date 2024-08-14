const std = @import("std");
const ArrayList = std.ArrayList;

pub const Vec3 = struct {
    x: f32,
    y: f32,
    z: f32,

    pub fn init(x: f32, y: f32, z: f32) Vec3 {
        return Vec3{ .x = x, .y = y, .z = z };
    }

    pub fn add(a: Vec3, b: Vec3) Vec3 {
        return Vec3{
            .x = a.x + b.x,
            .y = a.y + b.y,
            .z = a.z + b.z,
        };
    }

    pub fn subtract(a: Vec3, b: Vec3) Vec3 {
        return Vec3{
            .x = a.x - b.x,
            .y = a.y - b.y,
            .z = a.z - b.z,
        };
    }

    pub fn dot(a: Vec3, b: Vec3) f32 {
        return a.x * b.x + a.y * b.y + a.z * b.z;
    }

    pub fn scale(a: Vec3, factor: f32) Vec3 {
        return Vec3{ .x = a.x * factor, .y = a.y * factor, .z = a.z * factor };
    }

    fn wrapCoord(coord: f32, box_dim: f32) f32 {
        return coord - box_dim * @round(coord / box_dim);
    }

    pub fn wrapPBC(a: Vec3, box_dims: Vec3) Vec3 {
        return Vec3{
            .x = wrapCoord(a.x, box_dims.x),
            .y = wrapCoord(a.y, box_dims.y),
            .z = wrapCoord(a.z, box_dims.z),
        };
    }

    pub fn sum(self: Vec3) f32 {
        return self.x + self.y + self.z;
    }
};
