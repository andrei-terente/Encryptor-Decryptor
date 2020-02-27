;Nume, Prenume: TERENTE ANDREI-ALEXANDRU
;Grupa: 325 CA

extern puts
extern printf
extern strlen

%define BAD_ARG_EXIT_CODE -1

section .data
filename: db "./input0.dat", 0
inputlen: dd 2263

fmtstr:            db "Key: %d",0xa, 0
usage:             db "Usage: %s <task-no> (task-no can be 1,2,3,4,5,6)", 10, 0
error_no_file:     db "Error: No input file %s", 10, 0
error_cannot_read: db "Error: Cannot read input file %s", 10, 0

section .text
global main

xor_strings:
	; TODO TASK 1
        ; string
        push ebp
        mov ebp, esp
        mov ecx, [ebp + 8]
        ; key
        mov edx, [ebp + 12]
        xor esi, esi
        
xor_one_char:
             
        cmp byte [ecx + esi], 0
        je exit_xor_strings
        
        ; encoded_string character
        mov bl, byte [ecx + esi]
        ; key character
        mov al, byte [edx + esi]
        ; decoding current character
        xor bl, al
        ; replacing encoded character with decoded one in the input string
        mov byte [ecx + esi], bl
        inc esi
        
        jmp xor_one_char
        
        
exit_xor_strings:       
        leave
	ret

rolling_xor:
	; TODO TASK 2
        push ebp
        mov ebp, esp
        
        mov ecx, [ebp + 8]
        
        xor esi, esi
        ; bl = c[1]
        mov bl, byte [ecx + esi]
        inc esi
decode_character:

        cmp byte [ecx + esi], 0
        je exit_rolling_xor
        
        ; al = c[i]
        mov al, byte [ecx + esi]
        ; c[i] = c[i] xor c[i - 1]
        xor byte [ecx + esi], bl
        ; bl = c[i], needed for decoding next char
        mov bl, al
        inc esi
        jmp decode_character
                
exit_rolling_xor:        
        leave
	ret

xor_hex_strings:
	; TODO TASK 3
	ret

base32decode:
	; TODO TASK 4
	ret

bruteforce_singlebyte_xor:
	; TODO TASK 5
        push ebp
        mov ebp, esp
        
        mov ecx, [ebp + 8]
        xor eax, eax
        
decode_using_current_key:
        ; will start bruteforcing with key = 0
        xor esi, esi

decode_one_char:
        ; decodes one character of the input string
        ; if \0 is reached, check if the decoded message contains "force"
        cmp byte [ecx + esi], 0
        je check_if_correct
        
        ; bl = current decoded char
        mov bl, byte [ecx + esi]
        xor bl, al
        
        ; check if the current char can be included in a sentence
        ; (is a letter, number or punctuation symbol)
        ; if it isn't, try next key since the current one is wrong
        cmp bl, 32
        jl try_next_key
        cmp bl, 122
        jg try_next_key
        
        inc esi
        jmp decode_one_char
        
check_if_correct:
        xor esi, esi

check_for_force:
        ; check if the word "force" appears in the sentence
        ; if it does, the correct key was found -> decode the message and return the key
        ; if it doesn't, try next key
        inc esi
        cmp byte [ecx + esi], 0
        je try_next_key
        
        mov bl, byte [ecx + esi]
        xor bl, al
        
        cmp bl, 'f'
        jne check_for_force
        
        mov bl, byte [ecx + esi + 1]
        xor bl, al
        
        cmp bl, 'o'
        jne check_for_force
        
        mov bl, byte [ecx + esi + 2]
        xor bl, al
        
        cmp bl, 'r'
        jne check_for_force
        
        mov bl, byte [ecx + esi + 3]
        xor bl, al
        
        cmp bl, 'c'
        jne check_for_force
        
        mov bl, byte [ecx + esi + 4]
        xor bl, al
        
        cmp bl, 'e'
        jne check_for_force

        jmp correct_key_found
        
correct_key_found:
        ; correct key was found, decode the string 
        xor esi, esi
        jmp decode_using_correct_key
        
try_next_key:
        ; next_key = current_key + 1
        inc eax
        xor esi, esi
        jmp decode_using_current_key        
        
decode_using_correct_key:
        cmp byte [ecx + esi], 0
        je exit_bruteforce
        
        xor byte [ecx + esi], byte al
        inc esi
        jmp decode_using_correct_key

exit_bruteforce:
        
        leave
	ret

decode_vigenere:
	; TODO TASK 6
        push ebp
        mov ebp, esp
        
        mov ecx, [ebp + 8]
        mov eax, [ebp + 12]
        
        push ecx
        push eax
        call strlen
        ; ebx = strlen(key)
        mov ebx, eax
        ;dec ebx
        pop eax
        pop ecx
        
        xor esi, esi
        xor edx, edx
        
        push ebx
        push ecx
                      
build_string_key:
        ;pusha
        ;push eax
        ;call puts
        ;add esp, 4
        ;popa
        cmp byte [ecx + esi], 0
        je start_decoding
        cmp byte [ecx + esi], 'a'
        jl non_alpha
        cmp byte [ecx + esi], 'z'
        jg non_alpha
                
        push eax
        ; key_index = key_index % strlen(key)
        mov eax, edx
        xor edx, edx
        div bx
                      
        pop eax
        
        push ecx
        mov cl, byte [eax + edx]
        add eax, ebx
        mov byte [eax + esi], cl
        sub eax, ebx
        pop ecx
        inc esi
        inc edx
        jmp build_string_key

non_alpha:
        add eax, ebx
        push ebx
        mov bl, byte [ecx + esi]
        mov byte [eax + esi], bl
        pop ebx
        sub eax, ebx
        inc esi
        jmp build_string_key        

start_decoding:
        push eax
        ;push eax
        ;push error_no_file
        ;call puts
        pop eax
        ;push eax
        ;call puts
        
        
        ;mov byte [eax + esi], 0
        xor esi, esi
        xor edx, edx
        add eax, ebx
        xor ebx, ebx
        
        

decode_vigenere_char:
        ; decodes one character using the following algorithm:
        ; if (encoded_char is an alphabetic char)
        ;   offset = corresponding_key_char - 'a'
        ;   decoded_char = encoded_char shifted by offset positions to the left of the alphabet
        ; else
        ;   decoded_char = encoded_char
        
        mov bl, byte [ecx + esi]
        ;pusha
        ;push ecx
        ;call puts
        ;add esp, 4
        ;popa
        
        cmp bl, 0
        je exit_decode_vigenere
        
        cmp bl, 'a'
        jl non_alphabetic_char
        cmp bl, 'z'
        jg non_alphabetic_char
        
        ; dl = offset
        mov dl, byte [eax + esi]
        sub dl, 'a'
        
        ; decoded_char = decoded_char - offset
        sub bl, dl
        cmp bl, 'a'
        jl incorrect_shift
        jge correct_shift
       
incorrect_shift:
        mov dl, 'a'
        sub dl, bl
        mov bl, 123
        sub bl, dl
        mov byte [ecx + esi], bl
        inc esi
        jmp decode_vigenere_char
        
correct_shift:
        mov byte [ecx + esi], bl
        inc esi
        jmp decode_vigenere_char
        
non_alphabetic_char:
        inc esi
        jmp decode_vigenere_char
        
exit_decode_vigenere:        
        leave
	ret

main:
	push ebp
	mov ebp, esp
	sub esp, 2300

	; test argc
	mov eax, [ebp + 8]
	cmp eax, 2
	jne exit_bad_arg

	; get task no
	mov ebx, [ebp + 12]
	mov eax, [ebx + 4]
	xor ebx, ebx
	mov bl, [eax]
	sub ebx, '0'
	push ebx

	; verify if task no is in range
	cmp ebx, 1
	jb exit_bad_arg
	cmp ebx, 6
	ja exit_bad_arg

	; create the filename
	lea ecx, [filename + 7]
	add bl, '0'
	mov byte [ecx], bl

	; fd = open("./input{i}.dat", O_RDONLY):
	mov eax, 5
	mov ebx, filename
	xor ecx, ecx
	xor edx, edx
	int 0x80
	cmp eax, 0
	jl exit_no_input

	; read(fd, ebp - 2300, inputlen):
	mov ebx, eax
	mov eax, 3
	lea ecx, [ebp-2300]
	mov edx, [inputlen]
	int 0x80
	cmp eax, 0
	jl exit_cannot_read

	; close(fd):
	mov eax, 6
	int 0x80

	; all input{i}.dat contents are now in ecx (address on stack)
	pop eax
	cmp eax, 1
	je task1
	cmp eax, 2
	je task2
	cmp eax, 3
	je task3
	cmp eax, 4
	je task4
	cmp eax, 5
	je task5
	cmp eax, 6
	je task6
	jmp task_done

task1:
	; TASK 1: Simple XOR between two byte streams

	; TODO TASK 1: find the address for the string and the key
	; TODO TASK 1: call the xor_strings function
        
        xor esi, esi
        
get_key_address:
        
        inc esi
        cmp byte [ecx + esi - 1], 0
        jne get_key_address
        
        lea edx, [ecx + esi]
        
        push edx
        push ecx
        call xor_strings
        sub esp, 8

	push ecx
	call puts                   ;print resulting string
	add esp, 4

	jmp task_done

task2:
	; TASK 2: Rolling XOR

	; TODO TASK 2: call the rolling_xor function
        push ecx
        call rolling_xor
        sub esp, 4

	push ecx
	call puts
	add esp, 4

	jmp task_done

task3:
	; TASK 3: XORing strings represented as hex strings

	; TODO TASK 1: find the addresses of both strings
	; TODO TASK 1: call the xor_hex_strings function

	push ecx                     ;print resulting string
	call puts
	add esp, 4

	jmp task_done

task4:
	; TASK 4: decoding a base32-encoded string

	; TODO TASK 4: call the base32decode function
	
	push ecx
	call puts                    ;print resulting string
	pop ecx
	
	jmp task_done

task5:
	; TASK 5: Find the single-byte key used in a XOR encoding

	; TODO TASK 5: call the bruteforce_singlebyte_xor function
        push ecx
        call bruteforce_singlebyte_xor
        sub esp, 4
        push eax
        push ecx                  ;print resulting string
        call puts
        pop ecx
        pop eax
        
	push eax                    ;eax = key value
	push fmtstr
	call printf                 ;print key value
	add esp, 8

	jmp task_done

task6:
	; TASK 6: decode Vignere cipher

	; TODO TASK 6: find the addresses for the input string and key
	; TODO TASK 6: call the decode_vigenere function
        

	push ecx
	call strlen
	pop ecx

	add eax, ecx
	inc eax

	push eax
	push ecx                   ;ecx = address of input string 
	call decode_vigenere
	pop ecx
	add esp, 4

	push ecx
	call puts
	add esp, 4

task_done:
	xor eax, eax
	jmp exit

exit_bad_arg:
	mov ebx, [ebp + 12]
	mov ecx , [ebx]
	push ecx
	push usage
	call printf
	add esp, 8
	jmp exit

exit_no_input:
	push filename
	push error_no_file
	call printf
	add esp, 8
	jmp exit

exit_cannot_read:
	push filename
	push error_cannot_read
	call printf
	add esp, 8
	jmp exit

exit:
	mov esp, ebp
	pop ebp
	ret
