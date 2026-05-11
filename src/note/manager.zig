const rl = @import("raylib");
const std = @import("std");
const long = @import("long.zig");
const short = @import("short.zig");
const scores = @import("scores");

pub const Manager4K = struct {
    allocator: std.mem.Allocator,

    shortBasic: std.ArrayList(short.Basic4K),
    shortConcurrent: std.ArrayList(short.Concurrent4K),

    longBasic: std.ArrayList(long.Basic4K),
    longConcurrent: std.ArrayList(long.Concurrent4K),

    scoreManager: scores.Manager,
    currentTime: i64,

    note1X: i32,
    note2X: i32,
    note3X: i32,
    note4X: i32,
    JLineY: i32,
    screenHeight: i32,
    noteSizeX: i32,
    noteSizeY: i32,

    innerHeadColor: rl.Color,
    innerBodyColor: rl.Color,
    outerHeadColor: rl.Color,
    outerBodyColor: rl.Color,
    concurrentHeadColor: rl.Color,
    concurrentBodyColor: rl.Color,

    pub fn init(
        allocator: std.mem.Allocator,
        decisionTimeMs: i64,
        note1X: i32,
        note2X: i32,
        note3X: i32,
        note4X: i32,
        JLineY: i32,
        screenHeight: i32,
        noteSizeX: i32,
        noteSizeY: i32,
    ) Manager4K {
        const scoreManager = scores.Manager.init(allocator, decisionTimeMs);
        return Manager4K{
            .allocator = allocator,
            .shortBasic = .empty,
            .shortConcurrent = .empty,
            .longBasic = .empty,
            .longConcurrent = .empty,
            .currentTime = 0,
            .scoreManager = scoreManager,
            .note1X = note1X,
            .note2X = note2X,
            .note3X = note3X,
            .note4X = note4X,
            .JLineY = JLineY,
            .screenHeight = screenHeight,
            .noteSizeX = noteSizeX,
            .noteSizeY = noteSizeY,
            .innerHeadColor = .{ .r = 102, .g = 120, .b = 255, .a = 255 },
            .innerBodyColor = .{ .r = 102, .g = 120, .b = 255, .a = 150 },
            .outerHeadColor = .{ .r = 255, .g = 255, .b = 255, .a = 255 },
            .outerBodyColor = .{ .r = 255, .g = 255, .b = 255, .a = 150 },
            .concurrentHeadColor = .{ .r = 255, .g = 165, .b = 0, .a = 255 },
            .concurrentBodyColor = .{ .r = 255, .g = 165, .b = 0, .a = 150 },
        };
    }

    pub fn deinit(self: *Manager4K) void {
        self.shortBasic.deinit(self.allocator);
        self.shortConcurrent.deinit(self.allocator);
        self.longBasic.deinit(self.allocator);
        self.longConcurrent.deinit(self.allocator);
        self.scoreManager.deinit();
    }

    pub fn resetTime(self: *Manager4K) void {
        self.currentTime = @as(i64, @intFromFloat(rl.getTime()));
    }

    pub fn appendShortBasicNote(self: *Manager4K, note: short.Basic4K) !void {
        try self.shortBasic.append(self.allocator, note);
    }

    pub fn deleteShortBasicNote(self: *Manager4K, idx: usize) void {
        _ = self.shortBasic.swapRemove(idx);
    }

    pub fn resetShortBasicNote(self: *Manager4K) void {
        self.shortBasic.clearRetainingCapacity();
    }

    pub fn appendShortConcurrentNote(self: *Manager4K, note: short.Concurrent4K) !void {
        try self.shortConcurrent.append(self.allocator, note);
    }

    pub fn deleteShortConcurrentNote(self: *Manager4K, idx: usize) void {
        _ = self.shortConcurrent.swapRemove(idx);
    }

    pub fn resetShortConcurrentNote(self: *Manager4K) void {
        self.shortConcurrent.clearRetainingCapacity();
    }

    pub fn appendLongBasicNote(self: *Manager4K, note: long.Basic4K) !void {
        try self.longBasic.append(self.allocator, note);
    }

    pub fn deleteLongBasicNote(self: *Manager4K, idx: usize) void {
        _ = self.longBasic.swapRemove(idx);
    }

    pub fn resetLongBasicNote(self: *Manager4K) void {
        self.longBasic.clearRetainingCapacity();
    }

    pub fn appendLongConcurrentNote(self: *Manager4K, note: long.Concurrent4K) !void {
        try self.longConcurrent.append(self.allocator, note);
    }

    pub fn deleteLongConcurrentNote(self: *Manager4K, idx: usize) void {
        _ = self.longConcurrent.swapRemove(idx);
    }

    pub fn resetLongConcurrentNote(self: *Manager4K) void {
        self.longConcurrent.clearRetainingCapacity();
    }

    pub fn drawShortBasicNote(
        self: *Manager4K,
    ) !void {
        var idx: usize = 0;
        while (idx < self.shortBasic.items.len) {
            var note = self.shortBasic.items[idx];
            const del = note.draw(
                @as(i64, @intFromFloat((rl.getTime() - @as(f64, @floatFromInt(self.currentTime))) * 1000.0)),
                self.note1X,
                self.note2X,
                self.note3X,
                self.note4X,
                self.JLineY,
                self.screenHeight,
                self.noteSizeX,
                self.noteSizeY,
                self.innerHeadColor,
                self.outerHeadColor,
            );

            if (!del) {
                idx += 1;
                continue;
            }

            _ = self.shortBasic.swapRemove(idx);
            try self.scoreManager.addAccuracy(.init(0, true));
        }
    }

    pub fn drawShortConcurrentNote(
        self: *Manager4K,
    ) !void {
        var idx: usize = 0;
        while (idx < self.shortConcurrent.items.len) {
            var note = self.shortConcurrent.items[idx];
            const del = note.draw(
                @as(i64, @intFromFloat((rl.getTime() - @as(f64, @floatFromInt(self.currentTime))) * 1000.0)),
                self.note1X,
                self.note2X,
                self.note3X,
                self.note4X,
                self.JLineY,
                self.screenHeight,
                self.noteSizeX,
                self.noteSizeY,
                self.concurrentHeadColor,
            );

            if (!del) {
                idx += 1;
                continue;
            }

            _ = self.shortConcurrent.swapRemove(idx);
            try self.scoreManager.addAccuracy(.init(0, true));
        }
    }

    pub fn drawLongBasicNote(
        self: *Manager4K,
    ) !void {
        var idx: usize = 0;
        while (idx < self.longBasic.items.len) {
            var note = self.longBasic.items[idx];
            const del = note.draw(
                @as(i64, @intFromFloat((rl.getTime() - @as(f64, @floatFromInt(self.currentTime))) * 1000.0)),
                self.note1X,
                self.note2X,
                self.note3X,
                self.note4X,
                self.JLineY,
                self.screenHeight,
                self.noteSizeX,
                self.noteSizeY,
                self.innerHeadColor,
                self.innerBodyColor,
                self.outerHeadColor,
                self.outerBodyColor,
            );

            if (!del) {
                idx += 1;
                continue;
            }

            _ = self.longBasic.swapRemove(idx);
            try self.scoreManager.addAccuracy(.init(0, true));
        }
    }

    pub fn drawLongConcurrentNote(
        self: *Manager4K,
    ) !void {
        var idx: usize = 0;
        while (idx < self.longConcurrent.items.len) {
            var note = self.longConcurrent.items[idx];
            const del = note.draw(
                @as(i64, @intFromFloat((rl.getTime() - @as(f64, @floatFromInt(self.currentTime))) * 1000.0)),
                self.note1X,
                self.note2X,
                self.note3X,
                self.note4X,
                self.JLineY,
                self.screenHeight,
                self.noteSizeX,
                self.noteSizeY,
                self.concurrentHeadColor,
                self.concurrentBodyColor,
            );

            if (!del) {
                idx += 1;
                continue;
            }

            _ = self.longConcurrent.swapRemove(idx);
            try self.scoreManager.addAccuracy(.init(0, true));
        }
    }
};
