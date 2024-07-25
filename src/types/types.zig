const NullFloat64 = struct { Float64: f64, Valid: bool };
const Payment = struct { Total: f32, ObjectNumber: i32 };
const Table = struct { RevenueCenter: []const u8, EmployeeId: []const u8, Payment: NullFloat64, Due: NullFloat64, OtherPayment: NullFloat64 };
pub const ARson = struct { Table: Table, Payments: ?[]Payment };

const Stat = struct { orders: i32, payments: i32, totalAmount: f32, totalTip: f32 }; //?[]const u8 };
pub const Stats = struct { Qlub: Stat, None: Stat };
