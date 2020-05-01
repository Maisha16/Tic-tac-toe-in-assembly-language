.model small
 .stack 100h
.data

   
 len dw 0 
 ;cursor position 
 x dw ?
 y dw ?          
 
 countmoves dw ?
 win db ? 
 won db ?
 col db ?
 row dw ?
 pointX dw ?
 pointY dw ?
 opointx dw ?
 opointy dw ?
 xbox dw ?
 obox  dw ?  
 count db ?
 checkdrewx dw ?
 
 winnermsg db "YOU WON THE MATCH------Winner"
 loosemsg db  "SORRY GAME OVER------tlooser"
 
 tiemsg db "DRAW MATCH"
 
 replaymsg db "DO YOU Want TO PLAY AGAIN? (Y/N)"
 
 drawn db 9 dup(00h)
 

 .code  
 
 pushall macro 
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    push bp       
 endm
 



popall macro 
    pop bp
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
endm    

 clear_screenandsetcursor macro
    pushall
    mov ah,00h
    mov al,12h
    int 10h
    
    mov ah,2
    mov dh,27           ;set cursor
    mov dl,25
    mov bh,0
    int 10h
    popall
 endm 
 
resetvalue macro
    pushall
    mov x,0
    mov y,0
    mov countmoves,0
    mov win,0
    mov won,0
    mov col,0 
    mov row,0
    mov pointx,0
    mov pointy,0
    mov opointx,0
    mov opointy,0
    mov xbox,0
    mov obox,0
    mov checkdrewx,0
    
    mov bx,9
    mov cx,0
    
    resetdrawn:
    mov si,cx
    mov drawn[si],0
    inc cx
    cmp bx,cx
    jnz resetdrawn
    
    popall
    
    endm
    
   
;   
;
; onem macro i 
;        push ax 
;        push dx
;        mov dl,i
;        mov ah,2
;        add dl,'0'
;        int 21h 
;        pop ax 
;        pop dx
;        
;   endm onem
;printAx proc
;        push ax
;        push bx
;    
;    L1: 
;      mov bx,10
;      xor dx,dx
;      div bx
;      push dx
;      inc count
;      cmp ax,0
;      je L2
;      jmp L1
;      mov cl,count
;      
;    L2:
;      dec count
;      pop dx
;      onem dl
;      cmp count,0
;      je done
;      jmp L2
;      
;    done: 
;        pop bx
;        pop ax     

drawx macro startpointx,startpointy
    
    pushall
    
    mov si,xbox
    mov al,drawn[si]        ;box e kichu thakle wait for another input
    cmp al,0
    mov checkdrewx,0000h
    jnz finish
    
    mov bl,5
    mov si,xbox
    mov drawn[si],bl
    
    mov al,02h
    mov ah,0ch
    mov cx,startpointx
    mov dx,startpointy
    mov bx,50D
    add bx,startpointx 
    
    drawleft:
    int 10h
    inc cx
    inc dx
    cmp bx,cx
    jnz drawleft
    
    mov cx,startpointx 
    add cx,50D
    mov dx,startpointy
    mov bx,cx
    sub bx,50D
    
    drawright:
    int 10h
    dec cx
    inc dx
    cmp bx,cx
    jnz drawright
    
    mov checkdrewx,1
    
    inc countmoves
    
    popall
    
    finish:
    
    endm
    
drawO macro cenpointx,cenpointy   
    pushall
    
    check:
     mov si,obox
     mov al,drawn[si]
     cmp al,0
     jz draw0
     
     inc obox
     mov cx,9
     cmp cx,obox
     ja oboxorder
     mov dx,0000h
     mov ax,obox
     div cx
     mov obox,dx
     jmp oboxorder
     jmp check
     
     draw0:
     mov si,obox
     mov al,7
     mov drawn[si],al
     mov al,0eh
     mov ah,0ch
     mov cx,cenpointx
     mov dx,cenpointy
     int 10h
     
     inc countmoves
     popall
     
     endm
    
main   proc
  mov ax,@data
  mov ds,ax   
  
  START:
  
  resetvalue
  
 ;video mode setup           
  mov ah,0
  mov al,12h
  int 10h
  
  ;draw a pixel
  mov ah,0ch
  mov al,0eh
  
  
  mov cx,170
  mov dx,190
  mov len,470

Firstline:  
  int 10h
  inc cx
  cmp len,cx
  jnz Firstline
  
  mov cx,170
  mov dx,290
  mov len,470
  
Secondline:
  int 10h
  inc cx
  cmp len,cx
  jnz Secondline 
  
  mov cx,370
  mov dx,90
  mov len,390 
  
thirdline:
  int 10h
  inc dx
  cmp len,dx
  jnz thirdline 
  
  mov cx,270 
  mov dx,90
  mov len,390
  
Fourthline:
  int 10h
  inc dx
  cmp len,dx
  jnz Fourthline   
  
  MOV AX, 1003h
MOV BX, 0000h
INT 10h
  
;hide text cursor
    mov ch,32
    mov ah,1
    int 10h
 
;display mouse cursor:
 mov ax,1
 int 33h 

  ;call printAX
 
mouselocation:
  mov ax,3       ;mouse position &button status
  int 33h
  mov x,cx
  mov y,dx
  cmp bx,1 
  jz chk_bounds   
  jnz mouselocation 
  
 chk_bounds:

         MOV AX, 0154h
CMP AX, x
JA mouselocation

MOV AX, 03ACh
CMP AX, x
JB mouselocation

MOV AX, 05Ah
CMP AX, y
JA mouselocation

MOV AX, 0186h
CMP AX, y
JB mouselocation 

 
horizontal1:
  mov ax,021Ch
  cmp ax,x                   ;double value of x-coordinate
  jb horizontal2
  mov col,1
  mov pointx,195D

  jmp vertical1
  
horizontal2:
  mov ax,02E4h
  cmp ax,x
  jb  horizontal3
  mov col,2
  mov pointx,295D
  
  jmp vertical1
  
horizontal3:
 mov col,3
 mov pointx,395D
 jmp vertical1 
             
            
vertical1: 
 mov ax,0BEh 
 cmp ax,y
 jb vertical2
 mov row,1
 mov pointy,115D
 jmp xboxorder 
 
vertical2:
 mov ax,122h
 cmp ax,y 
 jb vertical3
 mov row,2
 mov pointy,215D 
 jmp xboxorder 
 
vertical3:
  mov row,3
  mov pointy,315D 
  jmp xboxorder 
  
xboxorder:

mov bl,1
cmp col,1
jnz coloumn2
mov ax,row
mov xbox,ax     ;first col e row-1 
sub xbox,1
jmp startdrawx

coloumn2:                               ;0 3 6
                                         ;1 4 7
cmp col,2                                  ;2  5 9
jnz coloumn3
mov ax,row
mov xbox,ax
add xbox,2
jmp startdrawx  ;2nd col e row+2

coloumn3:
mov ax,row
mov xbox,ax
add xbox,5
jmp startdrawx

startdrawx:

 drawx pointx,pointy  
 
 mov bx,1
 cmp bx, checkdrewx
 jnz mouselocation  
 
 
 mov bx,4
 cmp bx,countmoves
 jae startcalco
 
 mov win ,0000h
 
 call checkwin
 
 cmp won,'W'
 
 jz winingmsg
 cmp won,'L'
 jz gameovermsg
 
 mov bx,9
 cmp bx,countmoves
 jz gametiemsg   
 
 startcalco:
 
 mov ax,xbox
 mov obox,ax
 
 add obox,5
 
 mov cx,9
 cmp cx,obox
 ja oboxorder
 mov dx,0000h
 mov ax,obox
 div cx
 mov obox,dx
 
 oboxorder:
 mov bx,0
 cmp bx ,obox 
 jnz checkbox1 
 mov opointx,0DCh
 mov opointy,08Ch
 jmp  startdrawo
 
 checkbox1:
  mov bx,1
 cmp bx ,obox 
 jnz checkbox2 
 mov opointx,0DCh
 mov opointy,0F0h
 jmp  startdrawo 
 
 checkbox2:
  mov bx,2
 cmp bx ,obox 
 jnz checkbox3 
 mov opointx,0DCh
 mov opointy,0154h
 jmp  startdrawo
 
 checkbox3:
 
  mov bx,3
 cmp bx ,obox 
 jnz checkbox4 
 mov opointx,0140h
 mov opointy,08Ch
 jmp  startdrawo
 
 checkbox4:
  mov bx,4
 cmp bx ,obox 
 jnz checkbox5 
 mov opointx,0140h
 mov opointy,0F0h
 jmp  startdrawo 
 
 checkbox5:
 
  mov bx,5
 cmp bx ,obox 
 jnz checkbox6 
 mov opointx,0140h
 mov opointy,154h
 jmp  startdrawo 
 
 checkbox6:
  mov bx,6
 cmp bx ,obox 
 jnz checkbox7 
 mov opointx,01A4h
 mov opointy,08Ch
 jmp  startdrawo 
 
 checkbox7:
 
  mov bx,7
 cmp bx ,obox 
 jnz checkbox8 
 mov opointx,01A4h
 mov opointy,0F0h
 jmp  startdrawo
 
 checkbox8:
 mov opointx,01A4h
 mov opointy,0154h
 
 startdrawo: 
 
 drawO opointx,opointy   
 
  mov bx,4
 cmp bx,countmoves
 jae mouselocation
 
 mov win, 0000h
 
 call checkwin
 
 cmp won,'W'
 
 jz winingmsg
 cmp won,'L'
 jz gameovermsg
 
 mov bx,9
 cmp bx,countmoves
 jz gametiemsg   
 
 jmp mouselocation 
 
 
 
 checkwin proc 
    
    pushall 
    
    mov cx,3
    mov win,0000h
    
    vvertical1:  
    mov si,cx
    sub si,1
    mov al,drawn[si]
    add win,al
    loop vvertical1
    
    mov bl,15
    
    cmp cl,win
    jz finishWinChkWon
    
    mov bl,21
    cmp bl,win
    jz finishWinChkLoss
    
    mov cx,3
    mov win,0000h
    
    vvertical2:
     MOV SI, CX
    ADD SI, 2
    MOV AL, drawn[SI]
    ADD Win, AL
    LOOP vvertical2      
    
    MOV BL, 15
    CMP BL, win
    JZ finishWinChkWon
    
    MOV BL, 21
    CMP BL, win
    JZ finishWinChkLoss
    
    MOV CX, 3
    MOV win, 0000h
    Vvertical3:
    MOV SI, CX
    ADD SI, 5
    MOV AL, drawn[SI]
    ADD win, AL
    LOOP Vvertical3
    
    MOV BL, 15
    CMP BL, win
    JZ finishWinChkWon
    
    MOV BL, 21
    CMP BL, win
    JZ finishWinChkLoss
    
    
    ; HORIZONTAL
    MOV CX, 3
    MOV BX, 0 
    MOV win, 0000h
    Hhorizontal1:
    MOV SI, BX
    MOV AL, drawn[SI]
    ADD win, AL
    ADD BX, 3
    LOOP Hhorizontal1
 
    MOV BL, 15
    CMP BL, win
    JZ finishWinChkWon
    
    MOV BL, 21
    CMP BL, win
    JZ finishWinChkLoss
    
       
    MOV CX, 3
    MOV BX, 1 
    MOV win, 0000h
    Hhorizontal2:
    MOV SI, BX
    MOV AL, drawn[SI]
    ADD win, AL
    ADD BX, 3
    LOOP Hhorizontal2
    
    MOV BL, 15
    CMP BL, win
    JZ finishWinChkWon
    
    MOV BL, 21
    CMP BL, win
    JZ finishWinChkLoss         

    MOV CX, 3
    MOV BX, 2 
    MOV win, 0000h
    Hhorizontal3:
    MOV SI, BX
    MOV AL, drawn[SI]
    ADD win, AL
    ADD BX, 3
    LOOP Hhorizontal3
    
    MOV BL, 15
    CMP BL, win
    JZ finishWinChkWon
    
    MOV BL, 21
    CMP BL, win
    JZ finishWinChkLoss         
             
    MOV CX, 3
    MOV BX, 0 
    MOV win, 0000h
    Diagonal1:
    MOV SI, BX
    MOV AL, drawn[SI]
    ADD win, AL
    ADD BX, 4
    LOOP Diagonal1     
    
    MOV BL, 15
    CMP BL, win
    JZ finishWinChkWon
    
    MOV BL, 21
    CMP BL, win
    JZ finishWinChkLoss

    MOV CX, 3
    MOV BX, 2
    MOV win, 0000h
    Diagonal2:
    MOV SI, BX
    MOV AL, drawn[SI]
    ADD win, AL
    ADD BX, 4
    LOOP Diagonal2

    MOV BL, 15
    CMP BL, win
    JZ finishWinChkWon
    
    MOV BL, 21
    CMP BL, win
    JZ finishWinChkLoss
    
    JMP finishWinChk
    
    finishWinChkWon:
    MOV Won, 'W'
    JMP finishWinChk
    
    finishWinChkLoss:
    MOV Won, 'L'
 
    finishWinChk:
    popall
    RET
    
checkwin ENDP



winingmsg:
clear_screenandsetcursor

; Display the celebration message.

MOV CX, 0
writeCharacter:
MOV SI, CX
MOV DL, winnermsg[SI]
MOV AH, 2
INT 21h
INC CX
CMP CX, 29
JNZ writeCharacter 
JMP displayReplayMessage
                         

gameovermsg:
clear_screenandsetcursor


MOV CX, 0
writeCharacter1:
MOV SI, CX
MOV DL, loosemsg[SI]
MOV AH, 2
INT 21h
INC CX
CMP CX, 33
JNZ writeCharacter1
JMP displayReplayMessage
  


gametiemsg:     

clear_screenandsetcursor

MOV CX, 0
writeCharacter2:
MOV SI, CX
MOV DL, tiemsg[SI]
MOV AH, 2
INT 21h
INC CX
CMP CX, 28
JNZ writeCharacter2
JMP displayReplayMessage
                                             
                                             
; Display replay message and recieve response

displayReplayMessage:

MOV AH, 2
MOV DH, 29 
MOV DL, 28
MOV BH, 0
INT 10h


; Display replay message.

MOV CX, 0
writeCharacter3:
MOV SI, CX
MOV DL, replaymsg[SI]
MOV AH, 2
INT 21h
INC CX
CMP CX, 32
JNZ writeCharacter3

MOV AH, 1
INT 21h

CMP AL, 'Y'
JZ START
CMP AL, 'y'
JZ START
CMP AL, 'N'
JZ DONEE
CMP AL, 'n'
JZ DONEE
                  
                  
DONEE:
END
    
    
