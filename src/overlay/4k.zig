const rl = @import("raylib");
const std = @import("std");
const note = @import("note");
const types = @import("types");
const effect = @import("effect");
const settings = @import("settings");

pub const Judgment4K = struct {
    allocator: std.mem.Allocator,

    resolution: types.Resolution,

    noteEffect4K: effect.Note4K,
    keyPressEffect4K: effect.keyPressEffect4K,

    noteManager4K: note.Manager4K,

    noteSizeX: i32,
    noteSizeY: i32,

    note1X: i32,
    note2X: i32,
    note3X: i32,
    note4X: i32,
    JLineY: i32,

    line1Color: rl.Color,
    line2Color: rl.Color,
    line3Color: rl.Color,
    line4Color: rl.Color,
    lineJColor: rl.Color,
    concurrentLineColor: rl.Color,

    accuracyColor: rl.Color,
    accuracyOldColor: rl.Color,
    accuracyLineColor: rl.Color,
    accuracyCenterColor: rl.Color,

    perfectColor: rl.Color,
    earlyColor: rl.Color,
    lateColor: rl.Color,
    missColor: rl.Color,

    key1: rl.KeyboardKey,
    key2: rl.KeyboardKey,
    key3: rl.KeyboardKey,
    key4: rl.KeyboardKey,

    font: rl.Font,

    decisionTimeMs: i64,

    pub fn init(allocator: std.mem.Allocator, config: settings.Settings, font: rl.Font) Judgment4K {
        const decisionTimeMs: i64 = 150;

        const noteSizeX: i32 = 74;
        const noteSizeY: i32 = 24;

        const effectLengthMs: i64 = 250;

        const centerX: i32 = @divTrunc(config.resolution.width, 2);

        const note1X: i32 = centerX - @divTrunc(noteSizeX, 2) - noteSizeX;
        const note2X: i32 = centerX - @divTrunc(noteSizeX, 2);
        const note3X: i32 = centerX + @divTrunc(noteSizeX, 2);
        const note4X: i32 = centerX + @divTrunc(noteSizeX, 2) + noteSizeX;

        const JLineY: i32 = config.resolution.height - 100;

        const key1 = config.keybind.K4.key1;
        const key2 = config.keybind.K4.key2;
        const key3 = config.keybind.K4.key3;
        const key4 = config.keybind.K4.key4;

        const noteEffect4K = effect.Note4K.init(
            effectLengthMs,
            note1X,
            note2X,
            note3X,
            note4X,
            noteSizeX,
            noteSizeY,
            JLineY,
        );

        const keyPressEffect4K = effect.keyPressEffect4K.init(
            config.resolution,
            note1X,
            note2X,
            note3X,
            note4X,
            noteSizeX,
            noteSizeY,
            key1,
            key2,
            key3,
            key4,
        );

        const noteManager4K = note.Manager4K.init(
            allocator,
            decisionTimeMs,
            note1X,
            note2X,
            note3X,
            note4X,
            JLineY,
            config.resolution.height,
            noteSizeX,
            noteSizeY,
        );

        return Judgment4K{
            .allocator = allocator,
            .resolution = config.resolution,
            .noteEffect4K = noteEffect4K,
            .keyPressEffect4K = keyPressEffect4K,
            .noteManager4K = noteManager4K,

            .noteSizeX = noteSizeX,
            .noteSizeY = noteSizeY,

            .note1X = note1X,
            .note2X = note2X,
            .note3X = note3X,
            .note4X = note4X,

            .JLineY = JLineY,

            .line1Color = .{ .r = 255, .g = 255, .b = 255, .a = 255 },
            .line2Color = .{ .r = 102, .g = 120, .b = 255, .a = 255 },
            .line3Color = .{ .r = 102, .g = 120, .b = 255, .a = 255 },
            .line4Color = .{ .r = 255, .g = 255, .b = 255, .a = 255 },

            .lineJColor = .{ .r = 248, .g = 229, .b = 73, .a = 120 },
            .concurrentLineColor = .{ .r = 255, .g = 165, .b = 0, .a = 255 },

            .accuracyColor = .{ .r = 255, .g = 255, .b = 255, .a = 255 },
            .accuracyOldColor = .{ .r = 255, .g = 255, .b = 255, .a = 75 },
            .accuracyLineColor = .{ .r = 191, .g = 191, .b = 255, .a = 255 },
            .accuracyCenterColor = .{ .r = 255, .g = 0, .b = 0, .a = 255 },

            .perfectColor = .{ .r = 255, .g = 255, .b = 255, .a = 255 },
            .earlyColor = .{ .r = 40, .g = 40, .b = 255, .a = 255 },
            .lateColor = .{ .r = 255, .g = 0, .b = 0, .a = 255 },
            .missColor = .{ .r = 255, .g = 255, .b = 255, .a = 100 },

            .key1 = key1,
            .key2 = key2,
            .key3 = key3,
            .key4 = key4,

            .font = font,

            .decisionTimeMs = decisionTimeMs,
        };
    }

    pub fn deinit(self: *Judgment4K) void {
        self.noteManager4K.deinit();
    }

    fn keyPressed(self: Judgment4K, key: types.KeyType4K) bool {
        return switch (key) {
            .key1 => rl.isKeyPressed(self.key1),
            .key2 => rl.isKeyPressed(self.key2),
            .key3 => rl.isKeyPressed(self.key3),
            .key4 => rl.isKeyPressed(self.key4),
        };
    }

    fn keyReleased(self: Judgment4K, key: types.KeyType4K) bool {
        return switch (key) {
            .key1 => rl.isKeyReleased(self.key1),
            .key2 => rl.isKeyReleased(self.key2),
            .key3 => rl.isKeyReleased(self.key3),
            .key4 => rl.isKeyReleased(self.key4),
        };
    }

    fn keyDown(self: Judgment4K, key: types.KeyType4K) bool {
        return switch (key) {
            .key1 => rl.isKeyDown(self.key1),
            .key2 => rl.isKeyDown(self.key2),
            .key3 => rl.isKeyDown(self.key3),
            .key4 => rl.isKeyDown(self.key4),
        };
    }

    fn drawMarker(x: i32, y: i32, thickness: f32, color: rl.Color) void {
        rl.drawLineEx(
            rl.Vector2{
                .x = @floatFromInt(x),
                .y = @floatFromInt(y - 7),
            },
            rl.Vector2{
                .x = @floatFromInt(x),
                .y = @floatFromInt(y + 7),
            },
            thickness,
            color,
        );
    }

    fn calcDrawX(
        ms: f64,
        max_range: f64,
        center_x: i32,
        half_width: f64,
    ) i32 {
        var norm: f64 = ms / max_range;

        if (norm < -1.0) {
            norm = -1.0;
        }

        if (norm > 1.0) {
            norm = 1.0;
        }

        norm = -norm;

        return @intFromFloat(@as(f64, @floatFromInt(center_x)) + norm * half_width);
    }

    fn drawCenteredText(
        self: Judgment4K,
        text: [:0]const u8,
        x: f32,
        y: f32,
        size: f32,
        color: rl.Color,
    ) void {
        const textSize = rl.measureTextEx(self.font, text, size, 0);

        rl.drawTextEx(
            self.font,
            text,
            rl.Vector2{
                .x = x - textSize.x * 0.5,
                .y = y,
            },
            size,
            0,
            color,
        );
    }

    fn renderShortBasicNote(self: *Judgment4K) !void {
        const nowTime = rl.getTime();

        const posMs = @as(i64, @intFromFloat((nowTime - @as(f64, @floatFromInt(self.noteManager4K.currentTime))) * 1000.0));

        var idx: usize = 0;

        while (idx < self.noteManager4K.shortBasic.items.len) {
            const n = self.noteManager4K.shortBasic.items[idx];

            const errors = n.hitTimeMs - posMs;

            var hit = false;

            if (errors <= self.decisionTimeMs and errors >= -self.decisionTimeMs) {
                hit = self.keyPressed(n.keyType);
            }

            if (hit) {
                self.noteEffect4K.on(n.keyType);
                try self.noteEventShortBasic(idx, errors, false);
                break;
            }

            idx += 1;
        }
    }

    fn renderShortConcurrentNote(self: *Judgment4K) !void {
        const nowTime = rl.getTime();

        const posMs = @as(i64, @intFromFloat((nowTime - @as(f64, @floatFromInt(self.noteManager4K.currentTime))) * 1000.0));

        var idx: usize = 0;

        while (idx < self.noteManager4K.shortConcurrent.items.len) {
            const n = self.noteManager4K.shortConcurrent.items[idx];

            const errors = n.hitTimeMs - posMs;

            var hit = false;

            if (errors <= self.decisionTimeMs and errors >= -self.decisionTimeMs) {
                const hit1 = self.keyPressed(n.keyType1) and self.keyDown(n.keyType2);
                const hit2 = self.keyDown(n.keyType1) and self.keyPressed(n.keyType2);
                const hit3 = self.keyPressed(n.keyType1) and self.keyPressed(n.keyType2);
                hit = hit1 or hit2 or hit3;
            }

            if (hit) {
                self.noteEffect4K.on(n.keyType1);
                self.noteEffect4K.on(n.keyType2);
                try self.noteEventShortConcurrent(idx, errors, false);
                break;
            }

            idx += 1;
        }
    }

    fn renderLongBasicNote(self: *Judgment4K) !void {
        const nowTime = rl.getTime();

        const posMs = @as(i64, @intFromFloat((nowTime - @as(f64, @floatFromInt(self.noteManager4K.currentTime))) * 1000.0));

        var idx: usize = 0;

        while (idx < self.noteManager4K.longBasic.items.len) {
            var n = &self.noteManager4K.longBasic.items[idx];

            const hitErrors = n.hitTimeMs - posMs;
            const releaseErrors = n.hitTimeMs + n.holdingDurationMs - posMs;

            var deleted = false;

            if (!n.isPressed) {
                if (hitErrors <= self.decisionTimeMs and hitErrors >= -self.decisionTimeMs) {
                    if (self.keyPressed(n.keyType)) {
                        self.noteEffect4K.on(n.keyType);
                        n.isPressed = true;
                        try self.noteEventLongBasic(idx, hitErrors, false, false);
                    }
                } else if (hitErrors < -self.decisionTimeMs) {
                    try self.noteEventLongBasic(idx, hitErrors, true, false);
                    try self.noteEventLongBasic(idx, releaseErrors, true, true);
                    deleted = true;
                }
            } else {
                if (self.keyReleased(n.keyType)) {
                    if (releaseErrors <= self.decisionTimeMs and releaseErrors >= -self.decisionTimeMs) {
                        try self.noteEventLongBasic(idx, releaseErrors, false, true);
                        deleted = true;
                    } else {
                        try self.noteEventLongBasic(idx, releaseErrors, true, true);
                        deleted = true;
                    }
                } else if (releaseErrors < -self.decisionTimeMs) {
                    try self.noteEventLongBasic(idx, releaseErrors, true, true);
                    deleted = true;
                }
            }

            if (!deleted) {
                idx += 1;
            }
        }
    }

    fn renderLongConcurrentNote(self: *Judgment4K) !void {
        const nowTime = rl.getTime();

        const posMs = @as(i64, @intFromFloat((nowTime - @as(f64, @floatFromInt(self.noteManager4K.currentTime))) * 1000.0));

        var idx: usize = 0;

        while (idx < self.noteManager4K.longConcurrent.items.len) {
            var n = &self.noteManager4K.longConcurrent.items[idx];

            const hitErrors = n.hitTimeMs - posMs;
            const releaseErrors = n.hitTimeMs + n.holdingDurationMs - posMs;

            var deleted = false;

            if (!n.isPressed) {
                var hit = false;
                if (hitErrors <= self.decisionTimeMs and hitErrors >= -self.decisionTimeMs) {
                    const hit1 = self.keyPressed(n.keyType1) and self.keyDown(n.keyType2);
                    const hit2 = self.keyDown(n.keyType1) and self.keyPressed(n.keyType2);
                    const hit3 = self.keyPressed(n.keyType1) and self.keyPressed(n.keyType2);
                    hit = hit1 or hit2 or hit3;
                }

                if (hit) {
                    self.noteEffect4K.on(n.keyType1);
                    self.noteEffect4K.on(n.keyType2);
                    n.isPressed = true;
                    try self.noteEventLongConcurrent(idx, hitErrors, false, false);
                } else if (hitErrors < -self.decisionTimeMs) {
                    try self.noteEventLongConcurrent(idx, hitErrors, true, false);
                    try self.noteEventLongConcurrent(idx, releaseErrors, true, true);
                    deleted = true;
                }
            } else {
                var releaseHit = false;
                if (releaseErrors <= self.decisionTimeMs and releaseErrors >= -self.decisionTimeMs) {
                    const release1 = self.keyReleased(n.keyType1) and self.keyDown(n.keyType2);
                    const release2 = self.keyDown(n.keyType1) and self.keyReleased(n.keyType2);
                    const release3 = self.keyReleased(n.keyType1) and self.keyReleased(n.keyType2);
                    releaseHit = release1 or release2 or release3;
                }

                if (releaseHit) {
                    try self.noteEventLongConcurrent(idx, releaseErrors, false, true);
                    deleted = true;
                } else if (self.keyReleased(n.keyType1) or self.keyReleased(n.keyType2)) {
                    try self.noteEventLongConcurrent(idx, releaseErrors, false, true);
                    deleted = true;
                } else if (releaseErrors < -self.decisionTimeMs) {
                    try self.noteEventLongConcurrent(idx, releaseErrors, true, true);
                    deleted = true;
                }
            }

            if (!deleted) {
                idx += 1;
            }
        }
    }

    fn noteEventShortBasic(
        self: *Judgment4K,
        idx: usize,
        ms: i64,
        miss: bool,
    ) !void {
        self.noteManager4K.deleteShortBasicNote(idx);

        try self.noteManager4K.scoreManager.addAccuracy(.init(ms, miss));
    }

    fn noteEventShortConcurrent(
        self: *Judgment4K,
        idx: usize,
        ms: i64,
        miss: bool,
    ) !void {
        self.noteManager4K.deleteShortConcurrentNote(idx);

        try self.noteManager4K.scoreManager.addAccuracy(.init(ms, miss));
    }

    fn noteEventLongBasic(
        self: *Judgment4K,
        idx: usize,
        ms: i64,
        miss: bool,
        delete: bool,
    ) !void {
        if (delete) {
            self.noteManager4K.deleteLongBasicNote(idx);
        }

        try self.noteManager4K.scoreManager.addAccuracy(.init(ms, miss));
    }

    fn noteEventLongConcurrent(
        self: *Judgment4K,
        idx: usize,
        ms: i64,
        miss: bool,
        delete: bool,
    ) !void {
        if (delete) {
            self.noteManager4K.deleteLongConcurrentNote(idx);
        }

        try self.noteManager4K.scoreManager.addAccuracy(.init(ms, miss));
    }

    pub fn drawLine(self: *Judgment4K) void {
        rl.drawLineEx(
            rl.Vector2{
                .x = @floatFromInt(self.note1X),
                .y = 0,
            },
            rl.Vector2{
                .x = @floatFromInt(self.note1X),
                .y = @floatFromInt(self.resolution.height),
            },
            2,
            self.line1Color,
        );

        rl.drawLineEx(
            rl.Vector2{
                .x = @floatFromInt(self.note4X + self.noteSizeX),
                .y = 0,
            },
            rl.Vector2{
                .x = @floatFromInt(self.note4X + self.noteSizeX),
                .y = @floatFromInt(self.resolution.height),
            },
            2,
            self.line1Color,
        );

        rl.drawRectangle(
            self.note1X,
            self.JLineY,
            self.noteSizeX * 4,
            self.noteSizeY,
            self.lineJColor,
        );
    }

    pub fn drawNote(self: *Judgment4K) !void {
        try self.noteManager4K.drawShortBasicNote();
        try self.noteManager4K.drawShortConcurrentNote();
        try self.noteManager4K.drawLongBasicNote();
        try self.noteManager4K.drawLongConcurrentNote();
    }

    pub fn renderNote(self: *Judgment4K) !void {
        try self.renderShortBasicNote();
        try self.renderShortConcurrentNote();
        try self.renderLongBasicNote();
        try self.renderLongConcurrentNote();
    }

    pub fn drawAccuracyGraph(self: Judgment4K) !void {
        const accStartX: i32 = self.note1X + 20;
        const accEndX: i32 = self.note4X + self.noteSizeX - 20;

        const centerX: i32 = @divTrunc(accStartX + accEndX, 2);

        const accCenterY: i32 = self.JLineY + 58;

        const maxRange: f64 = @floatFromInt(self.decisionTimeMs);

        const halfWidth: f64 = @as(f64, @floatFromInt(accEndX - accStartX)) * 0.5;

        const centerXF: f32 = @floatFromInt(centerX);

        rl.drawLineEx(
            rl.Vector2{
                .x = @floatFromInt(accStartX),
                .y = @floatFromInt(accCenterY),
            },
            rl.Vector2{
                .x = @floatFromInt(accEndX),
                .y = @floatFromInt(accCenterY),
            },
            2,
            self.accuracyLineColor,
        );

        drawMarker(
            accStartX,
            accCenterY,
            2,
            self.accuracyLineColor,
        );

        drawMarker(
            accEndX,
            accCenterY,
            2,
            self.accuracyLineColor,
        );

        var count: i32 = 0;
        var sum: i64 = 0;

        var first: bool = true;

        var firstTime: i64 = 0;
        var firstMiss: bool = false;

        var i: usize = self.noteManager4K.scoreManager.accuracys.items.len;

        while (i > 0) : (count += 1) {
            i -= 1;

            const acc = self.noteManager4K.scoreManager.accuracys.items[i];

            if (acc.miss) {
                if (first) {
                    first = false;
                    firstMiss = true;
                }

                sum -= self.decisionTimeMs;
            } else {
                const drawX = calcDrawX(
                    @as(f64, @floatFromInt(acc.ms)),
                    maxRange,
                    centerX,
                    halfWidth,
                );

                if (first) {
                    first = false;
                    firstTime = acc.ms;

                    drawMarker(
                        drawX,
                        accCenterY,
                        2,
                        self.accuracyColor,
                    );
                } else {
                    drawMarker(
                        drawX,
                        accCenterY,
                        2,
                        self.accuracyOldColor,
                    );
                }

                sum += acc.ms;
            }
        }

        if (count > 0) {
            const avgMs: f64 = @as(f64, @floatFromInt(sum)) / @as(f64, @floatFromInt(count));

            const drawX = calcDrawX(
                avgMs,
                maxRange,
                centerX,
                halfWidth,
            );

            drawMarker(
                drawX,
                accCenterY,
                3,
                self.accuracyCenterColor,
            );
        } else {
            drawMarker(
                centerX,
                accCenterY,
                2,
                self.accuracyCenterColor,
            );
        }

        const textY: f32 = @floatFromInt(accCenterY + 12);

        if (firstMiss) {
            self.drawCenteredText(
                "miss",
                centerXF,
                textY,
                20,
                self.missColor,
            );
        } else if (firstTime >= 1) {
            const ms = try std.fmt.allocPrint(self.allocator, "+{d}ms", .{firstTime});
            defer self.allocator.free(ms);

            const cstr = try self.allocator.dupeZ(u8, ms);
            defer self.allocator.free(cstr);

            self.drawCenteredText(
                cstr,
                centerXF,
                textY,
                20,
                self.earlyColor,
            );
        } else if (firstTime <= -1) {
            const ms = try std.fmt.allocPrint(self.allocator, "-{d}ms", .{-firstTime});
            defer self.allocator.free(ms);

            const cstr = try self.allocator.dupeZ(u8, ms);
            defer self.allocator.free(cstr);

            self.drawCenteredText(
                cstr,
                centerXF,
                textY,
                20,
                self.lateColor,
            );
        } else {
            self.drawCenteredText(
                "0ms",
                centerXF,
                textY,
                20,
                self.perfectColor,
            );
        }

        self.drawCenteredText(
            "Early",
            @floatFromInt(accStartX + 7),
            @floatFromInt(accCenterY + 11),
            17,
            self.earlyColor,
        );

        self.drawCenteredText(
            "Late",
            @floatFromInt(accEndX - 7),
            @floatFromInt(accCenterY + 11),
            17,
            self.lateColor,
        );
    }
};
