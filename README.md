# KeyboardDriven.jl
Julia package for making keyboard-driven programs. Made for Linux, portability uncertain.

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
