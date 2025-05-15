.model small
.stack 100h
.data
    crlf db 13,10,'$'
    x dw ?
    y dw ?
    tb1 db 'Dang thap phan: ','$'
    tb2 db 'Dang thap luc phan: ','$'
.code

main proc
    mov ax,@data
    mov ds,ax
    
    lea dx,tb1
    mov ah,9
    int 21h
    
    call Nhap_so
    
    call endl
    
    push ax; day ax vao stack de ax khong bi thay doi khi in tb2
    
    lea dx,tb2
    mov ah,9
    int 21h  
    
    pop ax
    
    call Dec_to_Hex 
  
    mov ah,4ch
    int 21h
main endp 

Nhap_so proc
    mov bx,10
    mov x,0; 'x' dung de luu day so truoc do
    mov y,0; 'y' dung de luu so vua nhap
    lap1:
        mov ah,1
        int 21h
        cmp al,13; kiem tra neu la Enter thi ket thuc nhap
        je end1
        mov ah,0; chuyen ah bang 0 de tranh sai du lieu
        sub ax,'0'; chuyen ki tu nhap vao thanh so 
        mov y,ax
        mov ax,x
        mul bx
        add ax,y
        mov x,ax; luu day duoc them so moi
        jmp lap1
    end1: 
    mov ax,x        
    ret
Nhap_so endp    

Dec_to_Hex proc
    mov bx,16
    mov cx,0
    lap2:
        mov dx,0
        div bx
        push dx
        inc cx
        cmp ax,0
        jg lap2
    lap3:
        pop dx 
        cmp dx,10
        jl print
        sub dx,10
        add dx,'A'
        sub dx,'0'
        print:
        add dx,'0'
        mov ah,2
        int 21h
        loop lap3    
    ret
Dec_to_Hex endp    

; xuong dong
endl proc
    push ax
    push dx
    lea dx,crlf
    mov ah,9    
    int 21h
    pop dx
    pop ax    
    ret
endl endp    
            
end 
