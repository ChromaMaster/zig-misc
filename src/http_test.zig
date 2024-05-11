const http = @import("http.zig");

const testing = @import("std").testing;
const allocator = testing.allocator;

test "HTTP GET returns correct status code" {
    const client = http.Client.init(allocator);

    const response = try client.get("http://localhost:35556/get");
    defer response.?.deinit();

    try testing.expect(response.?.status == 200);

    try testing.expect(1 == 1);
}
