"""
    getkeypress()::Union{CharKey, ModifiedKey, SpecialKey, UnknownKey

Return the next key pressed.
"""
getkeypress()::Union{CharKey, ModifiedKey, SpecialKey, UnknownKey} = bytestokey(getkeybytes())


"""
    prompt(s::AbstractString)::String

Temporarily enter canonical mode and turn on echo to prompt for a string.
"""
function prompt(s)::String
    prev_mode = normalmode()
    print(s)
    s = readline(stdin)
    setmode(prev_mode)

    s
end


# Internal

function getkeybytes()
    c = read(stdin, UInt8)
    (c == 0x1b || c > 0xc0) && more(stdin) ? getkeybytes(c) : c
end

function getkeybytes(x::UInt8)
    c = read(stdin, UInt8)
    (x == 0x1b || x == 0xe2) && more(stdin) ? getkeybytes(x, c) : (x, c)
end

function getkeybytes(x::UInt8, y::UInt8)
    c = read(stdin, UInt8)
    x == 0x1b && y == 0x5b && more(stdin) ? getkeybytes(x, y, c) : (x, y, c)
end

function getkeybytes(x::UInt8, y::UInt8, z::UInt8)
    c = read(stdin, UInt8)
    more(stdin) ? getkeybytes(x, y, z, c) : (x, y, z, c)
end

function getkeybytes(x::UInt8, y::UInt8, z::UInt8, p::UInt8)
    c = read(stdin, UInt8)
    p != 0x7e && more(stdin) ? getkeybytes(x, y, z, p, c) : (x, y, z, p, c)
end

function getkeybytes(x::UInt8, y::UInt8, z::UInt8, p::UInt8, q::UInt8)
    c = read(stdin, UInt8)
    q != 0x7e && more(stdin) ? getkeybytes(x, y, z, p, q, c) : (x, y, z, p, q, c)
end

function getkeybytes(x::UInt8, y::UInt8, z::UInt8, p::UInt8, q::UInt8, r::UInt8)
    c = read(stdin, UInt8)
    (x, y, z, p, q, r, c)
end

function bytestokey(x::UInt8)::Union{CharKey, ModifiedKey, SpecialKey, UnknownKey}
    if ischar(x)
        CharKey(Char(x))
    else
        @match x begin
            0x00             => ctrl | CharKey(' ')
            0x09             => CharKey('\t')
            0x0a             => returnKey
            0x1b             => escape
            0x1d             => ctrl | CharKey('5')
            0x1e             => ctrl | CharKey('6')
            0x1f             => ctrl | CharKey('7')
            0x7f             => backspace
            _, if x < 27 end => ctrl | CharKey(Char(0x60 + x))
            _                => UnknownKey(x)
        end
    end
end

function bytestokey(xs::Tuple{UInt8, UInt8})::Union{CharKey, ModifiedKey, UnknownKey}
    @match xs begin
        (0x1b, y)    => alt | bytestokey(y)
        (0xc2, y)    => CharKey(Char(y))
        (0xc3, y)    => CharKey(Char(0x40 + y))
        (0xd0, 0xb6) => ctrl | CharKey('ö')
        (0xd1, 0x85) => ctrl | CharKey('å')
        (0xd1, 0x8b) => ctrl | CharKey('ß')
        (0xd1, 0x8d) => ctrl | CharKey('ä')
        _            => UnknownKey(xs)
    end
end

function bytestokey(xs::Tuple{UInt8, UInt8, UInt8})::Union{CharKey, ModifiedKey, SpecialKey, UnknownKey}
    @match xs begin
        (0x1b, 0x4f, 0x50) => f1
        (0x1b, 0x4f, 0x51) => f2
        (0x1b, 0x4f, 0x52) => f3
        (0x1b, 0x4f, 0x53) => f4
        (0x1b, 0x5b, 0x41) => arrowUp
        (0x1b, 0x5b, 0x42) => arrowDown
        (0x1b, 0x5b, 0x43) => arrowRight
        (0x1b, 0x5b, 0x44) => arrowLeft
        (0x1b, 0x5b, 0x46) => endKey
        (0x1b, 0x5b, 0x48) => home
        (0x1b, 0xc3, x)    => maybemod(alt, (0xc3, x), xs)
        (0x1b, 0xd0, x)    => maybemod(alt, (0xd0, x), xs)
        (0x1b, 0xd1, x)    => maybemod(alt, (0xd1, x), xs)
        (0xe2, 0x82, 0xac) => CharKey('€')
        _ => UnknownKey(xs)
    end
end

function bytestokey(xs::Tuple{UInt8, UInt8, UInt8, UInt8})::Union{SpecialKey, UnknownKey}
    @match xs begin
        (0x1b, 0x5b, 0x32, 0x7e) => ins
        (0x1b, 0x5b, 0x33, 0x7e) => del
        (0x1b, 0x5b, 0x35, 0x7e) => pgUp
        (0x1b, 0x5b, 0x36, 0x7e) => pgDn
        _                        => UnknownKey(xs)
    end
end

function bytestokey(xs::Tuple{UInt8, UInt8, UInt8, UInt8, UInt8})::Union{SpecialKey, UnknownKey}
    @match xs begin
        (0x1b, 0x5b, 0x31, 0x35, 0x7e) => f5
        (0x1b, 0x5b, 0x31, 0x37, 0x7e) => f6
        (0x1b, 0x5b, 0x31, 0x38, 0x7e) => f7
        (0x1b, 0x5b, 0x31, 0x39, 0x7e) => f8
        (0x1b, 0x5b, 0x32, 0x30, 0x7e) => f9
        (0x1b, 0x5b, 0x32, 0x31, 0x7e) => f10
        (0x1b, 0x5b, 0x32, 0x33, 0x7e) => f11
        (0x1b, 0x5b, 0x32, 0x34, 0x7e) => f12
        _                              => UnknownKey(xs)
    end
end

function bytestokey(xs::Tuple{UInt8, UInt8, UInt8, UInt8, UInt8, UInt8})::Union{ModifiedKey, UnknownKey}
    @match xs begin
        (0x1b, 0x5b, 0x31, 0x3b, 0x32, x)    => maybemod(shift, (0x1b, 0x5b, x), xs)
        (0x1b, 0x5b, 0x31, 0x3b, 0x33, x)    => maybemod(alt, (0x1b, 0x5b, x), xs)
        (0x1b, 0x5b, 0x31, 0x3b, 0x35, x)    => maybemod(ctrl, (0x1b, 0x5b, x), xs)
        (0x1b, 0x5b, 0x31, 0x3b, 0x37, x)    => maybemod(alt | ctrl, (0x1b, 0x5b, x), xs)
        (0x1b, 0x5b, x, 0x3b, 0x35, 0x7e)    => maybemod(ctrl, (0x1b, 0x5b, x, 0x7e), xs)
        (0x1b, 0x5b, 0x31, 0x3b, 0x36, 0x53) => ctrl | shift | f4
        (0x1b, 0x5b, 0x31, 0x3b, 0x36, 0x52) => ctrl | shift | f3
        (0x1b, 0x5b, 0x31, 0x3b, 0x36, 0x51) => ctrl | shift | f2
        (0x1b, 0x5b, 0x31, 0x3b, 0x36, 0x50) => ctrl | shift | f1
        (0x1b, 0x5b, 0x33, 0x3b, 0x32, 0x7e) => shift | del
        _                                    => UnknownKey(xs)
    end
end

function bytestokey(xs::Tuple{UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8})::Union{ModifiedKey, UnknownKey}
    @match xs begin
        (0x1b, 0x5b, x, y, 0x3b, 0x35, 0x7e) => maybemod(ctrl, (0x1b, 0x5b, x, y, 0x7e), xs)
        (0x1b, 0x5b, x, y, 0x3b, 0x36, 0x7e) => maybemod(ctrl | shift, (0x1b, 0x5b, x, y, 0x7e), xs)
        _                                    => UnknownKey(xs)
    end
end

"""
    maybemod(mask, xs, ys)

Modify the key corresponding to `xs` if it is not unknown. Otherwise create
unknown key from `ys`.
"""
function maybemod(mask, xs, ys)
    k = bytestokey(xs)
    typeof(k) == UnknownKey ? UnknownKey(ys) : mask | k
end

ischar(c::UInt8) = 32 <= c <= 126 || 161 <= c <= 255

function more(stream)
    t = @task begin; peek(stream, UInt8); end
    schedule(t)
    sleep(0.001)
    istaskdone(t)
end
