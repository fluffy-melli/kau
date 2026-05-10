const types = @import("types.zig");

pub const Short = struct {
    keyType: types.KeyType,

    hitTimeMs: i64,
    fallDurationMs: i64,

    pub inline fn init(
        keyType: types.KeyType,
        hitTimeMs: i64,
        fallDurationMs: i64,
    ) Short {
        return Short{
            .keyType = keyType,
            .hitTimeMs = hitTimeMs,
            .fallDurationMs = fallDurationMs,
        };
    }
};
