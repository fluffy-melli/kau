const rl = @import("raylib");
const std = @import("std");
const long = @import("long.zig");
const short = @import("short.zig");

pub const Manager = struct {
    allocator: std.mem.Allocator,

    shortBasic: std.ArrayList(short.Basic4K),
    shortConcurrent: std.ArrayList(short.Concurrent4K),

    longBasic: std.ArrayList(long.Basic4K),
    longConcurrent: std.ArrayList(long.Concurrent4K),

    currentTime: i64,

    pub fn init(allocator: std.mem.Allocator) Manager {
        return Manager{
            .allocator = allocator,
            .shortBasic = .empty,
            .shortConcurrent = .empty,
            .longBasic = .empty,
            .longConcurrent = .empty,
            .currentTime = 0,
        };
    }

    pub fn deinit(self: *Manager) void {
        self.shortBasic.deinit(self.allocator);
        self.shortConcurrent.deinit(self.allocator);
        self.longBasic.deinit(self.allocator);
        self.longConcurrent.deinit(self.allocator);
    }

    pub fn resetTime(self: *Manager) void {
        self.currentTime = @as(i64, @intFromFloat(rl.getTime()));
    }

    pub fn appendShortBasicNote(self: *Manager, note: short.Basic4K) !void {
        try self.shortBasic.append(self.allocator, note);
    }

    pub fn deleteShortBasicNote(self: *Manager, idx: usize) void {
        _ = self.shortBasic.swapRemove(idx);
    }

    pub fn resetShortBasicNote(self: *Manager) void {
        self.shortBasic.clearRetainingCapacity();
    }

    pub fn appendShortConcurrentNote(self: *Manager, note: short.Concurrent4K) !void {
        try self.shortConcurrent.append(self.allocator, note);
    }

    pub fn deleteShortConcurrentNote(self: *Manager, idx: usize) void {
        _ = self.shortConcurrent.swapRemove(idx);
    }

    pub fn resetShortConcurrentNote(self: *Manager) void {
        self.shortConcurrent.clearRetainingCapacity();
    }

    pub fn appendLongBasicNote(self: *Manager, note: long.Basic4K) !void {
        try self.longBasic.append(self.allocator, note);
    }

    pub fn deleteLongBasicNote(self: *Manager, idx: usize) void {
        _ = self.longBasic.swapRemove(idx);
    }

    pub fn resetLongBasicNote(self: *Manager) void {
        self.longBasic.clearRetainingCapacity();
    }

    pub fn appendLongConcurrentNote(self: *Manager, note: long.Concurrent4K) !void {
        try self.longConcurrent.append(self.allocator, note);
    }

    pub fn deleteLongConcurrentNote(self: *Manager, idx: usize) void {
        _ = self.longConcurrent.swapRemove(idx);
    }

    pub fn resetLongConcurrentNote(self: *Manager) void {
        self.longConcurrent.clearRetainingCapacity();
    }
};
