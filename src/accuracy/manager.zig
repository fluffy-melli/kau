const std = @import("std");

pub const Accuracy = struct {
    ms: i64,
    miss: bool,

    pub fn init(ms: i64, miss: bool) Accuracy {
        return Accuracy{
            .ms = ms,
            .miss = miss,
        };
    }
};

pub const Manager = struct {
    allocator: std.mem.Allocator,

    list: std.ArrayList(Accuracy),

    minMs: i64,
    maxMs: i64,

    pub fn init(allocator: std.mem.Allocator, minMs: i64, maxMs: i64) Manager {
        return Manager{
            .allocator = allocator,
            .list = .empty,
            .minMs = minMs,
            .maxMs = maxMs,
        };
    }

    pub fn deinit(self: *Manager) void {
        self.list.deinit(self.allocator);
    }

    pub fn addAccuracy(self: *Manager, accuracy: Accuracy) !void {
        try self.list.append(self.allocator, accuracy);
    }

    pub fn getAccuracy(self: Manager) f64 {
        if (self.list.items.len == 0) {
            return 1.0;
        }

        var total: f64 = 0;
        var count: usize = 0;

        const min = @as(f64, @floatFromInt(self.minMs));
        const max = @as(f64, @floatFromInt(self.maxMs));

        for (self.list.items) |accuracy| {
            if (!accuracy.miss) {
                var norm: f64 = 0;

                if (accuracy.ms < 0) {
                    norm = @as(f64, @floatFromInt(accuracy.ms)) / min;
                } else {
                    norm = @as(f64, @floatFromInt(accuracy.ms)) / max;
                }

                var score = 1.0 - norm;

                if (score < 0.0) {
                    score = 0.0;
                }

                if (score > 1.0) {
                    score = 1.0;
                }

                total += score;
                count += 1;
            }
        }

        if (count == 0) {
            return 0.0;
        }

        return total / @as(f64, @floatFromInt(count));
    }
};
