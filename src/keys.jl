"""
    CharKey(value::Char)

A key representing a printable character.

# Fields

value::Char - The character value of the key
"""
struct CharKey
    """The character value of the key"""
    value::Char
end


"""
    SpecialKey

A key that is not representing a printable character.
"""
@enum SpecialKey begin
    arrowDown
    arrowLeft
    arrowRight
    arrowUp
    backspace
    del
    endKey
    escape
    f1
    f2
    f3
    f4
    f5
    f6
    f7
    f8
    f9
    f10
    f11
    f12
    home
    ins
    pgDn
    pgUp
    returnKey
end


"""
    UnknownKey(value)

A key that is not yet supported.

# Fields

value - The sequence of bytes resulting from pressing the key
"""
struct UnknownKey
    """The sequence of bytes resulting from pressing the key"""
    value::Union{
        UInt8,
        Tuple{UInt8, UInt8},
        Tuple{UInt8, UInt8, UInt8},
        Tuple{UInt8, UInt8, UInt8, UInt8},
        Tuple{UInt8, UInt8, UInt8, UInt8, UInt8},
        Tuple{UInt8, UInt8, UInt8, UInt8, UInt8, UInt8},
        Tuple{UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8}
    }
end

    
"""
Modifier keys
"""
@enum ModKey::UInt8 begin
    alt   = 0b001
    ctrl  = 0b010
    shift = 0b100
end


"""
    ModifiedKey

A key with modifiers. Conveniently constructed with `|`, e.g. `ctrl |
CharKey('a')` for Ctrl+A.  Note that not all combinations are useable. For
example, Ctrl+J and Ctrl+M are both identical to [RETURN].

Combining with `|` is nearly always more readable, e.g.
`alt | ctrl | CharKey('q')` instead of `ModKey(0x03, CharKey('q')`

# Fields

mod_bitmap::UInt8 - Modifier key bitmap; From LSB: Alt, Ctrl, Shift
key::Union{CharKey, SpecialKey} - The base key
"""
struct ModifiedKey
    """Modifier key bitmap; From LSB: Alt, Ctrl, Shift"""
    mod_bitmap::UInt8
    """The base key"""
    key::Union{CharKey, SpecialKey}
end


(|)(x::ModKey, y::ModKey) = UInt8(x) | UInt8(y)
(|)(x::ModKey, y::Union{CharKey, SpecialKey, ModifiedKey}) = UInt8(x) | y
(|)(x::UInt8, y::Union{CharKey, SpecialKey}) = ModifiedKey(x, y)
(|)(x::UInt8, y::ModifiedKey) = ModifiedKey(x | y.mod_bitmap, y.key)
