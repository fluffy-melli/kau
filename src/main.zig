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

    const font = try rl.loadFont("resources/NotoSansKR-Bold.ttf");
    defer rl.unloadFont(font);

    var k4 = overlay.Judgment4K.init(allocator, font);
    defer k4.deinit();

    for (1..64) |offset| {
        const offsetI64: i64 = @intCast(offset);

        try k4.noteManager.appendShortNote(.{
            .keyType = .key1,
            .hitTimeMs = (offsetI64 * 1250),
            .fallDurationMs = 750,
        });

        try k4.noteManager.appendShortNote(.{
            .keyType = .key2,
            .hitTimeMs = (offsetI64 * 1250) + 125,
            .fallDurationMs = 750,
        });

        try k4.noteManager.appendConcurrentNote(.{
            .keyType1 = .key3,
            .keyType2 = .key4,
            .hitTimeMs = (offsetI64 * 1250) + 250,
            .fallDurationMs = 750,
        });

        try k4.noteManager.appendShortNote(.{
            .keyType = .key4,
            .hitTimeMs = (offsetI64 * 1250) + 600,
            .fallDurationMs = 750,
        });

        try k4.noteManager.appendShortNote(.{
            .keyType = .key3,
            .hitTimeMs = (offsetI64 * 1250) + 725,
            .fallDurationMs = 750,
        });

        try k4.noteManager.appendConcurrentNote(.{
            .keyType1 = .key1,
            .keyType2 = .key2,
            .hitTimeMs = (offsetI64 * 1250) + 850,
            .fallDurationMs = 750,
        });
    }

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(.black);

        window.beginVirtual();
        rl.clearBackground(.black);

        try overlay.drawFPS(allocator, font);
        try k4.drawShortNote();
        try k4.drawConcurrentNote();
        try k4.drawAccuracyGraph();
        try k4.renderShortNote();
        try k4.renderConcurrentNote();
        k4.drawLine();

        window.endVirtual();
    }
}
