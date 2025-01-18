// ╔══════════════════════════════════════ INIT ══════════════════════════════════════╗

    /// Immutable fixed array of `UTF-8` bytes.
    pub const Viewer = @import("./Viewer/Viewer.zig");

    /// Mutable fixed array of `UTF-8` bytes.
    pub const Buffer = @import("./Buffer/Buffer.zig");

    /// Managed dynamic array of `UTF-8` bytes.
    pub const String = @import("./String/String.zig");

    /// Unmanaged dynamic array of `UTF-8` bytes.
    pub const uString = @import("./uString/uString.zig");

// ╚══════════════════════════════════════════════════════════════════════════════════╝



// ╔══════════════════════════════════════ TEST ══════════════════════════════════════╗

    test {
        _ = @import("./Viewer/Viewer.test.zig");
        _ = @import("./Buffer/Buffer.test.zig");
        _ = @import("./String/String.test.zig");
        _ = @import("./uString/uString.test.zig");
    }

// ╚══════════════════════════════════════════════════════════════════════════════════╝