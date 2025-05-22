.model small
.stack 100h
.data 
    BOARD db '123456789$'
    WELLCOME db 'Wellcome to Tic Tac Toe By Group 22!', 13, 10, '$'
    MEM1 db 'NGUYEN HOAI AN   B23DCCN002$'                           ; Gioi thieu 4 thanh vien nhom
    MEM2 db 'NGUYEN MANH KHA  B23DCCN418$'
    MEM3 db 'NGUYEN DUC LONG  B23DCCN502$'
    MEM4 db 'LANG VIET THANH  B23DCCN768$'
    REQ db 'Press Any Key to Play Game!$'
    IN_PLAYER_X db 'Player X turn, Enter position (1-9): $'
    IN_PLAYER_O db 'Player O turn, Enter position (1-9): $'
    INVALID_MOVE db 'Invalid move! Try again : $'
    X_WIN_OUT db 'Player X wins!$'
    O_WIN_OUT db 'Player O wins!$'
    DRAW_OUT db 'Draw!$'
    crlf db 13, 10, '$'
    cnt dw ?
    cot_doc db '|$'
    cot_ngang db '-------$' 
    msg_mem db 'GAME MADE BY:$' 
    msg_choose_mode db 'You want to play with...$'
    mode1 db '1 - HUMAN$'
    mode2 db '2 - COMPUTER$'
    msg_answer db 'Press your answer: $'                           
    MODE2_1 db 'Who goes first?$'                                  ; Ai di truoc trong che do choi voi may?
    MODE2_2 db '1 - YOU $'                                         ; Nguoi choi di truoc
    MODE2_3 db '2 - COMPUTER$'                                     ; May di truoc
    MODE2_4 db 'Enter your choice: $'                              ; Nhap lua chon
    cot dw ?
    hang dw ?
    select_mode db ? 
    HUMAN_WIN db 'HUMAN WIN!$'
    COMPUTER_WIN db 'COMPUTER WIN!$'
    time db 'Computer are thinking next step$'
    waitting db 'Please wait a second...$'
    PLAYER_TURN db 'Player turn, Enter position (1-9): $' 
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
    jmp PLAYER_VS_COMPUTER
    
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
        
    PLAYER_VS_COMPUTER:                 ; Che do Choi voi may
        call CLEAR_SCREEN             ; Xoa man hinh
        
        mov dh,6
        mov dl,28
        mov bx,0
        mov ah,2
        int 10h
        
        mov ah, 9                     ; Goi ham ngat 9 de in Xau
        lea dx, MODE2_1               ; Tro dx toi Thong bao 'Ai di truoc trong che do choi voi may?' 
        int 21h                       ; In xau
        
        mov dh,9
        mov dl,28
        mov bx,0
        mov ah,2
        int 10h                                   
        
        
        lea dx, MODE2_2               ; Tro dx toi 'Nguoi choi di truoc'
        mov ah,9 
        int 21h                       ; In xau
        
        mov dh,11
        mov dl,28
        mov bx,0
        mov ah,2
        int 10h 
        
        lea dx, MODE2_3               ; Tro dx toi 'May di truoc'  
        mov ah,9
        int 21h                       ; In xau  
        
        
        mov dh,13
        mov dl,28
        mov bx,0
        mov ah,2
        int 10h 
                             
        lea dx, MODE2_4               ; Tro dx toi Thong bao 'Nhap lua chon'
        mov ah,9
        int 21h                       ; In xau
         
        mov ah, 1                     ; Goi ham ngat 1 de nhap 1 ki tu 
        int 21h                       ; Nhap ki tu
        
        
        
        cmp al, '2'                   ; So sanh ki tu nhap voi '2'
        
        je PC_FIRST                   ; Neu la '2' thi Nhay toi May di truoc
        jmp GAME_VS_COMPUTER          ; Neu khong thi Bat dau Game voi Nguoi di truoc
        PC_FIRST:                     ; May di truoc
            inc cnt                   ; Tang STT luot choi len 1
            
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
            jmp COMPUTER_TURN
            
            CONTINUE_GAME_VS_COMPUTER:
            inc cnt
            jmp GAME_VS_COMPUTER    
     
    GAME_END:
    mov ah, 4Ch
    int 21h   
        
    
MAIN ENDP

;=======================================================================================================================================

COMPUTER_TURN PROC                    ; Ham luot choi cua May
    mov bx,0
    mov cx,0
     
    mov dh,3
    mov dl,28
    mov ah,2
    int 10h
    
    lea dx,time
    mov ah,9
    int 21h
    
    mov dh,5
    mov dl,28
    mov ah,2
    int 10h
    
    lea dx,waitting
    mov ah,9
    int 21h
    
    call CHANCE_TO_WIN                ; Goi Ham tim nuoc di de WIN
    call CHANCE_TO_BLOCK              ; Goi Ham tim nuoc di de BLOCK
    call CHECK_MIDDLE_POS             ; Goi Ham tim nuoc di O Chinh giua
    call CHECK_CORNER_POS             ; Goi Ham tim nuoc di 4 o goc
    call CHECK_RANDOM_POS             ; Goi Ham tim nuoc di 4 con lai
    
    RET
COMPUTER_TURN ENDP        

;=======================================================================================================================================

ENTER_MOVE PROC
    mov [si], 'O'                     ; Gan o tim duoc = 'O''
    call DELAY                        ; Goi ham Delay
    jmp CONTINUE_GAME_VS_COMPUTER     ; Tiep tuc tro choi
    RET
ENTER_MOVE ENDP       

;=======================================================================================================================================
                                                                         
CHANCE_TO_WIN PROC                    ; Ham tim nuoc di de WIN
; check row================================================= 
    
    mov cx, 3                         ; Khoi tao bien lap duyet 3 hang
    lea si, BOARD                     ; Tro toi ki tu dau tien BOARD
    DUYET_HANG_WIN:                   ; Duyet 1 hang
        mov dh, [si]                  ; Gan DH = ki tu thu 1 cua hang
        mov dl, [si + 1]              ; Gan DL = ki tu thu 2 cua hang
        mov bl, [si + 2]              ; Gan BL = ki tu thu 3 cua hang
        
        cmp dh, 'X'                   ; So sanh ki tu 1 vs Ki tu 'X'
        je TIEP_TUC_DUYET_HANG_WIN    ; Neu la ki tu 'X' thi Duyet hang tiep theo
        cmp dl, 'X'                   ; So sanh ki tu 2 vs Ki tu 'X'
        je TIEP_TUC_DUYET_HANG_WIN    ; Neu la ki tu 'X' thi Duyet hang tiep theo
        cmp bl, 'X'                   ; So sanh ki tu 3 vs Ki tu 'X'
        je TIEP_TUC_DUYET_HANG_WIN    ; Neu la ki tu 'X' thi Duyet hang tiep theo
                                      ; Kiem tra ki tu 1 vs 2
        cmp dh, 'O'                   ; So sanh ki tu 1 vs Ki tu 'O'
        jne skip1                     ; Neu khong giong thi kiem tra ki tu 2 vs 3
        cmp dl, 'O'                   ; So sanh ki tu 2 vs Ki tu 'O'
        jne skip1                     ; Neu khong giong thi kiem tra ki tu 2 vs 3
        add si, 2                     ; Tim duoc nuoc di o ki tu 3
        jmp ENTER_MOVE                ; Nhay toi Tim nuoc di thanh cong
        
        skip1:                        ; Kiem tra ki tu 2 vs 3
            cmp dl, 'O'               ; So sanh ki tu 2 vs Ki tu 'O'
            jne skip2                 ; Neu khong giong thi kiem tra ki tu 1 vs 3
            cmp bl, 'O'               ; So sanh ki tu 3 vs Ki tu 'O'
            jne skip2                 ; Neu khong giong thi kiem tra ki tu 1 vs 3
            add si, 0                 ; Tim duoc nuoc di o ki tu 1
            jmp ENTER_MOVE            ; Nhay toi Tim nuoc di thanh cong
            
        skip2:                        ; Kiem tra ki tu 1 vs 3
            cmp dh, 'O'               ; So sanh ki tu 1 vs Ki tu 'O'
            jne TIEP_TUC_DUYET_HANG_WIN   ; Neu khong giong thi Duyet hang tiep theo
            cmp bl, 'O'               ; So sanh ki tu 3 vs Ki tu 'O'
            jne TIEP_TUC_DUYET_HANG_WIN   ; Neu khong giong thi Duyet hang tiep theo
            add si, 1                 ; Tim duoc nuoc di o ki tu 2
            jmp ENTER_MOVE            ; Nhay toi Tim nuoc di thanh cong
            
        TIEP_TUC_DUYET_HANG_WIN:      ; Tiep tuc duyet hang tiep theo
            add si, 3                 ; Tro toi ki tu dau tien cua hang tiep theo
            loop DUYET_HANG_WIN       ; Tiep tuc lap
    
; check column=================================================
    
    mov cx, 3                         ; Khoi tao bien lap duyet 3 cot
    lea si, BOARD                     ; Tro toi ki tu dau tien BOARD
    DUYET_COT_WIN:                    ; Duyet 1 cot
        mov dh, [si]                  ; Gan DH = ki tu thu 1 cua cot
        mov dl, [si + 3]              ; Gan DL = ki tu thu 2 cua cot
        mov bl, [si + 6]              ; Gan BL = ki tu thu 3 cua cot
        
        cmp dh, 'X'                   ; So sanh ki tu 1 vs Ki tu 'X'
        je TIEP_TUC_DUYET_COT_WIN     ; Neu la ki tu 'X' thi Duyet cot tiep theo
        cmp dl, 'X'                   ; So sanh ki tu 2 vs Ki tu 'X'
        je TIEP_TUC_DUYET_COT_WIN     ; Neu la ki tu 'X' thi Duyet cot tiep theo
        cmp bl, 'X'                   ; So sanh ki tu 3 vs Ki tu 'X'
        je TIEP_TUC_DUYET_COT_WIN     ; Neu la ki tu 'X' thi Duyet cot tiep theo
                                      ; Kiem tra ki tu 1 vs 2
        cmp dh, 'O'                   ; So sanh ki tu 1 vs Ki tu 'O'
        jne skip3                     ; Neu khong giong thi kiem tra ki tu 2 vs 3
        cmp dl, 'O'                   ; So sanh ki tu 2 vs Ki tu 'O'
        jne skip3                     ; Neu khong giong thi kiem tra ki tu 2 vs 3
        add si, 6                     ; Tim duoc nuoc di o ki tu 3
        jmp ENTER_MOVE                ; Nhay toi Tim nuoc di thanh cong
        
        skip3:                        ; Kiem tra ki tu 2 vs 3
            cmp dl, 'O'               ; So sanh ki tu 2 vs Ki tu 'O'
            jne skip4                 ; Neu khong giong thi kiem tra ki tu 1 vs 3
            cmp bl, 'O'               ; So sanh ki tu 3 vs Ki tu 'O'
            jne skip4                 ; Neu khong giong thi kiem tra ki tu 1 vs 3
            add si, 0                 ; Tim duoc nuoc di o ki tu 1
            jmp ENTER_MOVE            ; Nhay toi Tim nuoc di thanh cong
        skip4:                        ; Kiem tra ki tu 1 vs 3
            cmp dh, 'O'               ; So sanh ki tu 1 vs Ki tu 'O'
            jne TIEP_TUC_DUYET_COT_WIN    ; Neu khong giong thi Duyet cot tiep theo
            cmp bl, 'O'               ; So sanh ki tu 3 vs Ki tu 'O'
            jne TIEP_TUC_DUYET_COT_WIN    ; Neu khong giong thi Duyet cot tiep theo
            add si, 3                 ; Tim duoc nuoc di o ki tu 2
            jmp ENTER_MOVE            ; Nhay toi Tim nuoc di thanh cong
            
        TIEP_TUC_DUYET_COT_WIN:       ; Tiep tuc duyet cot tiep theo
            inc si                    ; Tro toi ki tu dau tien cua cot tiep theo
            loop DUYET_COT_WIN        ; Tiep tuc lap    
    
; check duong cheo chinh 
    
    lea si, BOARD                     ; Tro toi ki tu dau tien BOARD
    mov dh, BOARD[0]                  ; Gan DH = ki tu thu 1 cua DCC
    mov dl, BOARD[4]                  ; Gan DL = ki tu thu 2 cua DCC
    mov bl, BOARD[8]                  ; Gan BL = ki tu thu 3 cua DCC
    
    cmp dh, 'X'                       ; So sanh ki tu 1 vs Ki tu 'X'
    je TIEP_TUC_DCP_WIN               ; Neu la ki tu 'X' thi Duyet DCP
    cmp dl, 'X'                       ; So sanh ki tu 1 vs Ki tu 'X'
    je TIEP_TUC_DCP_WIN               ; Neu la ki tu 'X' thi Duyet DCP
    cmp bl, 'X'                       ; So sanh ki tu 1 vs Ki tu 'X'
    je TIEP_TUC_DCP_WIN               ; Neu la ki tu 'X' thi Duyet DCP
    
                                      ; Kiem tra ki tu 1 vs 2
    cmp dh, 'O'                       ; So sanh ki tu 1 vs Ki tu 'O'
    jne skip5                         ; Neu khong giong thi kiem tra ki tu 2 vs 3
    cmp dl, 'O'                       ; So sanh ki tu 2 vs Ki tu 'O'
    jne skip5                         ; Neu khong giong thi kiem tra ki tu 2 vs 3
    add si, 8                         ; Tim duoc nuoc di o ki tu 3
    jmp ENTER_MOVE                    ; Nhay toi Tim nuoc di thanh cong
        
    skip5:                            ; Kiem tra ki tu 2 vs 3
        cmp dl, 'O'                   ; So sanh ki tu 2 vs Ki tu 'O'
        jne skip6                     ; Neu khong giong thi kiem tra ki tu 1 vs 3
        cmp bl, 'O'                   ; So sanh ki tu 3 vs Ki tu 'O'
        jne skip6                     ; Neu khong giong thi kiem tra ki tu 1 vs 3
        add si, 0                     ; Tim duoc nuoc di o ki tu 1
        jmp ENTER_MOVE                ; Nhay toi Tim nuoc di thanh cong
        
    skip6:                            ; Kiem tra ki tu 1 vs 3
        cmp dh, 'O'                   ; So sanh ki tu 1 vs Ki tu 'O'
        jne TIEP_TUC_DCP_WIN          ; Neu khong giong thi Duyet DCP
        cmp bl, 'O'                   ; So sanh ki tu 3 vs Ki tu 'O'
        jne TIEP_TUC_DCP_WIN          ; Neu khong giong thi Duyet DCP
        add si, 4                     ; Tim duoc nuoc di o ki tu 2
        jmp ENTER_MOVE                ; Nhay toi Tim nuoc di thanh cong
    
; Check duong cheo phu

    TIEP_TUC_DCP_WIN:                 ; Kiem tra duong cheo phu
        mov dh, BOARD[2]              ; Gan DH = ki tu thu 1 cua DCP
        mov dl, BOARD[4]              ; Gan DL = ki tu thu 2 cua DCP
        mov bl, BOARD[6]              ; Gan BL = ki tu thu 3 cua DCP
                                      
        cmp dh, 'X'                   ; So sanh ki tu 1 vs Ki tu 'X'
        je XONG_8_DUONG_WIN           ; Neu la ki tu 'X' thi Ket thuc duyet 8 duong
        cmp dl, 'X'                   ; So sanh ki tu 1 vs Ki tu 'X'
        je XONG_8_DUONG_WIN           ; Neu la ki tu 'X' thi Ket thuc duyet 8 duong
        cmp bl, 'X'                   ; So sanh ki tu 1 vs Ki tu 'X'
        je XONG_8_DUONG_WIN           ; Neu la ki tu 'X' thi Ket thuc duyet 8 duong
                                      ; Kiem tra ki tu 1 vs 2
        cmp dh, 'O'                   ; So sanh ki tu 1 vs Ki tu 'O'
        jne skip7                     ; Neu khong giong thi kiem tra ki tu 2 vs 3
        cmp dl, 'O'                   ; So sanh ki tu 2 vs Ki tu 'O'
        jne skip7                     ; Neu khong giong thi kiem tra ki tu 2 vs 3
        add si, 6                     ; Tim duoc nuoc di o ki tu 3
        jmp ENTER_MOVE                ; Nhay toi Tim nuoc di thanh con
            
        skip7:                        ; Kiem tra ki tu 2 vs 3
            cmp dl, 'O'               ; So sanh ki tu 2 vs Ki tu 'O'
            jne skip8                 ; Neu khong giong thi kiem tra ki tu 1 vs 3
            cmp bl, 'O'               ; So sanh ki tu 3 vs Ki tu 'O'
            jne skip8                 ; Neu khong giong thi kiem tra ki tu 1 vs 3
            add si, 2                 ; Tim duoc nuoc di o ki tu 1
            jmp ENTER_MOVE            ; Nhay toi Tim nuoc di thanh cong
            
        skip8:                        ; Kiem tra ki tu 1 vs 3
            cmp dh, 'O'               ; So sanh ki tu 1 vs Ki tu 'O'
            jne XONG_8_DUONG_WIN      ; Neu khong giong thi Ket thuc duyet 8 duong
            cmp bl, 'O'               ; So sanh ki tu 3 vs Ki tu 'O'
            jne XONG_8_DUONG_WIN      ; Neu khong giong thi Ket thuc duyet 8 duong
            add si, 4                 ; Tim duoc nuoc di o ki tu 2
            jmp ENTER_MOVE            ; Nhay toi Tim nuoc di thanh cong
        
    XONG_8_DUONG_WIN:                 ; Duyet xong 8 duong
    RET
CHANCE_TO_WIN ENDP                                                                            

;=======================================================================================================================================

CHANCE_TO_BLOCK PROC                  ; Goi Ham tim nuoc di de BLOCK
; check row================================================= 
    
    mov cx, 3                         ; Khoi tao bien lap duyet 3 hang
    lea si, BOARD                     ; Tro toi ki tu dau tien BOARD
    DUYET_HANG_BLOCK:                 ; Duyet 1 hang
        mov dh, [si]                  ; Gan DH = ki tu thu 1 cua hang
        mov dl, [si + 1]              ; Gan DL = ki tu thu 2 cua hang
        mov bl, [si + 2]              ; Gan BL = ki tu thu 3 cua hang
        
        cmp dh, 'O'                   ; So sanh ki tu 1 vs Ki tu 'O'
        je TIEP_TUC_DUYET_HANG_BLOCK  ; Neu la ki tu 'O' thi Duyet hang tiep theo
        cmp dl, 'O'                   ; So sanh ki tu 2 vs Ki tu 'O'
        je TIEP_TUC_DUYET_HANG_BLOCK  ; Neu la ki tu 'O' thi Duyet hang tiep theo
        cmp bl, 'O'                   ; So sanh ki tu 3 vs Ki tu 'O'
        je TIEP_TUC_DUYET_HANG_BLOCK  ; Neu la ki tu 'O' thi Duyet hang tiep theo
                                      ; Kiem tra ki tu 1 vs 2
        cmp dh, 'X'                   ; So sanh ki tu 1 vs Ki tu 'X'
        jne skip9                     ; Neu khong giong thi kiem tra ki tu 2 vs 3
        cmp dl, 'X'                   ; So sanh ki tu 2 vs Ki tu 'X'
        jne skip9                     ; Neu khong giong thi kiem tra ki tu 2 vs 3
        add si, 2                     ; Tim duoc nuoc di o ki tu 3
        jmp ENTER_MOVE                ; Nhay toi Tim nuoc di thanh cong
        
        skip9:                        ; Kiem tra ki tu 2 vs 3
            cmp dl, 'X'               ; So sanh ki tu 2 vs Ki tu 'X'
            jne skip10                ; Neu khong giong thi kiem tra ki tu 1 vs 3
            cmp bl, 'X'               ; So sanh ki tu 3 vs Ki tu 'X'
            jne skip10                ; Neu khong giong thi kiem tra ki tu 1 vs 3
            add si, 0                 ; Tim duoc nuoc di o ki tu 1
            jmp ENTER_MOVE            ; Nhay toi Tim nuoc di thanh cong
            
        skip10:                       ; Kiem tra ki tu 1 vs 3
            cmp dh, 'X'               ; So sanh ki tu 1 vs Ki tu 'X'
            jne TIEP_TUC_DUYET_HANG_BLOCK   ; Neu khong giong thi Duyet hang tiep theo
            cmp bl, 'X'               ; So sanh ki tu 3 vs Ki tu 'X'
            jne TIEP_TUC_DUYET_HANG_BLOCK   ; Neu khong giong thi Duyet hang tiep theo
            add si, 1                 ; Tim duoc nuoc di o ki tu 2
            jmp ENTER_MOVE            ; Nhay toi Tim nuoc di thanh cong
            
        TIEP_TUC_DUYET_HANG_BLOCK:    ; Tiep tuc duyet hang tiep theo
            add si, 3                 ; Tro toi ki tu dau tien cua hang tiep theo
            loop DUYET_HANG_BLOCK     ; Tiep tuc lap
    
; check column=================================================
    
    mov cx, 3                         ; Khoi tao bien lap duyet 3 cot
    lea si, BOARD                     ; Tro toi ki tu dau tien BOARD
    DUYET_COT_BLOCK:                  ; Duyet 1 cot
        mov dh, [si]                  ; Gan DH = ki tu thu 1 cua cot
        mov dl, [si + 3]              ; Gan DL = ki tu thu 2 cua cot
        mov bl, [si + 6]              ; Gan BL = ki tu thu 3 cua cot
        
        cmp dh, 'O'                   ; So sanh ki tu 1 vs Ki tu 'O'
        je TIEP_TUC_DUYET_COT_BLOCK   ; Neu la ki tu 'O' thi Duyet cot tiep theo
        cmp dl, 'O'                   ; So sanh ki tu 2 vs Ki tu 'O'
        je TIEP_TUC_DUYET_COT_BLOCK   ; Neu la ki tu 'O' thi Duyet cot tiep theo
        cmp bl, 'O'                   ; So sanh ki tu 3 vs Ki tu 'O'
        je TIEP_TUC_DUYET_COT_BLOCK   ; Neu la ki tu 'O' thi Duyet cot tiep theo
                                      ; Kiem tra ki tu 1 vs 2
        cmp dh, 'X'                   ; So sanh ki tu 1 vs Ki tu 'X'
        jne skip11                    ; Neu khong giong thi kiem tra ki tu 2 vs 3
        cmp dl, 'X'                   ; So sanh ki tu 2 vs Ki tu 'X'
        jne skip11                    ; Neu khong giong thi kiem tra ki tu 2 vs 3
        add si, 6                     ; Tim duoc nuoc di o ki tu 3
        jmp ENTER_MOVE                ; Nhay toi Tim nuoc di thanh cong
        
        skip11:                       ; Kiem tra ki tu 2 vs 3
            cmp dl, 'X'               ; So sanh ki tu 2 vs Ki tu 'X'
            jne skip12                ; Neu khong giong thi kiem tra ki tu 1 vs 3
            cmp bl, 'X'               ; So sanh ki tu 3 vs Ki tu 'X'
            jne skip12                ; Neu khong giong thi kiem tra ki tu 1 vs 3
            add si, 0                 ; Tim duoc nuoc di o ki tu 1
            jmp ENTER_MOVE            ; Nhay toi Tim nuoc di thanh cong
        skip12:                       ; Kiem tra ki tu 1 vs 3
            cmp dh, 'X'               ; So sanh ki tu 1 vs Ki tu 'X'
            jne TIEP_TUC_DUYET_COT_BLOCK    ; Neu khong giong thi Duyet cot tiep theo
            cmp bl, 'X'               ; So sanh ki tu 3 vs Ki tu 'X'
            jne TIEP_TUC_DUYET_COT_BLOCK    ; Neu khong giong thi Duyet cot tiep theo
            add si, 3                 ; Tim duoc nuoc di o ki tu 2
            jmp ENTER_MOVE            ; Nhay toi Tim nuoc di thanh cong
            
        TIEP_TUC_DUYET_COT_BLOCK:     ; Tiep tuc duyet cot tiep theo
            inc si                    ; Tro toi ki tu dau tien cua cot tiep theo
            loop DUYET_COT_BLOCK      ; Tiep tuc lap    
    
; check duong cheo chinh 
    
    lea si, BOARD                     ; Tro toi ki tu dau tien BOARD
    mov dh, BOARD[0]                  ; Gan DH = ki tu thu 1 cua DCC
    mov dl, BOARD[4]                  ; Gan DL = ki tu thu 2 cua DCC
    mov bl, BOARD[8]                  ; Gan BL = ki tu thu 3 cua DCC
    
    cmp dh, 'O'                       ; So sanh ki tu 1 vs Ki tu 'O'
    je TIEP_TUC_DCP_BLOCK             ; Neu la ki tu 'O'thi Duyet DCP
    cmp dl, 'O'                       ; So sanh ki tu 1 vs Ki tu 'O'
    je TIEP_TUC_DCP_BLOCK             ; Neu la ki tu 'O' thi Duyet DCP
    cmp bl, 'O'                       ; So sanh ki tu 1 vs Ki tu 'O'
    je TIEP_TUC_DCP_BLOCK             ; Neu la ki tu 'O' thi Duyet DCP
    
                                      ; Kiem tra ki tu 1 vs 2
    cmp dh, 'X'                       ; So sanh ki tu 1 vs Ki tu 'X'
    jne skip13                        ; Neu khong giong thi kiem tra ki tu 2 vs 3
    cmp dl, 'X'                       ; So sanh ki tu 2 vs Ki tu 'X'
    jne skip13                        ; Neu khong giong thi kiem tra ki tu 2 vs 3
    add si, 8                         ; Tim duoc nuoc di o ki tu 3
    jmp ENTER_MOVE                    ; Nhay toi Tim nuoc di thanh cong
        
    skip13:                           ; Kiem tra ki tu 2 vs 3
        cmp dl, 'X'                   ; So sanh ki tu 2 vs Ki tu 'X'
        jne skip14                    ; Neu khong giong thi kiem tra ki tu 1 vs 3
        cmp bl, 'X'                   ; So sanh ki tu 3 vs Ki tu 'X'
        jne skip14                    ; Neu khong giong thi kiem tra ki tu 1 vs 3
        add si, 0                     ; Tim duoc nuoc di o ki tu 1
        jmp ENTER_MOVE                ; Nhay toi Tim nuoc di thanh cong
        
    skip14:                           ; Kiem tra ki tu 1 vs 3
        cmp dh, 'X'                   ; So sanh ki tu 1 vs Ki tu 'X'
        jne TIEP_TUC_DCP_BLOCK        ; Neu khong giong thi Duyet DCP
        cmp bl, 'X'                   ; So sanh ki tu 3 vs Ki tu 'X'
        jne TIEP_TUC_DCP_BLOCK        ; Neu khong giong thi Duyet DCP
        add si, 4                     ; Tim duoc nuoc di o ki tu 2
        jmp ENTER_MOVE                ; Nhay toi Tim nuoc di thanh cong
    
; Check duong cheo phu

    TIEP_TUC_DCP_BLOCK:               ; Kiem tra duong cheo phu
        mov dh, BOARD[2]              ; Gan DH = ki tu thu 1 cua DCP
        mov dl, BOARD[4]              ; Gan DL = ki tu thu 2 cua DCP
        mov bl, BOARD[6]              ; Gan BL = ki tu thu 3 cua DCP
                                      
        cmp dh, 'O'                   ; So sanh ki tu 1 vs Ki tu 'O' 
        je XONG_8_DUONG_BLOCK         ; Neu la ki tu 'O' thi Ket thuc duyet 8 duong
        cmp dl, 'O'                   ; So sanh ki tu 1 vs Ki tu 'O'
        je XONG_8_DUONG_BLOCK         ; Neu la ki tu 'O' thi Ket thuc duyet 8 duong
        cmp bl, 'O'                   ; So sanh ki tu 1 vs Ki tu 'O'
        je XONG_8_DUONG_BLOCK         ; Neu la ki tu 'O' thi Ket thuc duyet 8 duong
                                      ; Kiem tra ki tu 1 vs 2
        cmp dh, 'X'                   ; So sanh ki tu 1 vs Ki tu 'X'
        jne skip15                    ; Neu khong giong thi kiem tra ki tu 2 vs 3
        cmp dl, 'X'                   ; So sanh ki tu 2 vs Ki tu 'X'
        jne skip15                    ; Neu khong giong thi kiem tra ki tu 2 vs 3
        add si, 6                     ; Tim duoc nuoc di o ki tu 3
        jmp ENTER_MOVE                ; Nhay toi Tim nuoc di thanh con
            
        skip15:                       ; Kiem tra ki tu 2 vs 3
            cmp dl, 'X'               ; So sanh ki tu 2 vs Ki tu 'X'
            jne skip16                ; Neu khong giong thi kiem tra ki tu 1 vs 3
            cmp bl, 'X'               ; So sanh ki tu 3 vs Ki tu 'X'
            jne skip16                ; Neu khong giong thi kiem tra ki tu 1 vs 3
            add si, 2                 ; Tim duoc nuoc di o ki tu 1
            jmp ENTER_MOVE            ; Nhay toi Tim nuoc di thanh cong
            
        skip16:                       ; Kiem tra ki tu 1 vs 3
            cmp dh, 'X'               ; So sanh ki tu 1 vs Ki tu 'X'
            jne XONG_8_DUONG_BLOCK    ; Neu khong giong thi Ket thuc duyet 8 duong
            cmp bl, 'X'               ; So sanh ki tu 3 vs Ki tu 'X'
            jne XONG_8_DUONG_BLOCK    ; Neu khong giong thi Ket thuc duyet 8 duong
            add si, 4                 ; Tim duoc nuoc di o ki tu 2
            jmp ENTER_MOVE            ; Nhay toi Tim nuoc di thanh cong
        
    XONG_8_DUONG_BLOCK:               ; Duyet xong 8 duong
    RET
CHANCE_TO_BLOCK ENDP 

;=======================================================================================================================================

CHECK_MIDDLE_POS PROC                 ; Ham tim nuoc di O Chinh giua
    lea si, BOARD                     ; Tro toi o dau tien cua BOARD 
    cmp BOARD[4], 'X'                 ; So sanh o giua voi 'X'
    je CANT_INSERT_MIDDLE             ; Neu la 'X' thi khong the chen vao giua
    cmp BOARD[4], 'O'                 ; So sanh o giua voi 'O'
    je CANT_INSERT_MIDDLE             ; Neu la 'O' thi khong the chen vao giua
    add si, 4                         ; Tim duoc nuoc di o Chinh giua
    jmp ENTER_MOVE                    ; Nhay toi Tim nuoc di thanh cong  
    
    CANT_INSERT_MIDDLE: 
    
    RET
CHECK_MIDDLE_POS ENDP        

;=======================================================================================================================================
 
CHECK_CORNER_POS PROC                 ; Ham tim nuoc di 4 o goc
    lea si, BOARD                     ; Tro toi o dau tien cua BOARD
    GOC0:                             ; Kiem tra [0][0]
        
        cmp BOARD[0], 'X'             ; So sanh [0][0] voi 'X'
        je GOC2                       ; Neu la 'X' thi nhay toi tim o [0][2]
        cmp BOARD[0], 'O'             ; So sanh [0][0] voi 'O'
        je GOC2                       ; Neu la 'X' thi nhay toi tim o [0][2]
                                      ; Tim duoc nuoc di o [0][0]
        jmp ENTER_MOVE                ; Nhay toi Tim nuoc di thanh cong
        
        GOC2:                         ; Kiem tra [0][2]
            cmp BOARD[2], 'X'         ; So sanh [0][2] voi 'X'
            je GOC6                   ; Neu la 'X' thi nhay toi tim o [2][0]
            cmp BOARD[2], 'O'         ; So sanh [0][2] voi 'O'
            je GOC6                   ; Neu la 'O' thi nhay toi tim o [2][0]
            add si, 2                 ; Tim duoc nuoc di o [0][2]
            jmp ENTER_MOVE            ; Nhay toi Tim nuoc di thanh cong
        
        GOC6:                         ; Kiem tra [2][0]
            cmp BOARD[6], 'X'         ; So sanh [2][0] voi 'X'
            je GOC8                   ; Neu la 'X' thi nhay toi tim o [2][2]
            cmp BOARD[6], 'O'         ; So sanh [2][0] voi 'O'
            je GOC8                   ; Neu la 'O' thi nhay toi tim o [2][2]
            add si, 6                 ; Tim duoc nuoc di o [2][0]
            jmp ENTER_MOVE            ; Nhay toi Tim nuoc di thanh cong
        
        GOC8:                         ; Kiem tra [2][2]
            cmp BOARD[8], 'X'         ; So sanh [2][2] voi 'X'
            je FOUNDED_CORNER_POS     ; Neu la 'X' thi nhay toi Khong tim duoc o goc
            cmp BOARD[8], 'O'         ; So sanh [2][2] voi 'O'
            je FOUNDED_CORNER_POS     ; Neu la 'O' thi nhay toi Khong tim duoc o goc
            add si, 8                 ; Tim duoc nuoc di o [2][2]
            jmp ENTER_MOVE            ; Nhay toi Tim nuoc di thanh cong
    
    FOUNDED_CORNER_POS:
    RET
CHECK_CORNER_POS ENDP    

;=======================================================================================================================================

CHECK_RANDOM_POS PROC                 ; Ham tim nuoc di 4 con lai
    lea si, BOARD                     ; Tro toi o dau tien cua BOARD
    O1:                               ; Kiem tra [0][1]
        cmp BOARD[1], 'X'             ; So sanh [0][1] voi 'X'
        je O3                         ; Neu la 'X' thi nhay toi tim o [1][0]
        cmp BOARD[1], 'O'             ; So sanh [0][1] voi 'O'
        je O3                         ; Neu la 'O' thi nhay toi tim o [1][0]
        add si, 1                     ; Tim duoc nuoc di o [0][1]
        jmp ENTER_MOVE                ; Nhay toi Tim nuoc di thanh cong
        
        O3:                           ; Kiem tra [1][0]
            cmp BOARD[3], 'X'         ; So sanh [1][0] voi 'X'
            je O5                     ; Neu la 'X' thi nhay toi tim o [1][2]
            cmp BOARD[3], 'O'         ; So sanh [1][0] voi 'O'
            je O5                     ; Neu la 'O' thi nhay toi tim o [1][2]
            add si, 3                 ; Tim duoc nuoc di o [1][0]
            jmp ENTER_MOVE            ; Nhay toi Tim nuoc di thanh cong
        
        O5:                           ; Kiem tra [1][2]
            cmp BOARD[5], 'X'         ; So sanh [1][2] voi 'X'
            je O7                     ; Neu la 'X' thi nhay toi tim o [2][1]
            cmp BOARD[5], 'O'         ; So sanh [1][2] voi 'O'
            je O7                     ; Neu la 'O' thi nhay toi tim o [2][1]
            add si, 5                 ; Tim duoc nuoc di o [1][2]
            jmp ENTER_MOVE            ; Nhay toi Tim nuoc di thanh cong
        
        O7:                           ; Kiem tra [2][1]
            add si, 7                 ; Tim duoc nuoc di o [1][2] (Do chac chan tim duoc nuoc di ma [2][1] la o cuoi cung)
            jmp ENTER_MOVE            ; Nhay toi Tim nuoc di thanh cong
                
    RET
CHECK_RANDOM_POS ENDP    

;=======================================================================================================================================
 
MODE PROC
    mov bh,0
    mov dh,6
    mov dl,28
    mov ah,2
    int 10h
    
    lea dx,msg_choose_mode
    mov ah,9
    int 21h
    
    mov dh,9
    mov dl,28
    mov ah,2
    int 10h
    
    lea dx,mode1
    mov ah,9
    int 21h
    
    mov dh,11
    mov dl,28
    mov ah,2
    int 10h 
    
    lea dx,mode2
    mov ah,9
    int 21h
    
    mov dh,13
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
    mov dl,select_mode
    cmp dl,2
    je HUMAN_TURN
    
    mov dh ,5
    mov dl ,20 
    mov bh,0
    mov ah,2
    int 10h
    lea dx,IN_PLAYER_X
    mov ah,9
    int 21h
    jmp check_move_for_X 
    
    HUMAN_TURN: 
    mov dh ,5
    mov dl ,22 
    mov bh,0
    mov ah,2
    int 10h
    lea dx,PLAYER_TURN
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
    mov dh ,5
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
    mov dl ,36
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
    mov dl ,31
    mov ah,2
    int 10h
    
    mov al,select_mode
    cmp al,2
    je msg_for_human 
    lea dx,X_WIN_OUT
    mov ah,9
    int 21h
    jmp GAME_END
    
    msg_for_human:
    lea dx,HUMAN_WIN
    mov ah,9
    int 21h
    jmp GAME_END            
    RET
X_WIN ENDP

;=======================================================================================================================================   

O_WIN PROC
    mov dh ,5
    mov dl ,32
    mov ah,2
    int 10h
      
    mov al,select_mode
    cmp al,2
    je msg_for_computer
     
    lea dx,O_WIN_OUT
    mov ah,9
    int 21h
    jmp GAME_END
    
    msg_for_computer:
    lea dx,COMPUTER_WIN
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
    mov dh,6
    mov dl,33
    mov bh,0
    mov ah,2
    int 10h
    lea dx,msg_mem
    mov ah,9
    int 21h 
       
    mov dh,9
    mov dl,27
    mov bh,0
    mov ah,2
    int 10h 
    lea dx,MEM1
    mov ah,9
    int 21h
    
    mov dh,11
    mov dl,27
    mov bh,0
    mov ah,2
    int 10h
    lea dx,MEM2
    mov ah,9
    int 21h
      
    mov dh,13
    mov dl,27
    mov bh,0
    mov ah,2
    int 10h
    lea dx,MEM3
    mov ah,9
    int 21h
      
    mov dh,15
    mov dl,27
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
    mov cx,08Fh
    delay_screen: 
        nop
        loop delay_screen
    RET
DELAY ENDP    

END
