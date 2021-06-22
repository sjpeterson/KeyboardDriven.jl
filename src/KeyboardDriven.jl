module KeyboardDriven

import Base.|

using Match
using TERMIOS

export
    CharKey,
    ModifiedKey,
    SpecialKey,
    alt,
    ctrl,
    getkeypress,
    keyboarddriven,
    prompt,
    shift

include("modes.jl")
include("keys.jl")
include("input.jl")

end # module
