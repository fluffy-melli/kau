const types = @import("types");

pub const Concurrent = struct {
    keyType1: types.KeyType4K,
    keyType2: types.KeyType4K,

    hitTimeMs: i64,
    fallDurationMs: i64,

    pub inline fn init(
        keyType1: types.KeyType4K,
        keyType2: types.KeyType4K,
        hitTimeMs: i64,
        fallDurationMs: i64,
    ) Concurrent {
        return Concurrent{
            .keyType1 = keyType1,
            .keyType2 = keyType2,
            .hitTimeMs = hitTimeMs,
            .fallDurationMs = fallDurationMs,
        };
    }
};
