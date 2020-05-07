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
	
	program_section dw 0xa, 0xa, '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++', 0xa,'+++++++++++++++++++++++++++++++  STARTING UP AIR CONDITIONER   +++++++++++++++++++++++++', 0xa, 0xa
        program_section_len equ $-program_section
	
	one db '1'
	two db '2'
	three db '3'
	four db '4'
	temp_current dw '1'



	carets db '>>> '
	carets_len equ $-carets


	power_on db '1 - Power On', 0Xa, '2 - Exit',0xa, 0xa
	power_on_len equ $-power_on

	boot_msg db 'Starting up AC...',0xa, 'Started',0xa,0xa
	boot_msg_len equ $-boot_msg

	ac_start db '1 - Mode', 0xa, '2 - Temperature', 0xa, '3 - Power Off', 0xa,0xa
	ac_start_len equ $-ac_start

	shutdown db 'Shutting down AC... done', 0xa,0xa
	shutdown_len equ $-shutdown

	;MODE
	ac_mode db '1 - Cool', 0xa, '2 - Dry', 0xa, '3 - Fan',0xa,'4 - Back', 0xa,0xa
	ac_mode_len equ $-ac_mode
	
	;MODE > OPTIONS -> choices
	cool db 'Switching mode to Cool...', 0xa,'Mode changed', 0xa,0xa
	cool_len equ $-cool

	dry db 'Switching to Dry mode...', 0xa,'Mode changed', 0xa,0xa
        dry_len equ $-dry

	fan db 'Switching to Fan mode...', 0xa,'Mode changed', 0xa,0xa
        fan_len equ $-fan

	;TEMPERATURE > OPTIONS
	;DEFAULT TEMPERATURE IS 61
	temp_set_msg db 'current temperature is ';WILL APPEND A DYNAMIC TEMP HERE
	temp_set_msg_len equ $-temp_set_msg

	temp_adjust db 0xa, '1 - Increase',0xa,'2 - Decrease',0xa,'3 - Back',0xa,0xa
	temp_adjust_len equ $-temp_adjust	

	temp_status db 'Temperature set to ',0xa;increment temp_current and append here
	


;COOL
;DRY
;FAN

section .text
global _start
_start:

	outputs program_section, program_section_len
	
startup:
	outputs power_on, power_on_len
	outputs carets, carets_len
	inputs choice
	compare [choice],[one], start_message
	compare [choice], [two], exit


start_message:
	outputs boot_msg, boot_msg_len
	JMP ac_started


ac_started:
	outputs ac_start, ac_start_len
	outputs carets, carets_len
	inputs choice

	compare [choice],[one], mode
        compare [choice], [two], temp_ac
	compare [choice],[three], ac_shutdown


ac_shutdown:
	outputs shutdown, shutdown_len
	JMP startup


mode:
	outputs ac_mode, ac_mode_len
	outputs carets, carets_len
	inputs choice
	
	compare [choice], [one], ac_cool
	compare [choice], [two], ac_dry
	compare [choice], [three], ac_fan
	compare [choice], [four], ac_started




;AC MODE
ac_cool:
	outputs cool, cool_len
	JMP ac_started

ac_dry:
	outputs dry, dry_len
        JMP ac_started

ac_fan:
	outputs fan, fan_len
        JMP ac_started


;AC TEMPERATURE
temp_ac:
	outputs temp_set_msg, temp_set_msg_len
	outputs temp_current, 2
	outputs temp_adjust,temp_adjust_len
	outputs carets, carets_len
	inputs choice
	
	compare [choice], [one], increase
        compare [choice], [two], decrease
	compare [choice], [three], ac_started


increase:
	MOV EAX, [temp_current]
	SUB EAX, '0'	;CONVERT ASCII TO DECIMAL
	INC EAX 	;INCREASE TEMPERATURE BY ONE
	ADD EAX, '0'
	MOV [temp_current], EAX
	JMP temp_ac


decrease:
	MOV EAX, [temp_current]
        SUB EAX, '0'
        DEC EAX		;DECREASE TEMPERATURE BY ONE
        ADD EAX, '0'
        MOV [temp_current], EAX
        JMP temp_ac


exit:
	 mov eax, 1
   	 mov ebx, 0
   	 int 80h
