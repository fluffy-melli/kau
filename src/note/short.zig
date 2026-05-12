const rl = @import("raylib");
const types = @import("types");

fn keyPressed(
    key: types.KeyType4K,
    key1: rl.KeyboardKey,
    key2: rl.KeyboardKey,
    key3: rl.KeyboardKey,
    key4: rl.KeyboardKey,
) bool {
    return switch (key) {
        .key1 => rl.isKeyPressed(key1),
        .key2 => rl.isKeyPressed(key2),
        .key3 => rl.isKeyPressed(key3),
        .key4 => rl.isKeyPressed(key4),
    };
}

fn keyDown(
    key: types.KeyType4K,
    key1: rl.KeyboardKey,
    key2: rl.KeyboardKey,
    key3: rl.KeyboardKey,
    key4: rl.KeyboardKey,
) bool {
    return switch (key) {
        .key1 => rl.isKeyDown(key1),
        .key2 => rl.isKeyDown(key2),
        .key3 => rl.isKeyDown(key3),
        .key4 => rl.isKeyDown(key4),
    };
}

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

    pub fn draw(
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

    pub fn render(
        self: Basic4K,
        posMs: i64,
        decisionTimeMs: i64,
        key1: rl.KeyboardKey,
        key2: rl.KeyboardKey,
        key3: rl.KeyboardKey,
        key4: rl.KeyboardKey,
    ) i64 {
        const errors = self.hitTimeMs - posMs;

        if (errors <= decisionTimeMs and errors >= -decisionTimeMs) {
            if (keyPressed(self.keyType, key1, key2, key3, key4)) {
                return errors;
            }
        }

        return decisionTimeMs + 1;
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

    pub fn draw(
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

    pub fn render(
        self: Concurrent4K,
        posMs: i64,
        decisionTimeMs: i64,
        key1: rl.KeyboardKey,
        key2: rl.KeyboardKey,
        key3: rl.KeyboardKey,
        key4: rl.KeyboardKey,
    ) i64 {
        const errors = self.hitTimeMs - posMs;

        if (errors <= decisionTimeMs and errors >= -decisionTimeMs) {
            const pressed1 = keyPressed(self.keyType1, key1, key2, key3, key4);
            const pressed2 = keyPressed(self.keyType2, key1, key2, key3, key4);

            const downed1 = keyDown(self.keyType1, key1, key2, key3, key4);
            const downed2 = keyDown(self.keyType2, key1, key2, key3, key4);

            const hit1 = pressed1 and downed2;
            const hit2 = downed1 and pressed2;
            const hit3 = pressed1 and pressed2;

            if (hit1 or hit2 or hit3) {
                return errors;
            }
        }

        return decisionTimeMs + 1;
    }
};
