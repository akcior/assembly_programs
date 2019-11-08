.686
.model flat

extern __read			:PROC
extern __write			:PROC
extern _ExitProcess@4	:PROC
public _main

.data
	value1			dd ?
	value2			dd ?
	result			dd ?
	present_operator	db ?
	last_operator		db ? ;1 - dodac, 0 - odjac
	input			db 80 dup(?)
	operator_count	db 0
	dziesiec		dd 10 ; mnoznik
	end_of_inp		db 0 ;0 -false
	znaki			db 11 dup(20H),0 ; output
	ujemna			db 0 ; false
.code
calculate_value PROC	
	pusha

	;wczytanie tekstu
	push dword ptr 80
	push OFFSET input
	push 0
	call __read
	add esp,12

	mov eax, 0
	mov ebx, OFFSET input

read_char:
	mov cl, [ebx]
	inc ebx

	cmp cl,10 ; enter
	je enter_occur

	cmp cl, '0'
	jb check_operator

	sub cl,30H
	movzx ecx,cl

	mul dword ptr dziesiec
	add eax,ecx
	jmp read_char

enter_occur:
	mov dl,present_operator
	mov last_operator, dl
	mov end_of_inp, 1
	jmp operator_exe

check_operator:
	mov dl,present_operator
	mov last_operator, dl
	cmp cl,'-'
	je minus
	mov present_operator, 1 ; dodac
	inc operator_count
	jmp operator_next
minus:
	mov present_operator,0 ; odjac
	inc operator_count
	jmp operator_next

operator_next:
	cmp operator_count,1
	ja operator_exe

	mov value1, eax
	mov eax, 0
	jmp read_char

operator_exe:
	mov value2, eax
	mov eax,0
	cmp last_operator, 0 ; odejmowanie
	je minus_exe
	;dodawanie
	mov edx,value2
	add value1, edx
	cmp end_of_inp, 1
	je read_end
	jmp read_char
minus_exe:
	;odejmowanie
	mov edx,value2
	sub value1, edx
	cmp end_of_inp, 1
	je read_end
	jmp read_char





read_end:

	popa
	ret
calculate_value ENDP



_main PROC

	call calculate_value
	mov eax,value1

	bt eax, 31
	jnc dodatnia
	;ujemna
	mov edx, 0FFFFFFFFH
	sub edx, eax
	mov eax, edx
	inc eax
	mov ujemna,1


dodatnia:
	mov esi ,10 ; index
	mov ebx,10
conv_dod:
	mov edx,0
	div ebx
	add dl,30H
	mov znaki[esi],dl
	dec esi
	cmp eax, 0
	jne conv_dod

	cmp ujemna, 0
	je wypisz
	mov znaki[esi],'-'


wypisz:
	push 12
	push OFFSET znaki
	push dword ptr 1
	call __write
	push 0
	call _ExitProcess@4

_main ENDP

END