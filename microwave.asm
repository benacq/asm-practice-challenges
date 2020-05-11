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
	time_input resb 2

section .data
	
	program_section dw 0xa, 0xa, '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++', 0xa,'+++++++++++++++++++++++++++++++  STARTING UP MICROWAVE   +++++++++++++++++++++++++++++++', 0xa, 0xa
        program_section_len equ $-program_section
	
	one db '1'
	two db '2'
	three db '3'
	four db '4'
	five db '5'


	carets db '>>> '
	carets_len equ $-carets


	start_opts db '1 - Power Level',0xa,'2 - Set time', 0xa,'3 - Stop/Cancel',0xa,'4 - Start', 0xa,0xa
	start_opts_len equ $-start_opts


	;OPTIONS > POWER LEVEL
	opts_power db '1 - High',0xa,'2 - Low(simmer)', 0xa,'3 - Defrost(warm)',0xa,'4 - Back', 0xa,0xa
        opts_power_len equ $-opts_power

	high db 'Power level set to high', 0xa,0xa
	high_len equ $-high

	low db 'Power level set to low', 0xa,0xa
        low_len equ $-low

	defrost db 'Power level set to warm', 0xa,0xa
        defrost_len equ $-defrost


	;OPTIONS > SET TIME 
	time db 'Enter time for process(in seconds)',0xa,0xa
	time_len equ $-time	

	time_val db 'Time set to '
	time_val_len equ $-time_val

	
	opt_start db 'Starting microwave...', 0xa,'running',0xa
	opt_start_len equ $-opt_start


	opt_stop db 'Terminating operation... terminated', 0xa
	opt_stop_len equ $-opt_stop


section .text
global _start
_start:
	outputs program_section, program_section_len

begin:
	outputs start_opts, start_opts_len
	outputs carets, carets_len
	inputs choice
	compare [choice], [one], power
	compare [choice], [two], set_time
	compare [choice], [three], terminate
	compare [choice], [four], starter


power:
	outputs opts_power, opts_power_len
	outputs carets, carets_len
	inputs choice

	compare [choice], [one], power_high
        compare [choice], [two], power_low
        compare [choice], [three], power_defrost
        compare [choice], [four], begin


power_high:
	outputs high, high_len
	JMP begin

power_low:
	outputs low, low_len
        JMP begin

power_defrost:
	outputs defrost, defrost_len
        JMP begin

set_time:
	outputs time, time_len
	outputs carets, carets_len
	inputs time_input
	
	outputs time_val, time_val_len
	;MOV EAX, [time_input]
	outputs time_input, 2
	JMP begin
	
terminate:
	outputs opt_stop, opt_stop_len
	JMP exit

starter:
	outputs opt_start, opt_start_len
	inputs choice

exit:
	MOV EAX, 1
	MOV EBX, 0
	int 80h
