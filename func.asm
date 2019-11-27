.686
.model flat


public _join

.data

.code

_join PROC
	push ebp
	mov ebp, esp

	push esi
	push edi
	
	mov esi,[ebp + 12]; esi zawiera adres listy
	mov ecx, [ebp + 16] ; ecx zawiera liczbe el listy
	mov edi, [ebp + 20] ; edi zawiera adres pierwszego el buf
	mov edx,0 ; ecx jest iteratorem listy
	mov eax,0
	

read_table:
	
	push esi
	mov esi, [esi] ; esi wskazuje teraz na pierwszy el tabl
write_char:
	mov al,[esi]
	mov [edi],al
	inc edi
	inc esi
	cmp[esi], byte ptr 0
	jne write_char

	pop esi
	cmp ecx,1
	je write_end

	add esi, 4;inc esi
	;wpisanie seperatora
	push esi
	mov esi, [ebp + 8] ; esi wskazuje na pierwszy el sep
write_sep:
	cmp[esi],byte ptr 0
	je sep_end
	mov al, [esi]
	mov [edi],al
	inc edi
	inc esi
	jmp write_sep
sep_end:
	pop esi
	loop read_table

write_end:
	mov eax, [ebp + 20]


	pop edi
	pop esi

	mov esp, ebp
	pop ebp
	ret
_join ENDP
END
