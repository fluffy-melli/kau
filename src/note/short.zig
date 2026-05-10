const types = @import("types");

pub const Short = struct {
    keyType: types.KeyType4K,

    hitTimeMs: i64,
    fallDurationMs: i64,

    pub inline fn init(
        keyType: types.KeyType4K,
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
