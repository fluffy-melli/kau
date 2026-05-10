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

        try k4.noteManager.appendShortNote(.init(.key1, offsetI64 * 1250, 750));

        try k4.noteManager.appendShortNote(.init(.key2, (offsetI64 * 1250) + 125, 750));

        try k4.noteManager.appendConcurrentNote(.init(.key3, .key4, (offsetI64 * 1250) + 250, 750));

        try k4.noteManager.appendShortNote(.init(.key4, (offsetI64 * 1250) + 600, 750));

        try k4.noteManager.appendShortNote(.init(.key3, (offsetI64 * 1250) + 725, 750));

        try k4.noteManager.appendConcurrentNote(.init(.key1, .key2, (offsetI64 * 1250) + 850, 750));
    }

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.black);

        k4.drawLine();
        k4.noteEffect4K.draw();
        k4.keyPressEffect4K.draw();
        try overlay.drawFPS(allocator, font);
        try k4.drawShortNote();
        try k4.drawConcurrentNote();
        try k4.drawAccuracyGraph();
        try k4.renderShortNote();
        try k4.renderConcurrentNote();
    }
}
