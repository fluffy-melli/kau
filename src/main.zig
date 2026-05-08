const rl = @import("raylib");
const std = @import("std");
const arc = @import("arc");
const note = @import("note");
const overlay = @import("overlay");
const accuracy = @import("accuracy");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();

    var window = try arc.Window.init(arc.forDev);
    defer window.deinit();

    const font = try rl.loadFont("resources/JetBrainsMono-Regular.ttf");
    defer rl.unloadFont(font);

    var k4 = overlay.Judgment4K.init(allocator, font);
    defer k4.deinit();

    const pattern = [_]i32{ 1, 2, 3, 4, 3, 2 };
    const pattern_len = pattern.len;

    for (0..128) |i| {
        const idx = i % pattern_len;
        const key = pattern[idx];
        const ii64: i64 = @intCast(i);

        const arrival = 1200 + ii64 * 250;

        const keyType = switch (key) {
            1 => note.KeyType.key1,
            2 => note.KeyType.key2,
            3 => note.KeyType.key3,
            4 => note.KeyType.key4,
            else => unreachable,
        };

        try k4.noteManager.appendShortNote(.{
            .keyType = keyType,
            .reachTimeMs = 750,
            .arrivalTimeMs = arrival,
        });
    }

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.black);

        window.beginVirtual();
        rl.clearBackground(.black);

        try overlay.drawFPS(allocator, font);
        try k4.draw();
        try k4.render();

        window.endVirtual();
    }
}
