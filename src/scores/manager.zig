const std = @import("std");
const accuracy = @import("accuracy.zig");

pub const Manager = struct {
    allocator: std.mem.Allocator,

    accuracys: std.ArrayList(accuracy.Accuracy),

    decisionTimeMs: i64,

    pub fn init(allocator: std.mem.Allocator, decisionTimeMs: i64) Manager {
        return Manager{
            .allocator = allocator,
            .accuracys = .empty,
            .decisionTimeMs = decisionTimeMs,
        };
    }

    pub fn deinit(self: *Manager) void {
        self.accuracys.deinit(self.allocator);
    }

    pub fn addAccuracy(self: *Manager, a: accuracy.Accuracy) !void {
        try self.accuracys.append(self.allocator, a);
    }

    pub fn deleteAccuracy(self: *Manager, index: usize) void {
        _ = self.accuracys.swapRemove(index);
    }

    pub fn resetAccuracy(self: *Manager) void {
        self.accuracys.clearRetainingCapacity();
    }
};
