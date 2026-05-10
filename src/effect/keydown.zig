const rl = @import("raylib");
const note = @import("note");
const types = @import("types");

pub const keyPressEffect4K = struct {
    resolution: types.Resolution,

    note1X: i32,
    note2X: i32,
    note3X: i32,
    note4X: i32,

    noteSizeX: i32,
    noteSizeY: i32,

    key1: rl.KeyboardKey,
    key2: rl.KeyboardKey,
    key3: rl.KeyboardKey,
    key4: rl.KeyboardKey,

    keyPressColor: rl.Color,

    pub inline fn init(
        r: types.Resolution,
        note1X: i32,
        note2X: i32,
        note3X: i32,
        note4X: i32,
        noteSizeX: i32,
        noteSizeY: i32,
        key1: rl.KeyboardKey,
        key2: rl.KeyboardKey,
        key3: rl.KeyboardKey,
        key4: rl.KeyboardKey,
    ) keyPressEffect4K {
        return keyPressEffect4K{
            .resolution = r,
            .note1X = note1X,
            .note2X = note2X,
            .note3X = note3X,
            .note4X = note4X,
            .noteSizeX = noteSizeX,
            .noteSizeY = noteSizeY,
            .key1 = key1,
            .key2 = key2,
            .key3 = key3,
            .key4 = key4,
            .keyPressColor = .{ .r = 255, .g = 255, .b = 255, .a = 100 },
        };
    }

    inline fn laneX(self: keyPressEffect4K, key: types.KeyType4K) i32 {
        return switch (key) {
            .key1 => self.note1X,
            .key2 => self.note2X,
            .key3 => self.note3X,
            .key4 => self.note4X,
        };
    }

    inline fn keyDown(self: keyPressEffect4K, key: types.KeyType4K) bool {
        return switch (key) {
            .key1 => rl.isKeyDown(self.key1),
            .key2 => rl.isKeyDown(self.key2),
            .key3 => rl.isKeyDown(self.key3),
            .key4 => rl.isKeyDown(self.key4),
        };
    }

    pub inline fn draw(self: keyPressEffect4K) void {
        inline for ([_]types.KeyType4K{
            .key1,
            .key2,
            .key3,
            .key4,
        }) |key| {
            if (self.keyDown(key)) {
                rl.drawRectangle(
                    self.laneX(key),
                    0,
                    self.noteSizeX,
                    self.resolution.height,
                    self.keyPressColor,
                );
            }
        }
    }
};
