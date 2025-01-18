// ╔══════════════════════════════════════ INIT ══════════════════════════════════════╗

    const std = @import("std");
    const lengthOfFirst = @import("../../utils/utils.zig").lengthOfFirst;

// ╚══════════════════════════════════════════════════════════════════════════════════╝



// ╔══════════════════════════════════════ CORE ══════════════════════════════════════╗

        /// Iterator for traversing codepoints in a string.
    pub const Iterator = struct {

    // ┌──────────────────────────── ---- ────────────────────────────┐

        const Self = @This();

        /// ..?
        pub const Error = error { InvalidValue };

        /// ..?
        pub const modes = enum { codepoint, graphemeCluster };

    // └──────────────────────────────────────────────────────────────┘


    // ┌─────────────────────────── Fields ───────────────────────────┐

        /// The input bytes to iterate over.
        input_bytes: []const u8,
        /// The current position of the iterator.
        current_index: usize,

    // └──────────────────────────────────────────────────────────────┘


    // ┌────────────────────────── Methods ───────────────────────────┐
        
        /// Initializes a Iterator with the given input bytes.
        /// Returns `Error.InvalidValue` **_if the `input_bytes` is not a valid utf8._**
        pub fn init(input_bytes: []const u8) Error!Self {
            if(!std.unicode.utf8ValidateSlice(input_bytes)) return Error.InvalidValue;
            return initUnchecked(input_bytes);
        }

        /// Initializes a Iterator with the given input bytes.
        pub fn initUnchecked(input_bytes: []const u8) Self {
            return .{ .input_bytes = input_bytes, .current_index = 0, };
        }

        /// Retrieves the next codepoint slice and advances the iterator.
        pub fn nextSlice(self: *Self) ?[]const u8 {
            return self.getNextSlice(.codepoint);
        }

        /// Retrieves the next grapheme cluster slice and advances the iterator.
        pub fn nextGraphemeCluster(self: *Self) ?[]const u8 {
            return self.getNextSlice(.graphemeCluster);
        }

        /// Retrieves the next codepoint slice and advances the iterator.
        fn getNextSlice(self: *Self, mode: modes) ?[]const u8 {
            if (self.current_index >= self.input_bytes.len) return null;
            const cp_len = 
            if(mode == .codepoint) lengthOfFirst(self.input_bytes[self.current_index]) catch return null
            else lengthOfFirst(self.input_bytes[self.current_index..]) catch return null;

            self.current_index += cp_len;
            return self.input_bytes[self.current_index - cp_len..self.current_index];
        }

        /// Decodes and returns the next codepoint and advances the iterator.
        pub fn next(self: *Self) ?u21 {
            const slice = self.nextSlice() orelse return null;
            return std.unicode.utf8Decode(slice[0..]) catch null;
        }

        /// Decodes and returns the next codepoint without advancing the iterator.
        pub fn peek(self: *Self, codepoints_count: usize) ?[]const u8 {
            const original_i = self.current_index;
            defer self.current_index = original_i;

            var end_ix = original_i;
            var found: usize = 0;
            while (found < codepoints_count) : (found += 1) {
                const next_codepoint_slice = self.nextSlice() orelse return null;
                end_ix += next_codepoint_slice.len;
            }

            return self.input_bytes[original_i..end_ix];
        }

    // └──────────────────────────────────────────────────────────────┘

    };

// ╚══════════════════════════════════════════════════════════════════════════════════╝