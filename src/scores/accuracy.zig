pub const Accuracy = struct {
    ms: i64,
    miss: bool,

    pub fn init(ms: i64, miss: bool) Accuracy {
        return Accuracy{
            .ms = ms,
            .miss = miss,
        };
    }
};
