.model small
.stack 100h
.data 
    BOARD db '123456789$'
    WELLCOME db 'Wellcome to Tic Tac Toe By Group 22!', 13, 10, '$'
    MEM1 db 'Nguyen Hoai An', 13, 10, '$'
    MEM2 db 'Nguyen Manh Kha', 13, 10, '$'
    MEM3 db 'Nguyen Duc Long', 13, 10, '$'
    MEM4 db 'Lang Viet Thanh', 13, 10, '$'
    REQ db 'Press Any Key to Play Game!$'
    IN_PLAYER_X db 'Player X turn, Enter position (1-9): $'
    IN_PLAYER_O db 'Player O turn, Enter position (1-9): $'
    INVALID_MOVE db 'Invalid move! Try again : $'
    X_WIN_OUT db 'Player X wins!$'
    O_WIN_OUT db 'Player O wins!$'
    DRAW_OUT db 'Draw!$'
    crlf db 13, 10, '$'
    cnt dw ?
    cur_row db ?
    cur_column db ?
    cot_doc db '|$'
    cot_ngang db '-------$' 
    msg_mem db 'Game made by:',13,10,'$' 
    msg_choose_mode db 'You want to play with...$'
    mode1 db '1.HUMAN$'
    mode2 db '2.COMPUTER$'
    msg_answer db 'Press your anser: $'
    cot dw ?
    hang dw ?
    select_mode db ? 
.code

MAIN PROC         
    mov ax, @data
    mov ds, ax 
    
    call INTRO 
    
    mov cnt,0
    
    call CLEAR_SCREEN
    call MODE 
    
    mov select_mode,al
    cmp al,1
    je GAME_VS_HUMAN
    jmp GAME_VS_COMPUTER
     
    GAME_VS_HUMAN:
        mov bx,0
        call CLEAR_SCREEN  
        call PRINT_TABLE
        call CHECK_WIN
        
        cmp al,'X'
        je  X_WIN
        
        cmp al,'O'
        je O_WIN
        
        call CHECK_DRAW
        cmp al,1
        je GAME_DRAW
        
        mov ax,cnt
        mov bh,2
        div bh
        
        cmp ah,0
        je X_TURN 
        jmp O_TURN
        
        CONTINUE_GAME_VS_HUMAN:
        inc cnt
        jmp GAME_VS_HUMAN
        
    
    GAME_VS_COMPUTER: 
        mov bx,0
        call CLEAR_SCREEN  
        call PRINT_TABLE
        call CHECK_WIN
        
        cmp al,'X'
        je  X_WIN
        
        cmp al,'O'
        je O_WIN
        
        call CHECK_DRAW
        cmp al,1
        je GAME_DRAW
        
        mov ax,cnt
        mov bh,2
        div bh
        
        cmp ah,0
        je X_TURN ; HUMAN_TURN 
        jmp COMPTUER_TURN
        
        CONTINUE_GAME_VS_COMPUTER:
        inc cnt
        jmp GAME_VS_COMPUTER    
     
    GAME_END:
    mov ah, 4Ch
    int 21h   
        
    
MAIN ENDP

;=======================================================================================================================================

COMPTUER_TURN PROC 
    
    call CHANCE_TO_WIN
    cmp al,1 ; kiem tra co hoi chien thang 
    je ENTER_MOVE
    
    call CHANCE_TO_BLOCK
    cmp al,1
    je ENTER_MOVE
    
    call CHECK_MIDDLE_POS
    cmp al,1
    je ENTER_MOVE
    
    call CHECK_CORNER_POS
    cmp al,1
    je ENTER_MOVE 
    
    call CHECK_RANDOM_POS
    cmp al,1
    je ENTER_MOVE
    
    RET
COMPTUER_TURN ENDP        

;=======================================================================================================================================

ENTER_MOVE PROC
    ;toa do cua vi tri dien O da duoc luu tai hang va cot
    lea si,BOARD
    add si,hang
    add si,cot
    mov [si],'O'
    jmp CONTINUE_GAME_VS_COMPUTER 
    RET
ENTER_MOVE ENDP       

;=======================================================================================================================================
                                                                         
CHANCE_TO_WIN PROC
; check row================================================= 
    
    lea si,BOARD
    mov cx,3
    POS_IN_ROW:
        mov bl,0
        mov hang,si 
        
        cmp [si],'X'
        je INC_ROW
        cmp [si],'O'
        jne CONT_ROW1
        mov cot,1
        inc bl ; dem O trong mot hang
        
        CONT_ROW1:
        cmp [si+1],'X'
        je INC_ROW
        cmp [si+1],'O'
        jne CONT_ROW2
        inc bl 
        mov cot,2
        
        CONT_ROW2:
        cmp [si+2],'X'
        je INC_ROW
        cmp [si+2],'O'
        jne CHECK_POS_IN_ROW
        inc bl 
              
        mov dx,cot
        cmp dl,1  ;hang=1 tuc la 
        jne CAN_PUT_O_TO_WIN_IN_ROW
        mov cot,1 
        
        jmp CHECK_POS_IN_ROW
        
        CAN_PUT_O_TO_WIN_IN_ROW:
        mov cot,0 
        
        ;kiem tra dieu kien
        CHECK_POS_IN_ROW:
        cmp bl,2
        je FOUNDED_POS_WIN;bl=2
         
        INC_ROW: 
            add si,3
        loop POS_IN_ROW
    
; check column=================================================
    
    lea si,BOARD
    mov cx,3
    
    POS_IN_COLUMN:
        mov bl,0
        mov cot,si
        
        cmp [si],'X'
        je INC_COLUMN
        cmp [si],'O'
        jne CONT_COLUMN1
        mov hang,3
        inc bl ; dem O trong mot cot
        
        CONT_COLUMN1:
        cmp [si+3],'X'
        je INC_COLUMN
        cmp [si+3],'O'
        jne CONT_COLUMN2
        inc bl 
        mov hang,6
        
        CONT_COLUMN2:
        cmp [si+6],'X'
        je INC_COLUMN
        cmp [si+6],'O'
        jne CHECK_POS_IN_COLUMN
        inc bl
        mov dx,hang
        cmp dl,3  ;hang=1 tuc la 
        jne CAN_PUT_O_TO_WIN_IN_COLUMN
        mov hang,3 
        
        jmp CHECK_POS_IN_COLUMN
        
        CAN_PUT_O_TO_WIN_IN_COLUMN:
        mov hang,0  
        
        CHECK_POS_IN_COLUMN:
        cmp bl,2
        je FOUNDED_POS_WIN;bl=2
         
        INC_COLUMN: 
            inc si
        loop POS_IN_COLUMN    
    
; check cheo xuoi 
    
    lea si,BOARD
    CHEO_XUOI: 
        mov bl,0
        cmp [si],'X'
        je CHEO_NGUOC
        cmp [si],'O'
        jne CONT_XUOI1
        inc bl
        mov hang,3
        mov cot,1
        
        CONT_XUOI1:
        cmp [si+4],'X'
        je CHEO_NGUOC
        cmp [si+4],'O'
        jne CONT_XUOI2
        inc bl
        mov hang,6
        mov cot,2 
        
        CONT_XUOI2:
        cmp [si+8],'X'
        je CHEO_NGUOC
        cmp [si+8],'O'
        jne CHECK_CHEO_XUOI
        inc bl
        mov cot,0
        mov hang,0
        
    CHECK_CHEO_XUOI:
    cmp bl,2
    je FOUNDED_POS_WIN;bl=2 
    ; check cheo nguoc
    
    lea si,BOARD
    CHEO_NGUOC: 
        mov bl,0
        cmp [si+2],'X'
        je NOT_FOUND 
        cmp [si+2],'O'
        jne CONT_NGUOC1
        inc bl
        mov hang,3
        mov cot,1
        
        CONT_NGUOC1:
        cmp [si+4],'X'
        je NOT_FOUND
        cmp [si+4],'O'
        jne CONT_NGUOC2
        inc bl
        mov hang,6
        mov cot,0
        
        CONT_NGUOC2:
        cmp [si+6],'X'
        je NOT_FOUND
        cmp [si+6],'O'
        jne CHECK_CHEO_NGUOC
        inc bl 
        mov cot,2
        mov hang,0
    CHECK_CHEO_NGUOC:
    cmp bl,2
    je FOUNDED_POS_WIN
    
    NOT_FOUND:  
    mov al,0
    RET 
    FOUNDED_POS_WIN:
    mov al,1
    RET
CHANCE_TO_WIN ENDP                                                                            

;=======================================================================================================================================

CHANCE_TO_BLOCK PROC
; check row=================================================   
    lea si,BOARD
    mov cx,3
    ROW_X:
        mov bl,0
        mov hang,si 
        
        
        cmp [si],'O'
        je INC_ROW_X
        cmp [si],'X'
        jne CONT_ROW_X1
        mov cot,1
        inc bl ; dem X trong mot hang
        
        CONT_ROW_X1:
        cmp [si+1],'O'
        je INC_ROW_X
        cmp [si+1],'X'
        jne CONT_ROW_X2
        inc bl 
        mov cot,2
        
        CONT_ROW_X2:
        cmp [si+2],'O'
        je INC_ROW_X
        cmp [si+2],'X'
        jne CHECK_ROW_X
        inc bl
        
        mov dx,cot
        cmp dl,1  ;cot=1 tuc la hang  cot 0 da dung
        jne CAN_PUT_O_TO_BLOCK_IN_ROW
        mov cot,1 
        
        jmp CHECK_ROW_X
        
        CAN_PUT_O_TO_BLOCK_IN_ROW:
        mov cot,0
        
        CHECK_ROW_X:
        cmp bl,2
        je FOUNDED_POS_BLOCK;bl=2
         
        INC_ROW_X:
            add si,3
        loop ROW_X
    
; check column=================================================
    
    lea si,BOARD
    mov cx,3
    
    COLUMN_X:
        mov bl,0
        mov cot,si
        
        
        cmp [si],'O'
        je INC_COLUMN_X
        cmp [si],'X'
        jne CONT_COLUMN_X1
        mov hang,3
        inc bl ; dem X trong mot cot
        
        CONT_COLUMN_X1:
        cmp [si+3],'O'
        je INC_COLUMN_X
        cmp [si+3],'X'
        jne CONT_COLUMN_X2
        inc bl 
        mov hang,6
        
        CONT_COLUMN_X2:
        cmp [si+6],'O'
        je INC_ROW
        cmp [si+6],'X'
        jne CHECK_COLUMN_X
        inc bl 
                
        mov dx,hang
        cmp dl,3  ;cot=1 tuc la hang  cot 0 da dung
        jne CAN_PUT_O_TO_BLOCK_IN_COLUMN
        mov hang,3 
        
        jmp CHECK_COLUMN_X
        
        CAN_PUT_O_TO_BLOCK_IN_COLUMN:
        mov hang,0
        
        CHECK_COLUMN_X:
        cmp bl,2
        je FOUNDED_POS_BLOCK;bl=2
         
        INC_COLUMN_X:  
            inc si
        loop COLUMN_X    
    
; check cheo xuoi 

    lea si,BOARD
    CHEO_XUOI_X: 
        mov bl,0
        cmp [si],'O'
        je CHEO_NGUOC_X
        cmp [si],'X'
        jne CONT_XUOI_X1
        inc bl
        mov hang,3
        mov cot,1
        
        CONT_XUOI_X1:
        cmp [si+4],'O'
        je CHEO_NGUOC_X
        cmp [si+4],'X'
        jne CONT_XUOI_X2
        inc bl
        mov hang,6
        mov cot,2 
        
        CONT_XUOI_X2:
        cmp [si+8],'O'
        je CHEO_NGUOC_X
        cmp [si+8],'X'
        jne CHECK_CHEO_XUOI_X
        inc bl
        mov cot,0
        mov hang,0
    CHECK_CHEO_XUOI_X:
    cmp bl,2
    je FOUNDED_POS_BLOCK;bl=2
     
    ; check cheo nguoc   
    
    
    lea si,BOARD
    CHEO_NGUOC_X: 
        mov bl,0
        cmp [si+2],'O'
        je NOT_FOUNDED_BLOCK 
        cmp [si+2],'X'
        jne CONT_NGUOC_X1
        inc bl
        mov hang,3
        mov cot,1
        
        CONT_NGUOC_X1:
        cmp [si+4],'O'
        je NOT_FOUNDED_BLOCK
        cmp [si+4],'X'
        jne CONT_NGUOC_X2
        inc bl
        mov hang,6
        mov cot,0
        
        CONT_NGUOC_X2:
        cmp [si+6],'O'
        je NOT_FOUNDED_BLOCK
        cmp [si+6],'X'
        jne CHECK_CHEO_NGUOC_X
        inc bl
        mov cot,2
        mov hang,0
    CHECK_CHEO_NGUOC_X:
    cmp bl,2
    je FOUNDED_POS_BLOCK
    
    NOT_FOUNDED_BLOCK:  
    mov al,0
    RET 
    FOUNDED_POS_BLOCK:
    mov al,1
    RET
CHANCE_TO_BLOCK ENDP 

;=======================================================================================================================================

CHECK_MIDDLE_POS PROC 
    cmp [si+4],'X'
    je CANT_INSERT_MIDDLE 
    cmp [si+4],'O'
    je CANT_INSERT_MIDDLE  
    mov hang,3
    mov cot,1
    mov al,1
    RET
    CANT_INSERT_MIDDLE:
    mov al,0
    RET
CHECK_MIDDLE_POS ENDP        

;=======================================================================================================================================
 
CHECK_CORNER_POS PROC
    mov cx,2
    lea si,BOARD 
    mov hang,si
    mov cot,0
    FIND_CORNER_ROW_1:
        cmp [si],'X'
        je NEXT_CORNER_ROW_1
        cmp [si],'O'
        je NEXT_CORNER_ROW_1    
        jmp FOUNDED_CORNER_POS
        
        NEXT_CORNER_ROW_1:  
        mov cot,2
        add si,2
    loop FIND_CORNER_ROW_1 
    
    mov cx,2
    add si,4 ;chuyen con tro xuong hang 3
    mov hang,si
    mov cot,0
    FIND_CORNER_ROW_3:
        cmp [si],'X'
        je NEXT_CORNER_ROW_3
        cmp [si],'O'
        je NEXT_CORNER_ROW_3
             
        jmp FOUNDED_CORNER_POS
        
        NEXT_CORNER_ROW_3:
        mov cot,2 
        add si,2
    loop FIND_CORNER_ROW_3
    
    NOT_FOUNDED_CORNER_POS:
    mov al,0
    RET
    
    FOUNDED_CORNER_POS:
    mov al,1    
    RET
CHECK_CORNER_POS ENDP    

;=======================================================================================================================================

CHECK_RANDOM_POS PROC
    lea si,BOARD
    mov cx,9
    mov hang,0
    mov cot,0
    FIND_RANDOM: 
        cmp [si],'X'
        je CONT_FIND_RANDOM
        cmp [si],'O'        
        je CONT_FIND_RANDOM
        
        mov hang,si
        jmp FOUNDED_RANDOM_POS                    
        
        CONT_FIND_RANDOM:
            inc si
            loop FIND_RANDOM 
    
    CANT_FOUNDED_RANDOM_POS:
        mov al,0        
             
    FOUNDED_RANDOM_POS:
        mov al,1
                
    RET
CHECK_RANDOM_POS ENDP    

;=======================================================================================================================================
 
MODE PROC
    mov bh,0
    mov dh,4
    mov dl,28
    mov ah,2
    int 10h
    
    lea dx,msg_choose_mode
    mov ah,9
    int 21h
    
    mov dh,6
    mov dl,28
    mov ah,2
    int 10h
    
    lea dx,mode1
    mov ah,9
    int 21h
    
    mov dh,7
    mov dl,28
    mov ah,2
    int 10h 
    
    lea dx,mode2
    mov ah,9
    int 21h
    
    mov dh,9
    mov dl,28
    mov ah,2
    int 10h
    
    lea dx,msg_answer
    mov ah,9
    int 21h
    
    mov ah,1
    int 21h
    sub al,'0' 
           
    RET
MODE ENDP    

;=======================================================================================================================================

X_TURN PROC
    mov dh ,0
    mov dl ,20 
    mov bh,0
    mov ah,2
    int 10h
    lea dx,IN_PLAYER_X
    mov ah,9
    int 21h 
    check_move_for_X:
        lea si,BOARD
        mov ah,1
        int 21h
        sub al,'0' ; vi tri nhap
        mov ah,0 
        add si,ax
        dec si
        mov bl,[si]
        cmp bl,'9'
        jle VALID_POS_FOR_X    
        call INVALID_POS
        jmp check_move_for_X
        
    VALID_POS_FOR_X:
        mov [si],'X'
        mov bl,select_mode
        cmp bl,1  
        je CONTINUE_GAME_VS_HUMAN
        jmp CONTINUE_GAME_VS_COMPUTER      
    RET
X_TURN ENDP    

;=======================================================================================================================================
 
O_TURN PROC
    mov dh ,0
    mov dl ,20 
    mov bh,0
    mov ah,2
    int 10h
    lea dx,IN_PLAYER_O
    mov ah,9
    int 21h
    check_move_for_O:
        lea si,BOARD
        mov ah,1
        int 21h
        sub al,'0' ; vi tri nhap 
        mov ah,0 
        add si,ax
        dec si
        mov bl,[si]
        cmp bl,'9'
        jle VALID_POS_FOR_O
        call INVALID_POS
        jmp check_move_for_O
        
    VALID_POS_FOR_O:
        mov [si],'O'
        jmp CONTINUE_GAME_VS_HUMAN        
    RET
O_TURN ENDP    

;=======================================================================================================================================
 
INVALID_POS PROC  
    call CLEAR_SCREEN
    call PRINT_TABLE
    mov dh ,0
    mov dl ,28 
    mov bh,0
    mov ah,2
    int 10h
    lea dx,INVALID_MOVE
    mov ah,9
    int 21h
    
    RET
INVALID_POS ENDP                                                                                                                   

;=======================================================================================================================================

PRINT_TABLE PROC 
    mov dh,9
    mov dl,35
    mov ah,2
    int 10h
    
    push dx
    lea dx,cot_ngang
    mov ah,9
    int 21h
    pop dx
   
    lea si,BOARD
    ROW:
       inc dh 
       cmp dh,16
       je END_PRINT_TABLE
       mov dl,35
       mov cx,3
       
       mov ah,2
       int 10h 
       
       push dx
       lea dx,cot_doc
       mov ah,9
       int 21h
       pop dx 
       inc dl
       COLUMN:
            push cx
            mov al,[si]
            mov ah,2
            int 10h
            cmp al,'X'
            je PRINT_X
            cmp al,'O'
            je PRINT_O
            jmp DEFAUL
            
            
            PRINT_X:
                mov bh,0
                mov bl,13
                mov ah,9
                mov cx,1
                int 10h
                jmp CONTINUE_LOOP
              
            PRINT_O:      
                mov bh,0
                mov bl,10
                mov ah,9
                mov cx,1
                int 10h
                jmp CONTINUE_LOOP
            
            DEFAUL:
                
                mov bh,0
                mov bl,15
                mov ah,9
                mov cx,1
                int 10h 
            
            
            CONTINUE_LOOP:
            inc dl
            mov ah,2
            int 10h
            push dx
            
            lea dx,cot_doc
            mov ah,9
            int 21h
              
            pop dx
            inc dl 
            inc si 
            pop cx
       loop COLUMN 
       
       mov dl,35
       inc dh
       mov ah,2
       int 10h
       
       push dx
        
       lea dx,cot_ngang
       mov ah,9
       int 21h    
       
       pop dx
       
        
    jmp ROW
           
    END_PRINT_TABLE:
    RET
PRINT_TABLE ENDP                                                                                                                        

;=======================================================================================================================================

CHECK_WIN PROC
    mov cx,3      
    lea si,BOARD
    check_row:
        mov bl,[si] 
        cmp bl,[si+1]
        jne next_row
        cmp bl,[si+2]
        jne next_row
        jmp WIN
        next_row:
            add si,3
            loop check_row 
    mov cx,3
    lea si,BOARD
    check_column:
        mov bl,[si]
        cmp bl,[si+3]
        jne next_column
        cmp bl,[si+6]
        jne next_column
        jmp WIN
        next_column: 
            add si,1
            loop check_column
    lea si,BOARD
    check_cheo1:
        mov bl,[si]
        cmp bl,[si+4]
        jne check_cheo2       
        cmp bl,[si+8]
        jne check_cheo2
        jmp WIN 
    check_cheo2:
        lea si,BOARD
        mov bl,[si+2]
        cmp bl,[si+4]
        jne NO_WIN
        cmp bl,[si+6]
        jne NO_WIN
        jmp WIN
    WIN:
        mov al,bl
        RET     
    NO_WIN:
        mov al,0
    RET
CHECK_WIN ENDP    

;=======================================================================================================================================

CHECK_DRAW PROC
    mov cx,9
    lea si,BOARD
    check_draw_loop:
        mov bl,[si]
        cmp bl,'X'
        je  continue_check_draw_loop
        cmp bl,'O'
        je  continue_check_draw_loop
        jmp IS_NOT_DRAW
        continue_check_draw_loop:
            inc si
            loop check_draw_loop 
    jmp IS_DRAW
    IS_NOT_DRAW:
        mov al,0
        RET
    IS_DRAW:
        mov al,1
    RET
CHECK_DRAW ENDP     

;=======================================================================================================================================

GAME_DRAW PROC
    mov dh ,5
    mov dl ,33
    mov ah,2
    int 10h 
    lea dx,DRAW_OUT
    mov ah,9
    int 21h
    jmp GAME_END
    RET
GAME_DRAW ENDP    

;=======================================================================================================================================
   
X_WIN PROC
    mov dh ,5
    mov dl ,33
    mov ah,2
    int 10h 
    lea dx,X_WIN_OUT
    mov ah,9
    int 21h
    jmp GAME_END            
    RET
X_WIN ENDP

;=======================================================================================================================================   

O_WIN PROC
    mov dh ,5
    mov dl ,33
    mov ah,2
    int 10h  
    lea dx,O_WIN_OUT
    mov ah,9
    int 21h
    jmp GAME_END            
    RET
O_WIN ENDP

;=======================================================================================================================================
 
INTRO PROC
    lea si,WELLCOME
    mov dh,10
    mov dl,20
    
    PRINT_WELLCOME:
        mov al,[si]         ;ki tu can doi mau
        cmp al,'$' 
        je DONE_PRINT_WELLCOME 
        mov ah,2            ;di chuyen con tro de in ki tu
        int 10h
        
        mov ah,9                   
        mov bh,0            ;doi mau ki tu tai trang dang hien thi
        mov bl,15           ;chuyen ki tu sang xanh
        mov cx,1
        int 10h
        
        inc si
        inc dl
        jmp PRINT_WELLCOME
    
    DONE_PRINT_WELLCOME:
    call CLEAR_SCREEN  
    mov dh,4
    mov dl,33
    mov bh,0
    mov ah,2
    int 10h
    lea dx,msg_mem
    mov ah,9
    int 21h    
    mov dh,6
    mov dl,33
    mov bh,0
    mov ah,2
    int 10h
    lea dx,MEM1
    mov ah,9
    int 21h
    mov dh,7
    mov dl,33
    mov bh,0
    mov ah,2
    int 10h
    lea dx,MEM2
    mov ah,9
    int 21h  
    mov dh,8
    mov dl,33
    mov bh,0
    mov ah,2
    int 10h
    lea dx,MEM3
    mov ah,9
    int 21h  
    mov dh,9
    mov dl,33
    mov bh,0
    mov ah,2
    int 10h
    lea dx,MEM4
    mov ah,9
    int 21h
    call DELAY   
    RET
INTRO ENDP   

;=======================================================================================================================================

CLEAR_SCREEN PROC  
    mov ax,3
    int 10h
    RET
CLEAR_SCREEN ENDP

;=======================================================================================================================================

ENDL PROC
    lea dx,crlf
    mov ah,9
    int 21h
    RET
ENDL ENDP

;=======================================================================================================================================

DELAY PROC
    mov cx,0AFh
    delay_screen: 
        nop
        loop delay_screen
    RET
DELAY ENDP    

END
