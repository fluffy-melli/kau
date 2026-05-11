const rl = @import("raylib");
const types = @import("types");

pub const Basic4K = struct {
    keyType: types.KeyType4K,

    hitTimeMs: i64,
    fallDurationMs: i64,
    holdingDurationMs: i64,

    isPressed: bool,
    isReleased: bool,

    pub fn init(
        keyType: types.KeyType4K,
        hitTimeMs: i64,
        fallDurationMs: i64,
        holdingDurationMs: i64,
    ) Basic4K {
        return Basic4K{
            .keyType = keyType,
            .hitTimeMs = hitTimeMs,
            .fallDurationMs = fallDurationMs,
            .holdingDurationMs = holdingDurationMs,
            .isPressed = false,
            .isReleased = false,
        };
    }

    inline fn keyReleased(
        key: types.KeyType4K,
        key1: rl.KeyboardKey,
        key2: rl.KeyboardKey,
        key3: rl.KeyboardKey,
        key4: rl.KeyboardKey,
    ) bool {
        return switch (key) {
            .key1 => rl.isKeyReleased(key1),
            .key2 => rl.isKeyReleased(key2),
            .key3 => rl.isKeyReleased(key3),
            .key4 => rl.isKeyReleased(key4),
        };
    }

    inline fn keyPressed(
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

    inline fn keyDown(
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
        innerHeadColor: rl.Color,
        innerBodyColor: rl.Color,
        outerHeadColor: rl.Color,
        outerBodyColor: rl.Color,
    ) bool {
        const spawnTime = self.hitTimeMs - self.fallDurationMs;

        if (posMs < spawnTime) {
            return false;
        }

        const headElapsed = posMs - spawnTime;
        const targetY = JLineY + @divTrunc(noteSizeY, 2);

        const headY: i32 = @as(i32, @intCast(@divTrunc(headElapsed * @as(i64, @intCast(targetY)), self.fallDurationMs)));

        const tailHitTimeMs = self.hitTimeMs + self.holdingDurationMs;
        const tailSpawnTime = tailHitTimeMs - self.fallDurationMs;
        const tailElapsed = posMs - tailSpawnTime;

        const tailY: i32 = @as(i32, @intCast(@divTrunc(tailElapsed * @as(i64, @intCast(targetY)), self.fallDurationMs)));

        var actualHeadY = headY;
        if (self.isPressed and actualHeadY > targetY) {
            actualHeadY = targetY;
        }

        const halfSizeY = @divTrunc(noteSizeY, 2);
        const headDrawY = actualHeadY - halfSizeY;
        const tailDrawY = tailY - halfSizeY;

        if (tailDrawY > screenHeight) {
            return true;
        }

        const bodyHeight = actualHeadY - tailDrawY;

        switch (self.keyType) {
            .key1 => {
                rl.drawRectangle(
                    note1X,
                    headDrawY,
                    noteSizeX,
                    noteSizeY,
                    outerHeadColor,
                );

                rl.drawRectangle(
                    note1X,
                    tailDrawY,
                    noteSizeX,
                    bodyHeight,
                    outerBodyColor,
                );
            },
            .key2 => {
                rl.drawRectangle(
                    note2X,
                    headDrawY,
                    noteSizeX,
                    noteSizeY,
                    innerHeadColor,
                );

                rl.drawRectangle(
                    note2X,
                    tailDrawY,
                    noteSizeX,
                    bodyHeight,
                    innerBodyColor,
                );
            },
            .key3 => {
                rl.drawRectangle(
                    note3X,
                    headDrawY,
                    noteSizeX,
                    noteSizeY,
                    innerHeadColor,
                );

                rl.drawRectangle(
                    note3X,
                    tailDrawY,
                    noteSizeX,
                    bodyHeight,
                    innerBodyColor,
                );
            },
            .key4 => {
                rl.drawRectangle(
                    note4X,
                    headDrawY,
                    noteSizeX,
                    noteSizeY,
                    innerHeadColor,
                );

                rl.drawRectangle(
                    note4X,
                    tailDrawY,
                    noteSizeX,
                    bodyHeight,
                    innerBodyColor,
                );
            },
        }

        return false;
    }
};

pub const Concurrent4K = struct {
    keyType1: types.KeyType4K,
    keyType2: types.KeyType4K,

    hitTimeMs: i64,
    fallDurationMs: i64,
    holdingDurationMs: i64,

    isPressed: bool,
    isReleased: bool,

    pub fn init(
        keyType1: types.KeyType4K,
        keyType2: types.KeyType4K,
        hitTimeMs: i64,
        fallDurationMs: i64,
        holdingDurationMs: i64,
    ) Concurrent4K {
        return Concurrent4K{
            .keyType1 = keyType1,
            .keyType2 = keyType2,
            .hitTimeMs = hitTimeMs,
            .fallDurationMs = fallDurationMs,
            .holdingDurationMs = holdingDurationMs,
            .isPressed = false,
            .isReleased = false,
        };
    }

    inline fn keyReleased(
        key: types.KeyType4K,
        key1: rl.KeyboardKey,
        key2: rl.KeyboardKey,
        key3: rl.KeyboardKey,
        key4: rl.KeyboardKey,
    ) bool {
        return switch (key) {
            .key1 => rl.isKeyReleased(key1),
            .key2 => rl.isKeyReleased(key2),
            .key3 => rl.isKeyReleased(key3),
            .key4 => rl.isKeyReleased(key4),
        };
    }

    inline fn keyPressed(
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

    inline fn keyDown(
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
        headColor: rl.Color,
        bodyColor: rl.Color,
    ) bool {
        const spawnTime = self.hitTimeMs - self.fallDurationMs;

        if (posMs < spawnTime) {
            return false;
        }

        const headElapsed = posMs - spawnTime;
        const targetY = JLineY + @divTrunc(noteSizeY, 2);

        const headY: i32 = @as(i32, @intCast(@divTrunc(headElapsed * @as(i64, @intCast(targetY)), self.fallDurationMs)));

        const tailHitTimeMs = self.hitTimeMs + self.holdingDurationMs;
        const tailSpawnTime = tailHitTimeMs - self.fallDurationMs;
        const tailElapsed = posMs - tailSpawnTime;

        const tailY: i32 = @as(i32, @intCast(@divTrunc(tailElapsed * @as(i64, @intCast(targetY)), self.fallDurationMs)));

        var actualHeadY = headY;
        if (self.isPressed and actualHeadY > targetY) {
            actualHeadY = targetY;
        }

        const halfSizeY = @divTrunc(noteSizeY, 2);
        const headDrawY = actualHeadY - halfSizeY;
        const tailDrawY = tailY - halfSizeY;

        if (tailDrawY > screenHeight) {
            return true;
        }

        const bodyHeight = actualHeadY - tailDrawY;

        switch (self.keyType1) {
            .key1 => {
                rl.drawRectangle(
                    note1X,
                    headDrawY,
                    noteSizeX,
                    noteSizeY,
                    headColor,
                );

                rl.drawRectangle(
                    note1X,
                    tailDrawY,
                    noteSizeX,
                    bodyHeight,
                    bodyColor,
                );
            },
            .key2 => {
                rl.drawRectangle(
                    note2X,
                    headDrawY,
                    noteSizeX,
                    noteSizeY,
                    headColor,
                );

                rl.drawRectangle(
                    note2X,
                    tailDrawY,
                    noteSizeX,
                    bodyHeight,
                    bodyColor,
                );
            },
            .key3 => {
                rl.drawRectangle(
                    note3X,
                    headDrawY,
                    noteSizeX,
                    noteSizeY,
                    headColor,
                );

                rl.drawRectangle(
                    note3X,
                    tailDrawY,
                    noteSizeX,
                    bodyHeight,
                    bodyColor,
                );
            },
            .key4 => {
                rl.drawRectangle(
                    note4X,
                    headDrawY,
                    noteSizeX,
                    noteSizeY,
                    headColor,
                );

                rl.drawRectangle(
                    note4X,
                    tailDrawY,
                    noteSizeX,
                    bodyHeight,
                    bodyColor,
                );
            },
        }

        switch (self.keyType2) {
            .key1 => {
                rl.drawRectangle(
                    note1X,
                    headDrawY,
                    noteSizeX,
                    noteSizeY,
                    headColor,
                );

                rl.drawRectangle(
                    note1X,
                    tailDrawY,
                    noteSizeX,
                    bodyHeight,
                    bodyColor,
                );
            },
            .key2 => {
                rl.drawRectangle(
                    note2X,
                    headDrawY,
                    noteSizeX,
                    noteSizeY,
                    headColor,
                );

                rl.drawRectangle(
                    note2X,
                    tailDrawY,
                    noteSizeX,
                    bodyHeight,
                    bodyColor,
                );
            },
            .key3 => {
                rl.drawRectangle(
                    note3X,
                    headDrawY,
                    noteSizeX,
                    noteSizeY,
                    headColor,
                );

                rl.drawRectangle(
                    note3X,
                    tailDrawY,
                    noteSizeX,
                    bodyHeight,
                    bodyColor,
                );
            },
            .key4 => {
                rl.drawRectangle(
                    note4X,
                    headDrawY,
                    noteSizeX,
                    noteSizeY,
                    headColor,
                );

                rl.drawRectangle(
                    note4X,
                    tailDrawY,
                    noteSizeX,
                    bodyHeight,
                    bodyColor,
                );
            },
        }

        return false;
    }
};
