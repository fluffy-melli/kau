const rl = @import("raylib");

pub const Resolution = struct {
    width: i32,
    height: i32,
};

pub const forDev = Resolution{
    .width = 1280,
    .height = 720,
};
