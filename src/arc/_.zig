const window = @import("window.zig");
const resolution = @import("resolution.zig");

pub const Window = window.Window;
pub const Resolution = resolution.Resolution;

pub const forDev = resolution.forDev;
pub const forTest = resolution.forTest;
