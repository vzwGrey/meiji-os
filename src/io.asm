; Removes all content from the screen and sets
; a black background color with light grey text.
; Also moves the cursor to the top-left cell.
clear_screen:
  ; 0x06 is the scroll function (current screen gets scrolled out of view)
  mov ah, 0x06
  ; 0x00 tells it to completely scroll everything out of view
  mov al, 0x00
  ; Set background color to black and text color to light grey
  mov bh, 0x07
  ; Store the coordinates of the top-left cell and the bottom-right
  ; cells in CX and DX respectively.
  mov cx, 0x0000
  mov dx, 0x184F
  int 0x10

  ; Now just move the cursor back to the top-left cell.
  mov dx, 0x0000
  call move_cursor

  ret

; Moves the cursor to the specified coordinates
; in DX (DH=Row, DL=Column)
move_cursor:
  ; Move cursor function
  mov ah, 0x02
  ; Page 0
  mov bh, 0x00
  int 0x10
  ret

; Print a single character given by AL
; at the current position of the cursor
printc:
  ; 0x0E is the function to print a character
  ; from AL
  mov ah, 0x0E
  ; Page 0
  mov bh, 0x00
  ; Black background, light grey text
  mov bl, 0x07
  int 0x10
  ret

; Prints a NUL-terminated string given by the
; SI register to the screen.
print:
  lodsb
  ; Check if given byte is the terminating
  ; NUL character
  cmp al, 0x00
  jz .end
  call printc
  jmp print

.end:
  ret

; Like print but will add a linebreak after
; the given string.
println:
  call print

  ; Move to the next line
  mov al, `\n`
  call printc

  ; Move the cursor to the start of the line
  mov al, `\r`
  call printc

  ret
