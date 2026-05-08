const rl = @import("raylib");
const std = @import("std");
const short = @import("short.zig");

pub const Manager = struct {
    allocator: std.mem.Allocator,

    shorts: std.ArrayList(short.Short),

    currentTime: i64,

    pub fn init(allocator: std.mem.Allocator) Manager {
        return Manager{
            .allocator = allocator,
            .shorts = .empty,
            .currentTime = 0,
        };
    }

    pub fn deinit(self: *Manager) void {
        self.shorts.deinit(self.allocator);
    }

    pub fn resetTime(self: *Manager) void {
        self.currentTime = @as(i64, @intFromFloat(rl.getTime()));
    }

    pub fn appendShortNote(self: *Manager, note: short.Short) !void {
        try self.shorts.append(self.allocator, note);
    }

    pub fn deleteShortNote(self: *Manager, idx: usize) void {
        _ = self.shorts.swapRemove(idx);
    }

    pub fn resetShortNote(self: *Manager) void {
        self.shorts.clearRetainingCapacity();
    }
};
