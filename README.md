# KeyboardDriven.jl

Julia package for making keyboard-driven programs. Made for Linux, portability uncertain.

| Linux | Windows | Coverage |
| :----: | :----: | :----: |
| [![Build Status](https://travis-ci.com/sjpeterson/KeyboardDriven.jl.svg?branch=main)](https://travis-ci.com/sjpeterson/KeyboardDriven.jl) | [![Build status](https://ci.appveyor.com/api/projects/status/p3niji9um1abo0jp/branch/main?svg=true)](https://ci.appveyor.com/project/sjpeterson/keyboarddriven-jl/branch/main) | [![codecov.io](http://codecov.io/github/sjpeterson/KeyboardDriven.jl/coverage.svg?branch=main)](http://codecov.io/github/sjpeterson/KeyboardDriven.jl?branch=main) |

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
