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

    pub fn init(allocator: std.mem.Allocator, font: rl.Font) Judgment4K {
        const minMs: i64 = -150;
        const maxMs: i64 = 150;

        const noteSizeX: i32 = 64;
        const noteSizeY: i32 = 16;

        const noteManager = note.Manager.init(allocator);
        const accuracyManager = accuracy.Manager.init(allocator, minMs, maxMs);

        const centerX: i32 = @divTrunc(arc.forDev.width, 2);

        const JLineY: i32 = arc.forDev.height - 100;
        const note1X: i32 = centerX - @divTrunc(noteSizeX, 2) - noteSizeX;
        const note2X: i32 = centerX - @divTrunc(noteSizeX, 2);
        const note3X: i32 = centerX + @divTrunc(noteSizeX, 2);
        const note4X: i32 = centerX + @divTrunc(noteSizeX, 2) + noteSizeX;

        return Judgment4K{
            .allocator = allocator,
            .resolution = arc.forDev,
            .noteManager = noteManager,
            .accuracyManager = accuracyManager,
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
            .lineJColor = .{ .r = 248, .g = 229, .b = 73, .a = 100 },
            .keyPressColor = .{ .r = 255, .g = 255, .b = 255, .a = 100 },
            .accuracyColor = .{ .r = 255, .g = 255, .b = 255, .a = 255 },
            .accuracyOldColor = .{ .r = 255, .g = 255, .b = 255, .a = 100 },
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

    pub fn deinit(self: *Judgment4K) void {
        self.noteManager.deinit();
        self.accuracyManager.deinit();
    }

    pub fn draw(self: *Judgment4K) !void {
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

        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        const accStartX: i32 = self.note1X + 20;
        const accEndX: i32 = self.note4X + self.noteSizeX - 20;
        const centerX: i32 = @divTrunc(accStartX + accEndX, 2);

        const accCenterY: i32 = self.JLineY + 50;

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

        rl.drawLineEx(
            rl.Vector2{
                .x = @floatFromInt(accStartX),
                .y = @floatFromInt(accCenterY - 7),
            },
            rl.Vector2{
                .x = @floatFromInt(accStartX),
                .y = @floatFromInt(accCenterY + 7),
            },
            2,
            self.accuracyLineColor,
        );

        rl.drawLineEx(
            rl.Vector2{
                .x = @floatFromInt(accEndX),
                .y = @floatFromInt(accCenterY - 7),
            },
            rl.Vector2{
                .x = @floatFromInt(accEndX),
                .y = @floatFromInt(accCenterY + 7),
            },
            2,
            self.accuracyLineColor,
        );

        var count: i32 = 0;
        var sum: i64 = 0;

        var first: bool = true;
        var i: usize = self.accuracyManager.list.items.len;

        var firstTime: i64 = 0;
        var firstMiss: bool = false;

        while (i > 0) {
            i -= 1;

            if (count >= 25) {
                break;
            }

            const acc = self.accuracyManager.list.items[i];

            if (acc.miss) {
                if (first) {
                    first = false;
                    firstMiss = true;
                }
                continue;
            }

            const maxRange: f64 = blk: {
                if (@abs(self.minMs) > self.maxMs) {
                    break :blk @as(f64, @floatFromInt(@abs(self.minMs)));
                } else {
                    break :blk @as(f64, @floatFromInt(self.maxMs));
                }
            };

            const ms: f64 = @as(f64, @floatFromInt(acc.ms));

            var norm: f64 = ms / maxRange;

            if (norm < -1.0) {
                norm = -1.0;
            }

            if (norm > 1.0) {
                norm = 1.0;
            }

            norm = -norm;

            const halfWidth: f64 = @as(f64, @floatFromInt(accEndX - accStartX)) * 0.5;

            const drawX: i32 = @intFromFloat(@as(f64, @floatFromInt(centerX)) + norm * halfWidth);

            if (first) {
                first = false;
                firstTime = acc.ms;
                rl.drawLineEx(
                    rl.Vector2{
                        .x = @floatFromInt(drawX),
                        .y = @floatFromInt(accCenterY - 7),
                    },
                    rl.Vector2{
                        .x = @floatFromInt(drawX),
                        .y = @floatFromInt(accCenterY + 7),
                    },
                    2,
                    self.accuracyColor,
                );
            } else {
                rl.drawLineEx(
                    rl.Vector2{
                        .x = @floatFromInt(drawX),
                        .y = @floatFromInt(accCenterY - 7),
                    },
                    rl.Vector2{
                        .x = @floatFromInt(drawX),
                        .y = @floatFromInt(accCenterY + 7),
                    },
                    2,
                    self.accuracyOldColor,
                );
            }

            sum += acc.ms;
            count += 1;
        }

        if (count > 0) {
            const avgMs: f64 =
                @as(f64, @floatFromInt(sum)) / @as(f64, @floatFromInt(count));

            const maxRange: f64 = blk: {
                if (@abs(self.minMs) > self.maxMs) {
                    break :blk @as(f64, @floatFromInt(@abs(self.minMs)));
                } else {
                    break :blk @as(f64, @floatFromInt(self.maxMs));
                }
            };

            var norm: f64 = avgMs / maxRange;

            if (norm < -1.0) {
                norm = -1.0;
            }

            if (norm > 1.0) {
                norm = 1.0;
            }

            norm = -norm;

            const halfWidth: f64 = @as(f64, @floatFromInt(accEndX - accStartX)) * 0.5;

            const drawX: i32 = @intFromFloat(@as(f64, @floatFromInt(centerX)) + norm * halfWidth);

            rl.drawLineEx(
                rl.Vector2{
                    .x = @floatFromInt(drawX),
                    .y = @floatFromInt(accCenterY - 7),
                },
                rl.Vector2{
                    .x = @floatFromInt(drawX),
                    .y = @floatFromInt(accCenterY + 7),
                },
                3,
                self.accuracyCenterColor,
            );
        } else {
            rl.drawLineEx(
                rl.Vector2{
                    .x = @floatFromInt(centerX),
                    .y = @floatFromInt(accCenterY - 7),
                },
                rl.Vector2{
                    .x = @floatFromInt(centerX),
                    .y = @floatFromInt(accCenterY + 7),
                },
                2,
                self.accuracyCenterColor,
            );
        }

        if (firstMiss) {
            const textSize = rl.measureTextEx(self.font, "miss", 15, 0);

            rl.drawTextEx(
                self.font,
                "miss",
                rl.Vector2{
                    .x = @as(f32, @floatFromInt(centerX)) - textSize.x * 0.5,
                    .y = @floatFromInt(accCenterY + 12),
                },
                15,
                0,
                self.missColor,
            );
        } else if (firstTime >= 1) {
            const ms = try std.fmt.allocPrint(self.allocator, "+{d}ms", .{firstTime});
            defer self.allocator.free(ms);

            const cstr = try self.allocator.dupeZ(u8, ms);
            defer self.allocator.free(cstr);

            const textSize = rl.measureTextEx(self.font, cstr, 15, 0);

            rl.drawTextEx(
                self.font,
                cstr,
                rl.Vector2{
                    .x = @as(f32, @floatFromInt(centerX)) - textSize.x * 0.5,
                    .y = @floatFromInt(accCenterY + 12),
                },
                15,
                0,
                self.earlyColor,
            );
        } else if (firstTime <= -1) {
            const ms = try std.fmt.allocPrint(self.allocator, "-{d}ms", .{-firstTime});
            defer self.allocator.free(ms);

            const cstr = try self.allocator.dupeZ(u8, ms);
            defer self.allocator.free(cstr);

            const textSize = rl.measureTextEx(self.font, cstr, 15, 0);

            rl.drawTextEx(
                self.font,
                cstr,
                rl.Vector2{
                    .x = @as(f32, @floatFromInt(centerX)) - textSize.x * 0.5,
                    .y = @floatFromInt(accCenterY + 12),
                },
                15,
                0,
                self.lateColor,
            );
        } else {
            const textSize = rl.measureTextEx(self.font, "0ms", 15, 0);

            rl.drawTextEx(
                self.font,
                "0ms",
                rl.Vector2{
                    .x = @as(f32, @floatFromInt(centerX)) - textSize.x * 0.5,
                    .y = @floatFromInt(accCenterY + 12),
                },
                15,
                0,
                self.perfectColor,
            );
        }

        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        if (rl.isKeyDown(self.key1)) {
            rl.drawRectangle(
                self.note1X,
                0,
                self.noteSizeX,
                self.resolution.height,
                self.keyPressColor,
            );
        }

        if (rl.isKeyDown(self.key2)) {
            rl.drawRectangle(
                self.note2X,
                0,
                self.noteSizeX,
                self.resolution.height,
                self.keyPressColor,
            );
        }

        if (rl.isKeyDown(self.key3)) {
            rl.drawRectangle(
                self.note3X,
                0,
                self.noteSizeX,
                self.resolution.height,
                self.keyPressColor,
            );
        }

        if (rl.isKeyDown(self.key4)) {
            rl.drawRectangle(
                self.note4X,
                0,
                self.noteSizeX,
                self.resolution.height,
                self.keyPressColor,
            );
        }

        const nowTime = rl.getTime();
        const posMs = @as(i64, @intFromFloat((nowTime - @as(f64, @floatFromInt(self.noteManager.currentTime))) * 1000.0));

        var idx: usize = 0;
        while (idx < self.noteManager.shorts.items.len) {
            const n = self.noteManager.shorts.items[idx];

            const spawnTime = n.arrivalTimeMs - n.reachTimeMs;
            if (posMs < spawnTime) {
                idx += 1;
                continue;
            }

            const elapsed = posMs - spawnTime;
            const targetY = self.JLineY + @divTrunc(self.noteSizeY, 2);

            const y: i32 = @as(i32, @intCast(@divTrunc(elapsed * @as(i64, @intCast(targetY)), n.reachTimeMs)));

            const noteDrawY: i32 = y - @divTrunc(self.noteSizeY, 2);

            if (noteDrawY > self.resolution.height) {
                try self.noteEvent(idx, 0, true);
                continue;
            }

            switch (n.keyType) {
                .key1 => rl.drawRectangle(
                    self.note1X,
                    noteDrawY,
                    self.noteSizeX,
                    self.noteSizeY,
                    self.line1Color,
                ),
                .key2 => rl.drawRectangle(
                    self.note2X,
                    noteDrawY,
                    self.noteSizeX,
                    self.noteSizeY,
                    self.line2Color,
                ),
                .key3 => rl.drawRectangle(
                    self.note3X,
                    noteDrawY,
                    self.noteSizeX,
                    self.noteSizeY,
                    self.line3Color,
                ),
                .key4 => rl.drawRectangle(
                    self.note4X,
                    noteDrawY,
                    self.noteSizeX,
                    self.noteSizeY,
                    self.line4Color,
                ),
            }
            idx += 1;
        }
    }

    pub fn render(self: *Judgment4K) !void {
        const nowTime = rl.getTime();
        const posMs = @as(i64, @intFromFloat((nowTime - @as(f64, @floatFromInt(self.noteManager.currentTime))) * 1000.0));

        var idx: usize = 0;
        while (idx < self.noteManager.shorts.items.len) {
            const n = self.noteManager.shorts.items[idx];
            const errors = n.arrivalTimeMs - posMs;

            var hit = false;
            if (errors <= self.maxMs and errors >= self.minMs) {
                hit = switch (n.keyType) {
                    .key1 => rl.isKeyPressed(self.key1),
                    .key2 => rl.isKeyPressed(self.key2),
                    .key3 => rl.isKeyPressed(self.key3),
                    .key4 => rl.isKeyPressed(self.key4),
                };
            }

            if (hit) {
                try self.noteEvent(idx, errors, false);
                break;
            } else {
                idx += 1;
            }
        }
    }

    fn noteEvent(self: *Judgment4K, idx: usize, ms: i64, miss: bool) !void {
        self.noteManager.deleteShortNote(idx);
        try self.accuracyManager.addAccuracy(accuracy.Accuracy.init(ms, miss));
    }
};
