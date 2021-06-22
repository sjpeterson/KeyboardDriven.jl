#!/usr/bin/env julia

"""
This program is similar to `simple.jl`, but splits up getkeypress into its
unexported components to print the byte sequence as well as the detected key
press.
"""

using KeyboardDriven

function main()
    keyboarddriven()
    while true
        bs = KeyboardDriven.getkeybytes()
        k = KeyboardDriven.bytestokey(bs)
        println(string(bs, "\t", k))
        if k == ctrl | CharKey('d')
            break
        end
    end
end

main()
