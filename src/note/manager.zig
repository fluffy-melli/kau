const rl = @import("raylib");
const std = @import("std");
const short = @import("short.zig");
const concurrent = @import("concurrent.zig");

pub const Manager = struct {
    allocator: std.mem.Allocator,

    shorts: std.ArrayList(short.Short),
    concurrents: std.ArrayList(concurrent.Concurrent),

    currentTime: i64,

    pub inline fn init(allocator: std.mem.Allocator) Manager {
        return Manager{
            .allocator = allocator,
            .shorts = .empty,
            .concurrents = .empty,
            .currentTime = 0,
        };
    }

    pub inline fn deinit(self: *Manager) void {
        self.shorts.deinit(self.allocator);
        self.concurrents.deinit(self.allocator);
    }

    pub inline fn resetTime(self: *Manager) void {
        self.currentTime = @as(i64, @intFromFloat(rl.getTime()));
    }

    pub inline fn appendShortNote(self: *Manager, note: short.Short) !void {
        try self.shorts.append(self.allocator, note);
    }

    pub inline fn deleteShortNote(self: *Manager, idx: usize) void {
        _ = self.shorts.swapRemove(idx);
    }

    pub inline fn resetShortNote(self: *Manager) void {
        self.shorts.clearRetainingCapacity();
    }

    pub inline fn appendConcurrentNote(self: *Manager, note: concurrent.Concurrent) !void {
        try self.concurrents.append(self.allocator, note);
    }

    pub inline fn deleteConcurrentNote(self: *Manager, idx: usize) void {
        _ = self.concurrents.swapRemove(idx);
    }

    pub inline fn resetConcurrentNote(self: *Manager) void {
        self.concurrents.clearRetainingCapacity();
    }
};
