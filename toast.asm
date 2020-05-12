	%macro outputs 2
	mov eax, 4
	mov ebx, 1
	mov ecx, %1
	mov edx, %2
	int 80h
	%endmacro
	
	%macro inputs 1
	mov eax, 3
	mov ebx, 2
	mov ecx, %1
	mov edx, 5
	int 80h
	%endmacro

	%macro compare 3
	MOV AL, %1
        CMP AL, %2
        JE %3
	%endmacro





section .bss
	choice resb 2
section .data
	
	program_section dw 0xa, 0xa, '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++', 0xa,'+++++++++++++++++++++++++++++++  STARTING UP TOASTER   +++++++++++++++++++++++++++++++', 0xa, 0xa
        program_section_len equ $-program_section
	
	one db '1'
	two db '2'
	three db '3'
	four db '4'
	five db '5'
	pop_out db 'p'

	carets db '>>> '
	carets_len equ $-carets

	toast_start db '1 - Toast level', 0xa,'2 - Start', 0xa,'3 - Stop',0xa,0xa
	toast_start_len equ $-toast_start

	toast_level db 'Set toast level', 0xa,'1 - Light', 0xa,'2 - Medium', 0xa,'3 - Dark', 0xa,'4 - Back',0xa,0xa
	toast_level_len equ $-toast_level

		

	light_toast db 'Toast level set to light', 0xa,0xa
	light_toast_len equ $-light_toast

	medium_toast db 'Toast level set to medium', 0xa,0xa
	medium_toast_len equ $-medium_toast

	dark_toast db 'Toast level set to dark', 0xa,0xa
	dark_toast_len equ $-dark_toast

	start_toast db 'Toasting...',0xa,'press p to pop',0xa,0xa
	start_toast_len equ $-start_toast

	pop_toast db 'Bread popped...',0xa,0xa
	pop_toast_len equ $-pop_toast	

	stop db 'Toaster stopped',0xa,0xa
	stop_len equ $-stop


section .text
global _start

_start:
	outputs program_section, program_section_len

begin:

	outputs toast_start, toast_start_len
	outputs carets, carets_len
	inputs choice	
	compare [choice], [one], level
	compare [choice], [two], toaster_start
	compare [choice], [three], toast_stop


toaster_start:
	outputs start_toast, start_toast_len
	inputs choice
	compare [choice], [pop_out], toast_pop

toast_stop:
	outputs stop, stop_len
	JMP exit
	

toast_pop:
	outputs pop_toast, pop_toast_len
	JMP begin


level:
	outputs toast_level, toast_level_len
	outputs carets, carets_len
	inputs choice
	compare [choice], [one], light
	compare [choice], [two], medium
	compare [choice], [three], dark
	compare [choice], [four], begin


light:
	outputs light_toast, light_toast_len
	JMP begin

medium:
	outputs medium_toast, medium_toast_len
	JMP begin
dark:
	outputs dark_toast, dark_toast_len
	JMP begin


exit:
 
	MOV EAX, 1
	MOV EBX, 0
	int 80h
