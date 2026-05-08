const rl = @import("raylib");
const resolution = @import("resolution.zig");

pub const Window = struct {
    target: rl.RenderTexture,
    resolution: resolution.Resolution,

    pub inline fn init(r: resolution.Resolution) !Window {
        rl.initWindow(r.width, r.height, "kau");

        const target = try rl.loadRenderTexture(
            resolution.forDev.width,
            resolution.forDev.height,
        );

        return Window{
            .resolution = r,
            .target = target,
        };
    }

    pub inline fn deinit(self: Window) void {
        rl.unloadRenderTexture(self.target);
        rl.closeWindow();
    }

    pub inline fn beginVirtual(self: Window) void {
        rl.beginTextureMode(self.target);
    }

    pub inline fn endVirtual(self: Window) void {
        rl.endTextureMode();

        const dev_w: f32 = @floatFromInt(resolution.forDev.width);
        const dev_h: f32 = @floatFromInt(resolution.forDev.height);
        const win_w: f32 = @floatFromInt(self.resolution.width);
        const win_h: f32 = @floatFromInt(self.resolution.height);

        const scale = @min(win_w / dev_w, win_h / dev_h);

        const offset_x = (win_w - dev_w * scale) / 2.0;
        const offset_y = (win_h - dev_h * scale) / 2.0;

        rl.drawTexturePro(
            self.target.texture,
            rl.Rectangle{
                .x = 0,
                .y = 0,
                .width = dev_w,
                .height = -dev_h,
            },
            rl.Rectangle{
                .x = offset_x,
                .y = offset_y,
                .width = dev_w * scale,
                .height = dev_h * scale,
            },
            rl.Vector2{
                .x = 0,
                .y = 0,
            },
            0,
            .white,
        );
    }
};
