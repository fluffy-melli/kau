const rl = @import("raylib");
const std = @import("std");

pub inline fn drawFPS(allocator: std.mem.Allocator, font: rl.Font) !void {
    const fps = try std.fmt.allocPrint(allocator, "fps: {d}", .{rl.getFPS()});
    defer allocator.free(fps);

    const cstr = try allocator.dupeZ(u8, fps);
    defer allocator.free(cstr);

    rl.drawTextEx(font, cstr, rl.Vector2{ .x = 3, .y = 3 }, 15, 0, .green);
}
