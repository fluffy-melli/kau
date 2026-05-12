const rl = @import("raylib");
const std = @import("std");
const note = @import("note");
const types = @import("types");
const overlay = @import("overlay");
const accuracy = @import("accuracy");
const settings = @import("settings");
const constants = @import("constants");

pub fn main(init: std.process.Init) !void {
    const allocator = init.arena.allocator();
    const io = init.io;

    const config = try settings.Settings.load(allocator, io, constants.ConfigFilePath);

    rl.initWindow(config.resolution.width, config.resolution.height, "kau");
    defer rl.closeWindow();

    const font = try rl.loadFont(constants.FontFilePath);
    defer rl.unloadFont(font);

    var k4 = overlay.Judgment4K.init(allocator, config, font);
    defer k4.deinit();

    for (1..128) |i| {
        const time: i64 = @as(i64, @intCast(i)) * 2400 - 1600;
        try k4.noteManager4K.appendShortConcurrentNote(.init(.key1, .key2, time, 1250));
        try k4.noteManager4K.appendShortConcurrentNote(.init(.key2, .key3, time + 100, 1250));
        try k4.noteManager4K.appendShortConcurrentNote(.init(.key1, .key2, time + 200, 1250));
        try k4.noteManager4K.appendShortConcurrentNote(.init(.key2, .key3, time + 300, 1250));
        try k4.noteManager4K.appendShortConcurrentNote(.init(.key1, .key2, time + 400, 1250));
        try k4.noteManager4K.appendShortConcurrentNote(.init(.key2, .key3, time + 500, 1250));
        try k4.noteManager4K.appendShortConcurrentNote(.init(.key1, .key2, time + 600, 1250));
        try k4.noteManager4K.appendShortConcurrentNote(.init(.key2, .key3, time + 700, 1250));
        try k4.noteManager4K.appendShortConcurrentNote(.init(.key1, .key2, time + 800, 1250));
        try k4.noteManager4K.appendShortConcurrentNote(.init(.key2, .key3, time + 900, 1250));
        try k4.noteManager4K.appendShortConcurrentNote(.init(.key1, .key2, time + 1000, 1250));
        try k4.noteManager4K.appendShortConcurrentNote(.init(.key2, .key3, time + 1100, 1250));

        try k4.noteManager4K.appendShortConcurrentNote(.init(.key3, .key4, time + 1200, 1250));
        try k4.noteManager4K.appendShortConcurrentNote(.init(.key2, .key3, time + 1300, 1250));
        try k4.noteManager4K.appendShortConcurrentNote(.init(.key3, .key4, time + 1400, 1250));
        try k4.noteManager4K.appendShortConcurrentNote(.init(.key2, .key3, time + 1500, 1250));
        try k4.noteManager4K.appendShortConcurrentNote(.init(.key3, .key4, time + 1600, 1250));
        try k4.noteManager4K.appendShortConcurrentNote(.init(.key2, .key3, time + 1700, 1250));
        try k4.noteManager4K.appendShortConcurrentNote(.init(.key3, .key4, time + 1800, 1250));
        try k4.noteManager4K.appendShortConcurrentNote(.init(.key2, .key3, time + 1900, 1250));
        try k4.noteManager4K.appendShortConcurrentNote(.init(.key3, .key4, time + 2000, 1250));
        try k4.noteManager4K.appendShortConcurrentNote(.init(.key2, .key3, time + 2100, 1250));
        try k4.noteManager4K.appendShortConcurrentNote(.init(.key3, .key4, time + 2200, 1250));
        try k4.noteManager4K.appendShortConcurrentNote(.init(.key2, .key3, time + 2300, 1250));
    }

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.black);

        k4.drawLine();
        try k4.drawScore();
        k4.keyPressEffect4K.draw();
        try k4.drawNote();
        try k4.renderNote();
        try k4.drawAccuracyGraph();
        try overlay.drawFPS(allocator, font);
    }
}
