pub const Accuracy = struct {
    ms: i64,
    miss: bool,

    pub fn init(ms: i64, miss: bool) Accuracy {
        return Accuracy{
            .ms = ms,
            .miss = miss,
        };
    }

    pub fn getScore(self: Accuracy, decisionTimeMs: i64, lower: bool) i64 {
        if (lower) {
            if (self.miss) {
                return decisionTimeMs + 1;
            }

            if (self.ms > 0) {
                return self.ms;
            }

            return -self.ms;
        } else {
            if (self.miss) {
                return 0;
            }

            if (self.ms > 0) {
                return decisionTimeMs - self.ms;
            }

            return decisionTimeMs + self.ms;
        }
    }
};
