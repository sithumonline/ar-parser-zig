const std = @import("std");
const print = std.debug.print;
const fs = std.fs;
const json = @import("json");
const sorter = @import("sorter.zig");
const utility = @import("utility/utility.zig");
const types = @import("types/types.zig");

pub fn main() !void {
    var arr = [_]i32{ -2, 45, 0, 11, -9 };
    sorter.buddle_sort(&arr);
    print("out {any}\n", .{arr});

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var util = utility.Utility.init(allocator);
    defer util.deinit();
    const ar_data: []types.ARson = try util.get_arr_son(); //try util.getArSon();

    var rvn_stat = std.StringHashMap(types.Stats).init(allocator);
    defer rvn_stat.deinit();

    for (ar_data) |Tble| {
        if (Tble.Table.RevenueCenter.len == 0) {
            continue;
        }

        var rs: types.Stats = types.Stats{ .Qlub = .{ .orders = 0, .payments = 0, .totalAmount = 0, .totalTip = 0 }, .None = .{ .orders = 0, .payments = 0, .totalAmount = 0, .totalTip = 0 } };
        if (rvn_stat.get(Tble.Table.RevenueCenter)) |stats| {
            rs = stats;
        }
        if (Tble.Payments) |payments| {
            var is_q = false;
            var is_n = false;

            for (payments) |Pym| {
                if (Pym.ObjectNumber == 500) {
                    rs.Qlub.payments += 1;
                    rs.Qlub.totalAmount += Pym.Total;
                    is_q = true;
                } else {
                    rs.None.payments += 1;
                    rs.None.totalAmount += Pym.Total;
                    is_n = true;
                }
            }

            if (is_q) {
                rs.Qlub.orders += 1;
            }

            if (is_n) {
                rs.None.orders += 1;
            }
        }

        try rvn_stat.put(Tble.Table.RevenueCenter, rs);
    }

    if (std.json.stringifyAlloc(allocator, rvn_stat.get("1"), .{ .whitespace = .indent_2 })) |rvn_stat_str| {
        defer allocator.free(rvn_stat_str);
        print("revenue_center: {s}\n", .{rvn_stat_str});
    } else |err| {
        print("json stringify err: {any}\n", .{err});
    }

    var iter = rvn_stat.iterator();
    while (iter.next()) |item| {
        print("{s} :: {any}\n", .{ item.key_ptr.*, item.value_ptr });
    }

    const rvn_stat_str = try json.toPrettySlice(allocator, rvn_stat);
    print("revenue_center: {s}\n", .{rvn_stat_str});
    defer allocator.free(rvn_stat_str);

    const file_w = try fs.cwd().createFile("data/ar_res.json", .{ .read = true });
    defer file_w.close();

    const by_w = try file_w.writeAll(rvn_stat_str);
    _ = by_w;
}
