const std = @import("std");
const types = @import("types");
const constants = @import("constants");

pub const Keybind = struct {
    K4: types.Bind4K,
};

pub const Settings = struct {
    keybind: Keybind,
    resolution: types.Resolution,

    pub fn load(allocator: std.mem.Allocator, io: std.Io, path: []const u8) !Settings {
        const file = try std.Io.Dir.cwd().openFile(io, path, .{});
        defer file.close(io);

        var buffer: [1024]u8 = undefined;
        var reader = file.reader(io, &buffer);

        var alloc_writer = std.Io.Writer.Allocating.init(allocator);
        defer alloc_writer.deinit();

        _ = try reader.interface.streamRemaining(&alloc_writer.writer);

        const json_bytes = try alloc_writer.toOwnedSlice();
        defer allocator.free(json_bytes);

        const parsed = try std.json.parseFromSlice(Settings, allocator, json_bytes, .{});
        defer parsed.deinit();

        return parsed.value;
    }
};
