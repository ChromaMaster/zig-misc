const std = @import("std");
const http = std.http;

pub const Response = struct {
    client: *const Client,

    status: u16,
    body: []u8 = undefined,

    pub fn deinit(self: *const Response) void {
        self.client.allocator.free(self.body);
    }
};

pub const Client = struct {
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) Client {
        return Client{
            .allocator = allocator,
        };
    }

    pub fn get(self: *const Client, url: []const u8) !?Response {
        var client = http.Client{
            .allocator = self.allocator,
        };
        defer client.deinit();

        const uri = try std.Uri.parse(url);

        var server_header_buffer: [16 * 1024]u8 = undefined;
        const options = http.Client.RequestOptions{
            .server_header_buffer = &server_header_buffer,
        };

        var req = try client.open(http.Method.GET, uri, options);
        defer req.deinit();

        try req.send();
        try req.finish();
        try req.wait();

        var response = Response{
            .client = self,
            .status = @intFromEnum(req.response.status),
        };

        response.body = try self.allocator.alloc(u8, @as(usize, req.response.content_length.?));
        errdefer response.deinit();

        _ = try req.read(response.body);

        return response;
    }
};
