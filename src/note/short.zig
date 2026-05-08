const types = @import("types.zig");

pub const Short = struct {
    keyType: types.KeyType,
    reachTimeMs: i64,
    arrivalTimeMs: i64,

    pub fn init(
        keyType: types.KeyType,
        reachTimeMs: i64,
        arrivalTimeMs: i64,
    ) Short {
        return Short{
            .keyType = keyType,
            .reachTimeMs = reachTimeMs,
            .arrivalTimeMs = arrivalTimeMs,
        };
    }
};
