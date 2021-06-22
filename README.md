# KeyboardDriven.jl

Julia package for making keyboard-driven programs. Made for Linux, portability uncertain.

| Status | Coverage |
| :----: | :----: |
| [![Build Status](https://travis-ci.com/github/sjpeterson/KeyboardDriven.jl.svg?branch=main)](https://travis-ci.com/github/sjpeterson/KeyboardDriven.jl) | [![codecov.io](http://codecov.io/github/sjpeterson/KeyboardDriven.jl/coverage.svg?branch=main)](http://codecov.io/github/sjpeterson/KeyboardDriven.jl?branch=main) |

## Example

    #!/usr/bin/env julia
    
    using KeyboardDriven

    function main()
        keyboarddriven()
        while true
            c = getkeypress()
            println(string("You pressed: ", c))
            if c == CtrlKey('d')
                break
            end
        end
    end

    main()

##

    function handlekey!(state, key)
        @match key begin
            ctrl + shift + arrowUp => 
            ModKey(Ctrl, Shift, arrowUp)
            ModKey(
        end
    end
