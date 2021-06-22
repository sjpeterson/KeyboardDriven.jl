#!/usr/bin/env julia

"""
This simple program is a loop that prints out each key pressed. It terminates
on Ctrl+D.
"""

using KeyboardDriven

function main()
    keyboarddriven()
    while true
        k = getkeypress()
        println(k)
        if k == ctrl | CharKey('d')
            break
        end
    end
end

main()
