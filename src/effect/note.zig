const rl = @import("raylib");
const types = @import("types");
const constants = @import("constants");

pub const Note4K = struct {
    note1: f64,
    note2: f64,
    note3: f64,
    note4: f64,

    note1X: i32,
    note2X: i32,
    note3X: i32,
    note4X: i32,
    noteSizeX: i32,
    noteSizeY: i32,
    JLineY: i32,

    effectColor: rl.Color,

    pub fn init(note1X: i32, note2X: i32, note3X: i32, note4X: i32, noteSizeX: i32, noteSizeY: i32, JLineY: i32) Note4K {
        return Note4K{
            .note1 = 0,
            .note2 = 0,
            .note3 = 0,
            .note4 = 0,
            .note1X = note1X,
            .note2X = note2X,
            .note3X = note3X,
            .note4X = note4X,
            .noteSizeX = noteSizeX,
            .noteSizeY = noteSizeY,
            .JLineY = JLineY,
            .effectColor = .{ .r = 248, .g = 229, .b = 73, .a = 255 },
        };
    }

    pub fn on(self: *Note4K, i: types.KeyType4K) void {
        switch (i) {
            .key1 => self.note1 = rl.getTime(),
            .key2 => self.note2 = rl.getTime(),
            .key3 => self.note3 = rl.getTime(),
            .key4 => self.note4 = rl.getTime(),
        }
    }

    pub fn draw(self: Note4K) void {
        const now = rl.getTime();
        const length = @as(f64, @floatFromInt(constants.EffectLengthMs)) / 1000.0;

        if (self.note1 != 0.0 and self.note1 + length > now) {
            rl.drawRectangle(
                self.note1X,
                self.JLineY,
                self.noteSizeX,
                self.noteSizeY,
                self.effectColor,
            );
        }

        if (self.note2 != 0.0 and self.note2 + length > now) {
            rl.drawRectangle(
                self.note2X,
                self.JLineY,
                self.noteSizeX,
                self.noteSizeY,
                self.effectColor,
            );
        }

        if (self.note3 != 0.0 and self.note3 + length > now) {
            rl.drawRectangle(
                self.note3X,
                self.JLineY,
                self.noteSizeX,
                self.noteSizeY,
                self.effectColor,
            );
        }

        if (self.note4 != 0.0 and self.note4 + length > now) {
            rl.drawRectangle(
                self.note4X,
                self.JLineY,
                self.noteSizeX,
                self.noteSizeY,
                self.effectColor,
            );
        }
    }
};
