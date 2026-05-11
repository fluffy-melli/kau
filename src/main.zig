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

    for (1..64) |offset| {
        const offsetI64: i64 = @intCast(offset);

        try k4.noteManager.appendLongBasicNote(.init(.key1, offsetI64 * 3500, 1000, 1000));

        try k4.noteManager.appendLongConcurrentNote(.init(.key3, .key4, offsetI64 * 3500 + 1500, 1000, 1000));
    }

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.black);

        k4.drawLine();
        k4.noteEffect4K.draw();
        k4.keyPressEffect4K.draw();
        try k4.drawNote();
        try k4.drawAccuracyGraph();
        try overlay.drawFPS(allocator, font);
    }
}
