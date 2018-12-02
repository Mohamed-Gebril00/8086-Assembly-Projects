                                   
name "RC-4"





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; this maro is copied from emu8086.inc ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this macro prints a char in AL and advances
; the current cursor position:
PUTC    MACRO   char
        PUSH    AX
        MOV     AL, char
        MOV     AH, 0Eh
        INT     10h     
        POP     AX
ENDM
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;MACRO used to print strings on the screen
cout    MACRO   ms 
        push dx
        push ax
        lea DX, ms
        mov ah, 9 
        int 21h
        pop ax
        pop dx
ENDM   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
;macro that takes input key stroke and echo it to screen 
cin MACRO   
    ; get char from keyboard
    ; into AL:
     MOV     AH, 00h
     INT     16h
     ; and print it:
     MOV     AH, 0Eh
     INT     10h   
ENDM
                     



org 100h

jmp start


; define variables:
out1 db "Names: 1- Mohamed Ahmed Gebril",20h,020h,"RC-4 algo",0Dh,0Ah,
     db  '$'

ok db "ok $"
out2 db 0Dh,0Ah, 0Dh,0Ah, 'enter the secret key : $' 
out6 db  0dh,0ah ,'thank you for using RC4! press any key... ', 0Dh,0Ah, '$'
che db 0dh,0ah,"check the memory and press enter",0Dh,0Ah,'$'          
get_char db "Please press enter to generate PRGA output $" 
key_str db "The key stream byte is: $"
wrong db "This in not a number",0Dh,0Ah , '$'  
ksaa db "Ksa Done",0dh,0Ah,'$'



; first and second number:

k db ?     ;secret_key length
i db 0     ;index
j db 0     ;index
rem db 0   ;remainder used in calcuations
sec_keyStart dw 0000h     ;the beginning of the sec_key array
S_start dw 0010h           ;the beginning of s_start
S_size db 10               ;array s size   
x_swap db ?
cnt dw 1  




start: 
cout out1 ;output a string out1



cout out2 ;output a string out2  


;size of secret_key buffer
mov dx,10 ;the size of the bffer

call GET_STRING ;get the secret_key from the user
cout che
 
;;;;;;;;;;;; stop the program to see the memory make sure everything is good
mov ah, 0
int 16h   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;putc 0Dh
;putc 0Ah



;mov al,k
;call print_num



call ksa ;ksa first scrambling
cout ksaa 

 
;;;;;;;;;;;; stop the program to see the memory make sure everything is good
mov ah, 0
int 16h   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;i=j=0  
mov dx,0 
mov  i,dl   ;reinitialize i and j
mov j,dl        
        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
PRGA: 
     mov dx,0 
     mov cx,0
     
     mov si,S_start ;si and bx at the beginning of s array
     mov bx,S_start
    
     cout get_char 
     mov ax,cnt ;the number of the key stream byte
     call print_num
     putc ':'
     putc 20h
   
     
     
     mov ah, 0
     int 16h     
  
     CMP     AL, 0Dh                  ; 'RETURN' pressed?
     Jne     exit                     ;if not equal Enter exit 
     
     
     ;new line
     putc 0Dh
     putc 0Ah
      
                                       
                                      
     mov ax,0       ;make sure ax =0  
     
     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;i=(i+1)%s array lenth (10)
     mov dl,i
     inc dl         ;i+1
     mov al,dl      ;put i+1 in al dividend
     mov dl,S_size  ;array_length 10
     div dl         ;divide
     
     mov dl,ah      ;put (i+1)%array_size in dl
     mov i,ah       ;i=(i+1)%s array lenth (10)
     mov al,ah
     ;mov ah,0
     ;call print_num
     ;putc 20h
     mov ax,0
     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      
      
      
      
      
     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;j=(j+s[i])%array_length 
     ;s[i]
     add si,dx     ;add si(beginning of s array and dx(i) )
     mov dl,[si]   ;get the ith element in dl
     add dl,j      ;j+s[i]
     mov al,dl     ;divisoon again 
     mov dl,S_size
     div dl
     mov j,ah       ;j=(j+s[i])%array_length 
     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     
     mov al,ah
     ;mov ah,0
     ;call print_num 
     ;putc 20h
     mov ax,0  
     
     
     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;swapping s[i],s[j] 
     mov si,S_start
     mov bx,S_start
     mov dh,00        ;put zeros to dh as we will transfer bytes then word 
     
     
     mov dl,j         ; put j index in dl   
     add si,dx        ;add index to si to get the required element                     
     mov dl,[si]      ;put the element (byte) to dl
    mov x_swap,dl      ;we got s[j] in x_swap and its place in si
   
   
    mov dl,i     ;then put i in dl to get the ith element and put it in dl
    add bx,dx     ;add the index to bx
    mov dl,[bx]   ;get the ith element and put it in dl
    
    
    mov [si],dl   ;put the ith element in the jth place
    mov dl,x_swap  ;then the jth element
    mov [bx],dl     ;int the ith place
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    
    
    mov cl,[si]  ;s[i]
    add dl,cl    ;s[j] + s[i]
     
    mov al,dl    ;put (s[j]+s[i]) in al to divie
    mov dl,S_size  ;put the dividend 10 in dl 
    div dl         ;divide
    
    
    mov dl,ah      ;put the remainder in dl
    
    mov si,S_start  ;put si to the beginning of S array
    
    add si,dx        ;s[s(i)+s(j)]%256
    mov dl,[si]      ;get the key_stream print it
    mov ah,00
    mov al,00 
    cout key_str
    mov al,dl        ;print the key_stream byte
    call print_num 
    ;new line   
    putc 0DH
    putc 0AH 
    ;increment counter
    inc cnt 
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    jmp PRGA ;start again
     
 


exit:
    cout out6
    mov ah,0
    int 16
    iret  ; return back to os.

                         
                         
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; these functions are copied from emu8086.inc ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; this procedure prints number in AX,
; used with PRINT_NUM_UNS to print signed numbers:
; gets the multi-digit SIGNED number from the keyboard,
; and stores the result in CX register:
SCAN_NUM        PROC    NEAR
        PUSH    DX
        PUSH    AX
        PUSH    SI
        
        MOV     CX, 0

        ; reset flag:
        MOV     CS:make_minus, 0

next_digit:

        ; get char from keyboard
        ; into AL:
        MOV     AH, 00h
        INT     16h
        ; and print it:
        MOV     AH, 0Eh
        INT     10h

        ; check for MINUS:
        CMP     AL, '-'
        JE      set_minus

        ; check for ENTER key:
        CMP     AL, 0Dh  ; carriage return?
        JNE     not_cr
        JMP     stop_input
not_cr:


        CMP     AL, 8                   ; 'BACKSPACE' pressed?
        JNE     backspace_checked
        MOV     DX, 0                   ; remove last digit by
        MOV     AX, CX                  ; division:
        DIV     CS:ten                  ; AX = DX:AX / 10 (DX-rem).
        MOV     CX, AX
        PUTC    ' '                     ; clear position.
        PUTC    8                       ; backspace again.
        JMP     next_digit
backspace_checked:


        ; allow only digits:
        CMP     AL, '0'
        JAE     ok_AE_0
        JMP     remove_not_digit
ok_AE_0:        
        CMP     AL, '9'
        JBE     ok_digit
remove_not_digit:       
        PUTC    8       ; backspace.
        PUTC    ' '     ; clear last entered not digit.
        PUTC    8       ; backspace again.        
        JMP     next_digit ; wait for next input.       
ok_digit:


        ; multiply CX by 10 (first time the result is zero)
        PUSH    AX
        MOV     AX, CX
        MUL     CS:ten                  ; DX:AX = AX*10
        MOV     CX, AX
        POP     AX

        ; check if the number is too big
        ; (result should be 16 bits)
        CMP     DX, 0
        JNE     too_big

        ; convert from ASCII code:
        SUB     AL, 30h

        ; add AL to CX:
        MOV     AH, 0
        MOV     DX, CX      ; backup, in case the result will be too big.
        ADD     CX, AX
        JC      too_big2    ; jump if the number is too big.

        JMP     next_digit

set_minus:
        MOV     CS:make_minus, 1
        JMP     next_digit

too_big2:
        MOV     CX, DX      ; restore the backuped value before add.
        MOV     DX, 0       ; DX was zero before backup!
too_big:
        MOV     AX, CX
        DIV     CS:ten  ; reverse last DX:AX = AX*10, make AX = DX:AX / 10
        MOV     CX, AX
        PUTC    8       ; backspace.
        PUTC    ' '     ; clear last entered digit.
        PUTC    8       ; backspace again.        
        JMP     next_digit ; wait for Enter/Backspace.
        
        
stop_input:
        ; check flag:
        CMP     CS:make_minus, 0
        JE      not_minus
        NEG     CX
not_minus:

        POP     SI
        POP     AX
        POP     DX
        RET
make_minus      DB      ?       ; used as a flag.
SCAN_NUM        ENDP





PRINT_NUM       PROC    NEAR
        PUSH    DX
        PUSH    AX

        CMP     AX, 0
        JNZ     not_zero

        PUTC    '0'
        JMP     printed

not_zero:
        ; the check SIGN of AX,
        ; make absolute if it's negative:
        CMP     AX, 0
        JNS     positive
        NEG     AX

        PUTC    '-'

positive:
        CALL    PRINT_NUM_UNS
printed:
        POP     AX
        POP     DX
        RET
PRINT_NUM       ENDP



; this procedure prints out an unsigned
; number in AX (not just a single digit)
; allowed values are from 0 to 65535 (FFFF)
PRINT_NUM_UNS   PROC    NEAR
        PUSH    AX
        PUSH    BX
        PUSH    CX
        PUSH    DX

        ; flag to prevent printing zeros before number:
        MOV     CX, 1

        ; (result of "/ 10000" is always less or equal to 9).
        MOV     BX, 10000       ; 2710h - divider.

        ; AX is zero?
        CMP     AX, 0
        JZ      print_zero

begin_print:

        ; check divider (if zero go to end_print):
        CMP     BX,0
        JZ      end_print

        ; avoid printing zeros before number:
        CMP     CX, 0
        JE      calc
        ; if AX<BX then result of DIV will be zero:
        CMP     AX, BX
        JB      skip
calc:
        MOV     CX, 0   ; set flag.

        MOV     DX, 0
        DIV     BX      ; AX = DX:AX / BX   (DX=remainder).

        ; print last digit
        ; AH is always ZERO, so it's ignored
        ADD     AL, 30h    ; convert to ASCII code.
        PUTC    AL


        MOV     AX, DX  ; get remainder from last div.

skip:
        ; calculate BX=BX/10
        PUSH    AX
        MOV     DX, 0
        MOV     AX, BX
        DIV     CS:ten  ; AX = DX:AX / 10   (DX=remainder).
        MOV     BX, AX
        POP     AX

        JMP     begin_print
        
print_zero:
        PUTC    '0'
        
end_print:

        POP     DX
        POP     CX
        POP     BX
        POP     AX
        RET
PRINT_NUM_UNS   ENDP



ten             DW      10      ; used as multiplier/divider by SCAN_NUM & PRINT_NUM_UNS.





;this procedure to get a string from the user

GET_STRING      PROC    NEAR
PUSH    AX
PUSH    CX
PUSH    DI
PUSH    DX

MOV     CX, 0                   ; char counter.
CMP     DX, 1                   ; buffer too small?
JBE     empty_buffer            ;

DEC     DX                      ; reserve space for last zero.


;============================
; Eternal loop to get
; and processes key presses:

wait_for_key:

MOV     AH, 0                   ; get pressed key.
INT     16h

CMP     AL, 0Dh                  ; 'RETURN' pressed?
JZ      exit_GET_STRING


CMP     AL, 8                   ; 'BACKSPACE' pressed?
JNE     add_to_buffer
JCXZ    wait_for_key            ; nothing to remove!
DEC     CX
DEC     DI
PUTC    8                       ; backspace.
PUTC    ' '                     ; clear position.
PUTC    8                       ; backspace again.
JMP     wait_for_key

add_to_buffer:

        CMP     CX, DX          ; buffer is full?
        JAE     wait_for_key    ; if so wait for 'BACKSPACE' or 'RETURN'...

        MOV     [DI], AL
        INC     DI
        INC     CX 
        
        
        ; print the key:
        MOV     AH, 0Eh
        INT     10h

JMP     wait_for_key
;============================

exit_GET_STRING:

; terminate by null:
MOV     [DI], 0  
mov k,cl

empty_buffer:

POP     DX
POP     DI
POP     CX
POP     AX
RET
GET_STRING      ENDP









;;ksa procedure 
ksa proc near
    push di
    push si
    push bx
    push ax
    push cx
    push dx
    
    ;intialize loop counter with 10
    mov cx,10  ;here for the sake of simplicity you can put it 256 as you want 
    


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;initialize the permutauion array 
mov di,S_start ;put di to the beginning of the secret key array  0010h   
ksa_loop:     
    mov dl,i ;i the index  
    mov [di],dl  ;put i in the di offset
    inc i        ;increment i
    inc di       ;increment di
loop ksa_loop  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

mov ah, 0
     int 16h     


mov dx,0 
mov ax,0
mov i,dl  ;i=0
mov cx,10 ;loop counter
mov bx,sec_keyStart   ;put the bx to the beginning of the secret key array

fir_scramble: 
   ;make sure ax=0 and dx=0 to use them in the loop 
   mov ax,0        
   mov dx,0       
   
   ;si at the beginning of S array start 
   ;b at the beginning od secret key array start
   mov si,S_start
   mov bx,sec_keyStart  
   
    
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
   ;j=(j+s[i]+secret_key[i%length of secret key(k)])%10(s_size)
        mov dl,i ;put i in dl
        add si,dx  ;add i to si th s array index 
   
        mov dl,j   ;put j in dx                   
   
   
        add dl,[si] ;j=j+s[i]
    
        ;divide i%k
        mov al,i                 ; dividend in al (16/8 bit division)
        push dx                   ;put j+s[i] on the stack cause we will use dx
        mov dl,k                  ;the length of secret key
        div dl                       ;ax/dl remainder in ah 
   
        pop dx                   ;get the dx(j+s[i]) in dx again
        mov rem,ah  ;            put remainder in rem var(i%k) 
        ;mov al,ah
        mov ah,00 
        ; call print_num
        ;putc 20h 
     
     
        ;secret_key[i%k]
        push bx                  ;push bx to stack       
        add bl,rem               ;add rem to the beginning of bx (index of the secret key array)
        add dl,[bx]              ;j+s[i]+[bx](secret_key[i%k])
        pop bx                   ;get bx again 0000h
   
        ;put dx=j+s[i]+secre_key[i%k] to ax   (dividend)
        mov ax,dx   
        mov dl,S_size       ;S size divisor in dl
        div dl              ;divide
        ;mov al,ah 
        mov j,ah            ;j=(j+s[i]+secret_key[i%length of secret key(k)])%10(s_size)
        mov ah,00 
        ;call print_num
        ;putc 0Dh
        ;putc 0Ah 
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
    
    
   ;swapping s[i],s[j]
   mov bx,S_start   ;put the beginning address of S array at the bx
   mov si,S_start    ;put the beginning address of S array at the si
   
   mov dh,00        ;put zeros to ah as we will transfer bytes then word
   mov dl,j         ; put j index in dl   
   add si,dx        ;add index to si to get the required element                     
   mov dl,[si]      ;put the jth element (byte) to dl
   mov x_swap,dl    ;put it in x_swap
   
   
   mov dl,i           ;then put i in dl to get the ith element and put it in dl
   add bx,dx           ;add i to the beginning of the array
   mov dl,[bx]         ;put the ith element in dl
   mov [si],dl         ;put the ith element in jth place
   mov dl,x_swap       ;put the jth element in ith place
   mov [bx],dl 
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   
   ;increment i      
   inc i 
   
   
loop fir_scramble ;loop until cx=0
   
    pop dx
    pop cx
    pop ax
    pop bx
    pop si
    pop di
RET
ksa ENDP
    
    