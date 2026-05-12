const std = @import("std");
const accuracy = @import("accuracy.zig");
const constants = @import("constants");

pub const Manager = struct {
    allocator: std.mem.Allocator,

    accuracys: std.ArrayList(accuracy.Accuracy),

    pub fn init(allocator: std.mem.Allocator) Manager {
        return Manager{
            .allocator = allocator,
            .accuracys = .empty,
        };
    }

    pub fn deinit(self: *Manager) void {
        self.accuracys.deinit(self.allocator);
    }

    pub fn addAccuracy(self: *Manager, a: accuracy.Accuracy) !void {
        try self.accuracys.append(self.allocator, a);
    }

    pub fn resetAccuracy(self: *Manager) void {
        self.accuracys.clearRetainingCapacity();
    }

    pub fn getScore(self: Manager, lower: bool) i64 {
        var score: i64 = 0;

        for (self.accuracys.items) |a| {
            score += a.getScore(constants.DecisionTimeMs, lower);
        }

        return score;
    }
};
