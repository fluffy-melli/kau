const types = @import("types");

pub const Basic4K = struct {
    keyType: types.KeyType4K,

    hitTimeMs: i64,
    fallDurationMs: i64,

    pub fn init(
        keyType: types.KeyType4K,
        hitTimeMs: i64,
        fallDurationMs: i64,
    ) Basic4K {
        return Basic4K{
            .keyType = keyType,
            .hitTimeMs = hitTimeMs,
            .fallDurationMs = fallDurationMs,
        };
    }
};

pub const Concurrent4K = struct {
    keyType1: types.KeyType4K,
    keyType2: types.KeyType4K,

    hitTimeMs: i64,
    fallDurationMs: i64,

    pub fn init(
        keyType1: types.KeyType4K,
        keyType2: types.KeyType4K,
        hitTimeMs: i64,
        fallDurationMs: i64,
    ) Concurrent4K {
        return Concurrent4K{
            .keyType1 = keyType1,
            .keyType2 = keyType2,
            .hitTimeMs = hitTimeMs,
            .fallDurationMs = fallDurationMs,
        };
    }
};
