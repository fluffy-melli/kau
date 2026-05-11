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

    pub inline fn init(allocator: std.mem.Allocator) Manager {
        return Manager{
            .allocator = allocator,
            .shortBasic = .empty,
            .shortConcurrent = .empty,
            .longBasic = .empty,
            .longConcurrent = .empty,
            .currentTime = 0,
        };
    }

    pub inline fn deinit(self: *Manager) void {
        self.shortBasic.deinit(self.allocator);
        self.shortConcurrent.deinit(self.allocator);
        self.longBasic.deinit(self.allocator);
        self.longConcurrent.deinit(self.allocator);
    }

    pub inline fn resetTime(self: *Manager) void {
        self.currentTime = @as(i64, @intFromFloat(rl.getTime()));
    }

    pub inline fn appendShortBasicNote(self: *Manager, note: short.Basic4K) !void {
        try self.shortBasic.append(self.allocator, note);
    }

    pub inline fn deleteShortBasicNote(self: *Manager, idx: usize) void {
        _ = self.shortBasic.swapRemove(idx);
    }

    pub inline fn resetShortBasicNote(self: *Manager) void {
        self.shortBasic.clearRetainingCapacity();
    }

    pub inline fn appendShortConcurrentNote(self: *Manager, note: short.Concurrent4K) !void {
        try self.shortConcurrent.append(self.allocator, note);
    }

    pub inline fn deleteShortConcurrentNote(self: *Manager, idx: usize) void {
        _ = self.shortConcurrent.swapRemove(idx);
    }

    pub inline fn resetShortConcurrentNote(self: *Manager) void {
        self.shortConcurrent.clearRetainingCapacity();
    }

    pub inline fn appendLongBasicNote(self: *Manager, note: long.Basic4K) !void {
        try self.longBasic.append(self.allocator, note);
    }

    pub inline fn deleteLongBasicNote(self: *Manager, idx: usize) void {
        _ = self.longBasic.swapRemove(idx);
    }

    pub inline fn resetLongBasicNote(self: *Manager) void {
        self.longBasic.clearRetainingCapacity();
    }

    pub inline fn appendLongConcurrentNote(self: *Manager, note: long.Concurrent4K) !void {
        try self.longConcurrent.append(self.allocator, note);
    }

    pub inline fn deleteLongConcurrentNote(self: *Manager, idx: usize) void {
        _ = self.longConcurrent.swapRemove(idx);
    }

    pub inline fn resetLongConcurrentNote(self: *Manager) void {
        self.longConcurrent.clearRetainingCapacity();
    }
};
