const rl = @import("raylib");
const std = @import("std");
const arc = @import("arc");
const note = @import("note");
const accuracy = @import("accuracy");

pub const Judgment4K = struct {
    allocator: std.mem.Allocator,

    resolution: arc.Resolution,

    noteManager: note.Manager,
    accuracyManager: accuracy.Manager,

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
    keyPressColor: rl.Color,

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

    minMs: i64,
    maxMs: i64,

    pub inline fn init(allocator: std.mem.Allocator, font: rl.Font) Judgment4K {
        const minMs: i64 = -150;
        const maxMs: i64 = 150;

        const noteSizeX: i32 = 74;
        const noteSizeY: i32 = 24;

        const noteManager = note.Manager.init(allocator);
        const accuracyManager = accuracy.Manager.init(allocator, minMs, maxMs);

        const centerX: i32 = @divTrunc(arc.forDev.width, 2);

        const JLineY: i32 = arc.forDev.height - 100;

        return Judgment4K{
            .allocator = allocator,
            .resolution = arc.forDev,
            .noteManager = noteManager,
            .accuracyManager = accuracyManager,

            .noteSizeX = noteSizeX,
            .noteSizeY = noteSizeY,

            .note1X = centerX - @divTrunc(noteSizeX, 2) - noteSizeX,
            .note2X = centerX - @divTrunc(noteSizeX, 2),
            .note3X = centerX + @divTrunc(noteSizeX, 2),
            .note4X = centerX + @divTrunc(noteSizeX, 2) + noteSizeX,

            .JLineY = JLineY,

            .line1Color = .{ .r = 255, .g = 255, .b = 255, .a = 255 },
            .line2Color = .{ .r = 102, .g = 120, .b = 255, .a = 255 },
            .line3Color = .{ .r = 102, .g = 120, .b = 255, .a = 255 },
            .line4Color = .{ .r = 255, .g = 255, .b = 255, .a = 255 },

            .lineJColor = .{ .r = 248, .g = 229, .b = 73, .a = 100 },
            .concurrentLineColor = .{ .r = 255, .g = 165, .b = 0, .a = 255 },
            .keyPressColor = .{ .r = 255, .g = 255, .b = 255, .a = 100 },

            .accuracyColor = .{ .r = 255, .g = 255, .b = 255, .a = 255 },
            .accuracyOldColor = .{ .r = 255, .g = 255, .b = 255, .a = 75 },
            .accuracyLineColor = .{ .r = 191, .g = 191, .b = 255, .a = 255 },
            .accuracyCenterColor = .{ .r = 255, .g = 0, .b = 0, .a = 255 },

            .perfectColor = .{ .r = 255, .g = 255, .b = 255, .a = 255 },
            .earlyColor = .{ .r = 40, .g = 40, .b = 255, .a = 255 },
            .lateColor = .{ .r = 255, .g = 0, .b = 0, .a = 255 },
            .missColor = .{ .r = 255, .g = 255, .b = 255, .a = 100 },

            .key1 = .a,
            .key2 = .s,
            .key3 = .k,
            .key4 = .l,

            .font = font,

            .minMs = minMs,
            .maxMs = maxMs,
        };
    }

    pub inline fn deinit(self: *Judgment4K) void {
        self.noteManager.deinit();
        self.accuracyManager.deinit();
    }

    inline fn laneX(self: Judgment4K, key: note.KeyType) i32 {
        return switch (key) {
            .key1 => self.note1X,
            .key2 => self.note2X,
            .key3 => self.note3X,
            .key4 => self.note4X,
        };
    }

    inline fn laneColor(self: Judgment4K, key: note.KeyType) rl.Color {
        return switch (key) {
            .key1 => self.line1Color,
            .key2 => self.line2Color,
            .key3 => self.line3Color,
            .key4 => self.line4Color,
        };
    }

    inline fn keyPressed(self: Judgment4K, key: note.KeyType) bool {
        return switch (key) {
            .key1 => rl.isKeyPressed(self.key1),
            .key2 => rl.isKeyPressed(self.key2),
            .key3 => rl.isKeyPressed(self.key3),
            .key4 => rl.isKeyPressed(self.key4),
        };
    }

    inline fn keyDown(self: Judgment4K, key: note.KeyType) bool {
        return switch (key) {
            .key1 => rl.isKeyDown(self.key1),
            .key2 => rl.isKeyDown(self.key2),
            .key3 => rl.isKeyDown(self.key3),
            .key4 => rl.isKeyDown(self.key4),
        };
    }

    inline fn drawMarker(x: i32, y: i32, thickness: f32, color: rl.Color) void {
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

    inline fn calcDrawX(
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

    inline fn drawCenteredText(
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

    pub inline fn drawLine(self: *Judgment4K) void {
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

        inline for ([_]note.KeyType{
            .key1,
            .key2,
            .key3,
            .key4,
        }) |key| {
            if (self.keyDown(key)) {
                rl.drawRectangle(
                    self.laneX(key),
                    0,
                    self.noteSizeX,
                    self.resolution.height,
                    self.keyPressColor,
                );
            }
        }
    }

    pub inline fn drawShortNote(self: *Judgment4K) !void {
        const nowTime = rl.getTime();

        const posMs = @as(i64, @intFromFloat((nowTime - @as(f64, @floatFromInt(self.noteManager.currentTime))) * 1000.0));

        var idx: usize = 0;

        while (idx < self.noteManager.shorts.items.len) {
            const n = self.noteManager.shorts.items[idx];

            const spawnTime = n.hitTimeMs - n.fallDurationMs;

            if (posMs < spawnTime) {
                idx += 1;
                continue;
            }

            const elapsed = posMs - spawnTime;

            const targetY = self.JLineY + @divTrunc(self.noteSizeY, 2);

            const y: i32 = @as(i32, @intCast(@divTrunc(elapsed * @as(i64, @intCast(targetY)), n.fallDurationMs)));

            const noteDrawY: i32 = y - @divTrunc(self.noteSizeY, 2);

            if (noteDrawY > self.resolution.height) {
                try self.shortNoteEvent(idx, 0, true);
                continue;
            }

            rl.drawRectangle(
                self.laneX(n.keyType),
                noteDrawY,
                self.noteSizeX,
                self.noteSizeY,
                self.laneColor(n.keyType),
            );

            idx += 1;
        }
    }

    pub inline fn drawConcurrentNote(self: *Judgment4K) !void {
        const nowTime = rl.getTime();

        const posMs = @as(i64, @intFromFloat((nowTime - @as(f64, @floatFromInt(self.noteManager.currentTime))) * 1000.0));

        var idx: usize = 0;

        while (idx < self.noteManager.concurrents.items.len) {
            const n = self.noteManager.concurrents.items[idx];

            const spawnTime = n.hitTimeMs - n.fallDurationMs;

            if (posMs < spawnTime) {
                idx += 1;
                continue;
            }

            const elapsed = posMs - spawnTime;

            const targetY = self.JLineY + @divTrunc(self.noteSizeY, 2);

            const y: i32 = @as(i32, @intCast(@divTrunc(elapsed * @as(i64, @intCast(targetY)), n.fallDurationMs)));

            const noteDrawY: i32 = y - @divTrunc(self.noteSizeY, 2);

            if (noteDrawY > self.resolution.height) {
                try self.concurrentNoteEvent(idx, 0, true);
                continue;
            }

            rl.drawRectangle(
                self.laneX(n.keyType1),
                noteDrawY,
                self.noteSizeX,
                self.noteSizeY,
                self.concurrentLineColor,
            );

            rl.drawRectangle(
                self.laneX(n.keyType2),
                noteDrawY,
                self.noteSizeX,
                self.noteSizeY,
                self.concurrentLineColor,
            );

            idx += 1;
        }
    }

    pub inline fn drawAccuracyGraph(self: Judgment4K) !void {
        const accStartX: i32 = self.note1X + 20;
        const accEndX: i32 = self.note4X + self.noteSizeX - 20;

        const centerX: i32 = @divTrunc(accStartX + accEndX, 2);

        const accCenterY: i32 = self.JLineY + 58;

        const maxRange: f64 = blk: {
            if (@abs(self.minMs) > self.maxMs) {
                break :blk @as(
                    f64,
                    @floatFromInt(@abs(self.minMs)),
                );
            } else {
                break :blk @as(
                    f64,
                    @floatFromInt(self.maxMs),
                );
            }
        };

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

        var i: usize = self.accuracyManager.list.items.len;

        while (i > 0) : (count += 1) {
            i -= 1;

            const acc = self.accuracyManager.list.items[i];

            if (acc.miss) {
                if (first) {
                    first = false;
                    firstMiss = true;
                }

                sum += self.minMs;
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

    pub inline fn renderShortNote(self: *Judgment4K) !void {
        const nowTime = rl.getTime();

        const posMs = @as(i64, @intFromFloat((nowTime - @as(f64, @floatFromInt(self.noteManager.currentTime))) * 1000.0));

        var idx: usize = 0;

        while (idx < self.noteManager.shorts.items.len) {
            const n = self.noteManager.shorts.items[idx];

            const errors = n.hitTimeMs - posMs;

            var hit = false;

            if (errors <= self.maxMs and errors >= self.minMs) {
                hit = self.keyPressed(n.keyType);
            }

            if (hit) {
                try self.shortNoteEvent(idx, errors, false);
                break;
            }

            idx += 1;
        }
    }

    pub inline fn renderConcurrentNote(self: *Judgment4K) !void {
        const nowTime = rl.getTime();

        const posMs = @as(i64, @intFromFloat((nowTime - @as(f64, @floatFromInt(self.noteManager.currentTime))) * 1000.0));

        var idx: usize = 0;

        while (idx < self.noteManager.concurrents.items.len) {
            const n = self.noteManager.concurrents.items[idx];

            const errors = n.hitTimeMs - posMs;

            var hit = false;

            if (errors <= self.maxMs and errors >= self.minMs) {
                const hit1 = self.keyPressed(n.keyType1) and self.keyDown(n.keyType2);
                const hit2 = self.keyDown(n.keyType1) and self.keyPressed(n.keyType2);
                const hit3 = self.keyPressed(n.keyType1) and self.keyPressed(n.keyType2);
                hit = hit1 or hit2 or hit3;
            }

            if (hit) {
                try self.concurrentNoteEvent(idx, errors, false);
                break;
            }

            idx += 1;
        }
    }

    inline fn shortNoteEvent(
        self: *Judgment4K,
        idx: usize,
        ms: i64,
        miss: bool,
    ) !void {
        self.noteManager.deleteShortNote(idx);

        try self.accuracyManager.addAccuracy(
            accuracy.Accuracy.init(ms, miss),
        );
    }

    inline fn concurrentNoteEvent(
        self: *Judgment4K,
        idx: usize,
        ms: i64,
        miss: bool,
    ) !void {
        self.noteManager.deleteConcurrentNote(idx);

        try self.accuracyManager.addAccuracy(
            accuracy.Accuracy.init(ms, miss),
        );
    }
};
