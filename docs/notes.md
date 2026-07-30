Cya-nyde's Notes
================

General notes that I personally found helpful and/or important. 

## Keyboard Shortcuts

### [Vim](https://www.vim.org/)

#### Command Mode Keys

- Movement
    - **h** - Cursor left
    - **i** - Cursor right
    - **j** - Cursor down
    - **k** - Cursor Up
    - **$** - End of line
    - **0** - Beginning of line
    - **w** - Forward one word
    - **b** - Backwards one word
    - **G** - End of file
    - **gg** - Beginning of file
    - **\`.** - Last edit
- Editing
    - **x** - delete character
    - **u** - undo
    - **Ctrl r** - redo
    - **d** - delete mode
        - **dw** - delete word from cursor onward
        - **d0** - delete to beginning of a line (backwards)
        - **d$** - delete to end of a line (forwards)
        - **dgg** - delete to the beginning of the file (backwards)
        - **dG** - delete to the end of the file (forwards)

- Copy and Pasting
    - **yy** - copy line
    - **y$** - copy to the end of the line
    - **yiw** - copy current word without space
    - **p** - paste after
    - **P** - paste before
    - **gp** - paste after and move cursor after pasted text

#### Insert Mode Keys

- Type as normal and add/delete line breaks
- Use ctrl + c to or esc to return to *Command Mode*

#### Slash and Dot (recommended)

- **/** to enter search mode
    - type search text, then enter
    - type **cgn** and the the replacement text
    - esc to return to standard mode
    - **n** to find the next instance of the original text

#### Substitute Command - **:s**

`:s/<original text>/<replacement text>/<optional modifiers>`

- Options
    - **g** replaces all occurences of the <original text> on that line
    - **i** ignores case for search
    - **c** confirms each replacement before a change is made