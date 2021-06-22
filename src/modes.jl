"""
    keyboarddriven()::TERMIOS.termios

Enter keyboard-driven mode.

Sets the terminal to non-canonical mode and turns off echo. Returns the current
settings so they may be restored later on.

"""
keyboarddriven() = keyboarddriven(false)


"""
    keyboarddriven(echo::Bool)::TERMIOS.termios

Enter keyboard-driven mode setting echo.

Sets the terminal to non-canonical mode and sets echo. Returns the current
settings so they may be restored later on.
"""
function keyboarddriven(echo::Bool)::TERMIOS.termios
    current = TERMIOS.termios()
    new = TERMIOS.termios()
    TERMIOS.tcgetattr(stdin, current)
    TERMIOS.tcgetattr(stdin, new)
    if !echo
        new.c_lflag &= ~TERMIOS.ECHO
    end
    new.c_lflag &= ~TERMIOS.ICANON
    setmode(new)

    current
end


"""
    normalmode()::TERMIOS.termios

Enter normal mode.

Sets the terminal to canonical mode and turns on echo. Returns the current
settings so the may be restored later on.
"""
function normalmode()::TERMIOS.termios
    current = TERMIOS.termios()
    new = TERMIOS.termios()
    TERMIOS.tcgetattr(stdin, current)
    TERMIOS.tcgetattr(stdin, new)
    new.c_lflag |= TERMIOS.ECHO
    new.c_lflag |= TERMIOS.ICANON
    setmode(new)

    current
end


"""
    setmode(mode::TERMIOS.termios)

Set a terminal mode.

# Examples

```
initial_mode = keyboarddriven()
# Do stuff in keyboard-driven mode
setmode(initial_mode)
```
"""
setmode(mode::TERMIOS.termios) = TERMIOS.tcsetattr(stdin, TERMIOS.TCSANOW, mode)
