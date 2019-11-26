.model flat
.686

extern _ExitProcess@4	:PROC
;extern __read			:PROC
extern __write			:PROC
public _print

.data
	text1 db "HELLO FORM TEXT1",0 ; 17 bytes
	size1 = $ - text1
	space db 80 dup(?)
	text2 db "asdfadsgfdgadfa2",1 ; 17 bytes
.code

_print PROC
	push ebp
	mov ebp, esp
	sub esp, 1 ; local variable telling if procent symbol was detected
	sub esp, 10; array of numer symbols
	sub esp,1 ; number symbols count

	push edx
	push ecx
	push esi
	push edi

	; bin to dec conversion
	mov [ebp - 1], byte ptr 0 ; 0- number is bigger or equal 0 ; 1- negative
	mov esi, 9 ; table index
	mov ebx, 10 ; divisor
	mov eax, [ebp + 12]
	bt eax,31
	jnc conv
	;checking if number is negative
	mov [ebp -1],byte ptr 1 
	mov eax, 0FFFFFFFFH
	sub eax,[ebp +12]
	add eax,1
conv:
	mov edx,0
	div ebx

	add dl, 30H
	mov byte ptr [ebp - 11 + esi], dl
	dec esi
	cmp eax, 0
	jne conv

	cmp [ebp -1],byte ptr 0
	je fill
	mov byte ptr[ebp -11+ esi],'-'
	dec esi
fill:
	;transfering string to beginning of table
	mov ebx, 9
	sub ebx, esi
	mov byte ptr [ebp - 12], bl
	inc esi
	lea esi, [ebp - 11 + esi]
	lea edi, [ebp - 11]
	mov ecx,0
	mov cl, byte ptr [ebp - 12]
	cld
	rep movsb

process:
	
	mov ecx, 0 ; ecx is byte counter 
	mov [ebp - 1], byte ptr 0 ; clearing local flag
	mov esi, [ebp + 8] ; esi contains addres to first element of array

next_char:
	mov dl, [esi] ; copy char from array
	inc ecx
	cmp dl, '%'
	jne next
	; dl =='%'
	mov [ebp - 1], byte ptr 1 ; setting up local flag (procent symbol detected
	inc esi
	jmp next_char
next:
	cmp [ebp - 1], byte ptr 1
	jne default_symb
	; flag == 1
	cmp dl,'d'
	jne default_symb
	;dl == 'd'
	mov eax, ecx
	sub eax,2

	;writing text before number
	push ecx
	push eax
	push dword ptr [ebp + 8]
	push dword ptr 1
	call __write
	add esp, 12
	pop ecx

	;writing number
	push ecx
	mov eax,0
	mov al, [ebp - 12]
	push eax
	mov cl, [ebp - 12]
	lea eax,[ebp - 11]
	push eax ; addres to number string
	push dword ptr 1
	call __write
	add esp, 12
	pop ecx
	mov [ebp - 1], cl ; flag consist index+1 of %d 

	inc esi
	jmp next_char

default_symb:
	cmp dl, 0
	je print_str
	inc esi
	jmp next_char

print_str:
	mov esi, [ebp + 8]
	add esi, [ebp - 1]

	cmp [ebp - 1],byte ptr 1
	ja print_cd
	mov esi, [ebp + 8]
	mov [ebp - 1], byte ptr 0
print_cd:
	push ecx
	mov eax, ecx
	sub al, byte ptr[ebp - 1]
	dec eax
	push eax
	push esi
	push dword ptr 1
	call __write
	add esp,12
	pop ecx

	pop edi
	pop esi
	pop ecx
	pop edx

	mov esp, ebp ;deleting local variables
	pop ebp
	ret
_print ENDP
END
