const rl = @import("raylib");
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

    pub inline fn draw(
        self: Basic4K,
        posMs: i64,
        note1X: i32,
        note2X: i32,
        note3X: i32,
        note4X: i32,
        JLineY: i32,
        screenHeight: i32,
        noteSizeX: i32,
        noteSizeY: i32,
        inlineColor: rl.Color,
        outlineColor: rl.Color,
    ) bool {
        const spawnTime = self.hitTimeMs - self.fallDurationMs;

        if (posMs < spawnTime) {
            return false;
        }

        const elapsed = posMs - spawnTime;

        const targetY = JLineY + @divTrunc(noteSizeY, 2);

        const y: i32 = @as(i32, @intCast(@divTrunc(elapsed * @as(i64, @intCast(targetY)), self.fallDurationMs)));

        const noteDrawY: i32 = y - @divTrunc(noteSizeY, 2);

        if (noteDrawY > screenHeight) {
            return true;
        }

        switch (self.keyType) {
            .key1 => rl.drawRectangle(
                note1X,
                noteDrawY,
                noteSizeX,
                noteSizeY,
                outlineColor,
            ),
            .key2 => rl.drawRectangle(
                note2X,
                noteDrawY,
                noteSizeX,
                noteSizeY,
                inlineColor,
            ),
            .key3 => rl.drawRectangle(
                note3X,
                noteDrawY,
                noteSizeX,
                noteSizeY,
                inlineColor,
            ),
            .key4 => rl.drawRectangle(
                note4X,
                noteDrawY,
                noteSizeX,
                noteSizeY,
                outlineColor,
            ),
        }

        return false;
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

    pub inline fn draw(
        self: Concurrent4K,
        posMs: i64,
        note1X: i32,
        note2X: i32,
        note3X: i32,
        note4X: i32,
        JLineY: i32,
        screenHeight: i32,
        noteSizeX: i32,
        noteSizeY: i32,
        color: rl.Color,
    ) bool {
        const spawnTime = self.hitTimeMs - self.fallDurationMs;

        if (posMs < spawnTime) {
            return false;
        }

        const elapsed = posMs - spawnTime;

        const targetY = JLineY + @divTrunc(noteSizeY, 2);

        const y: i32 = @as(i32, @intCast(@divTrunc(elapsed * @as(i64, @intCast(targetY)), self.fallDurationMs)));

        const noteDrawY: i32 = y - @divTrunc(noteSizeY, 2);

        if (noteDrawY > screenHeight) {
            return true;
        }

        switch (self.keyType1) {
            .key1 => rl.drawRectangle(
                note1X,
                noteDrawY,
                noteSizeX,
                noteSizeY,
                color,
            ),
            .key2 => rl.drawRectangle(
                note2X,
                noteDrawY,
                noteSizeX,
                noteSizeY,
                color,
            ),
            .key3 => rl.drawRectangle(
                note3X,
                noteDrawY,
                noteSizeX,
                noteSizeY,
                color,
            ),
            .key4 => rl.drawRectangle(
                note4X,
                noteDrawY,
                noteSizeX,
                noteSizeY,
                color,
            ),
        }

        switch (self.keyType2) {
            .key1 => rl.drawRectangle(
                note1X,
                noteDrawY,
                noteSizeX,
                noteSizeY,
                color,
            ),
            .key2 => rl.drawRectangle(
                note2X,
                noteDrawY,
                noteSizeX,
                noteSizeY,
                color,
            ),
            .key3 => rl.drawRectangle(
                note3X,
                noteDrawY,
                noteSizeX,
                noteSizeY,
                color,
            ),
            .key4 => rl.drawRectangle(
                note4X,
                noteDrawY,
                noteSizeX,
                noteSizeY,
                color,
            ),
        }

        return false;
    }
};
