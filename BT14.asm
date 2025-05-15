.model small
.stack 100h
.data
    crlf db 13,10,'$'
    x dw ?
    y dw ? 
    a dw ?
    b dw ?
    UCLN dw ?
    BCNN dw ?
    tbao1 db 'Nhap so a: $'
    tbao2 db 'Nhap so b: $'
    tbao3 db 'UCLN (a,b): $'
    tbao4 db 'BCNN (a,b): $'
.code 
main proc
    mov ax,@data
    mov ds,ax
    
    lea dx,tbao1
    mov ah,9
    int 21h
    
    call Nhap_so
    
    mov a,ax
    
    call endl
    
    lea dx,tbao2
    mov ah,9
    int 21h
    
    call Nhap_so
    
    mov b,ax
    
    call endl  
    
    lea dx,tbao3
    mov ah,9
    int 21h
    
    call Cal_UCLN
    
    mov ax,UCLN ; dua gia tri can in vao ax de thuan tien cho ham In_so  
    
    call In_so  
    
    call endl
    
    lea dx,tbao4
    mov ah,9
    int 21h
    
    call Cal_BCNN 
    
    mov ax,BCNN ; dua gia tri can in vao ax de thuan tien cho ham In_so
    
    call In_so
    
    mov ax,4ch
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

In_so proc
    mov bx,10
    mov cx,0
    lap3:
        mov dx,0
        div bx
        push dx
        inc cx
        cmp ax,0
        jg lap3
    lap4:
        pop dx
        add dx,'0'
        mov ah,2
        int 21h
        loop lap4        
    ret
In_so endp    

Cal_UCLN proc
    mov ax,a 
    mov bx,b
    lap2:
        cmp bx,0 
        je end2 
        mov dx,0
        div bx
        mov ax,bx
        mov bx,dx
        jmp lap2
    end2:     
    mov UCLN,ax        
    ret
Cal_UCLN endp

Cal_BCNN proc 
    mov ax,a
    mul b
    mov bx,UCLN
    div bx 
    mov BCNN,ax
    ret
Cal_BCNN endp    

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