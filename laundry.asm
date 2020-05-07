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
	
	program_section dw 0xa, 0xa, '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++', 0xa,'+++++++++++++++++++++++++++++++  STARTING UP WASHING MACHINE   +++++++++++++++++++++++++', 0xa, 0xa
        program_section_len equ $-program_section
	
	one db '1'
	two db '2'
	three db '3'
	four db '4'
	five db '5'
	six db '6'
	quit db 'q'

	carets db '>>> '
	carets_len equ $-carets
	

	;Choice setup
	wash_setup db 'Setting up wash mode...', 0xa, 'done', 0xa, 0xa
	wash_len equ $-wash_setup

	warm db 'Setting up warm water...', 0xa, 'done', 0xa, 0xa
	warm_len equ $-warm

	hot db 'Setting up hot water...', 0xa, 'done', 0xa, 0xa
	hot_len equ $-hot

	cold db 'Setting up cold water...', 0xa, 'done', 0xa, 0xa
	cold_len equ $-cold

	delicate_msg db 'Spin setup for Delicate', 0xa, 'Washing in process...', 0xa, 'Press q to terminate', 0xa, 0xa
	del_len equ $-delicate_msg
	
	spread_msg db 'Spin setup for Spread and Wash', 0xa, 'Washing in process...', 0xa, 'Press q to terminate',0xa, 0xa
	spread_len equ $-spread_msg

	permanent_msg db 'Spin setup for Permanent Press', 0xa, 'Washing in process...', 0xa, 'Press q to terminate', 0xa, 0xa
	perm_len equ $-permanent_msg
	
	rinse_msg db 'Spin setup for Rinse and Spin', 0xa, 'Washing in process...', 0xa, 'Press q to terminate', 0xa, 0xa
	rinse_len equ $-rinse_msg

	normal_msg db 'Spin setup for Normal', 0xa, 'Washing in process...', 0xa, 'Press q to terminate', 0xa, 0xa
	norm_len equ $-normal_msg	

	;Startup Activitieis
	activity db 'Please select an activity', 0xa,'1 - Wash', 0xa, '2 - Drain', 0xa,0xa
	activity_len equ $-activity

	;Wash
	temp db 'Please set water temperature', 0xa,'1 - Warm (30 deg)', 0xa,'2 - Hot (80 deg)', 0xa, '3 - Cold (10 deg)',0xa, '4 - Back',0xa,0xa
	temp_len equ $-temp

	;Spin mode
	spin_mode dw 'Please set spin mode for washing', 0xa,'1 - Delicate(Frigile items and land fabric)',0xa, '2 - Spread wash', 0xa,'3 - Permanent Press(Synthetic fabric)', 0xa,'4 - Rinse and Spin(No detergent)',0xa,'5 - Normal(Cotton and blended fabric)', 0xa, '6 - Back',0xa, 0xa
	spin_len equ $-spin_mode

	;Drain
	drain_msg db 'Draining Laundry...', 0xa, 'draining complete', 0xa
	drain_len equ $-drain_msg

section .text

global _start
_start:

   activity_opt:
	;DIPLAY ACTIVITY LIST
	outputs program_section, program_section_len
	outputs activity, activity_len
	outputs carets, carets_len
	inputs choice
	compare [choice], [one], wash
	compare [choice], [two], drain


   drain:
	outputs drain_msg, drain_len
	int 80h
	JMP exit
	
   wash:
	outputs wash_setup, wash_len
	outputs temp, temp_len
	outputs carets, carets_len
	inputs choice
	compare [choice], [one], warm_wash
	compare [choice], [two], hot_wash
	compare [choice], [three], cold_wash
	compare [choice], [four], activity_opt
	int 80h
	JMP exit


   warm_wash:
	outputs warm, warm_len
	outputs spin_mode, spin_len
	outputs carets, carets_len
	inputs choice
	compare [choice], [one], delicate
        compare [choice], [two], spread
        compare [choice], [three], permanent
        compare [choice], [four], rinse
        compare [choice], [five], normal
	compare [choice], [six], wash


   hot_wash:
	outputs hot, hot_len
	outputs spin_mode, spin_len
	outputs carets, carets_len
	inputs choice
	compare [choice], [one], delicate
	compare [choice], [two], spread
	compare [choice], [three], permanent
	compare [choice], [four], rinse
	compare [choice], [five], normal
	compare [choice], [six], wash

   cold_wash:
	outputs cold, cold_len
	outputs spin_mode, spin_len
	outputs carets, carets_len
	inputs choice
	compare [choice], [one], delicate
        compare [choice], [two], spread
        compare [choice], [three], permanent
        compare [choice], [four], rinse
        compare [choice], [five], normal
	compare [choice], [six], wash
	
    delicate:
	outputs delicate_msg, del_len
	inputs choice
	compare [choice], [quit], exit
	
    spread:
	outputs spread_msg, spread_len
        inputs choice
        compare [choice], [quit], exit
 
    permanent:
	outputs permanent_msg, perm_len
        inputs choice
        compare [choice], [quit], exit
	
    rinse:
	outputs rinse_msg, rinse_len
        inputs choice
        compare [choice], [quit], exit

    normal:
	outputs normal_msg, norm_len
        inputs choice
        compare [choice], [quit], exit

   exit:
	 mov eax, 1
   	 mov ebx, 0
   	 int 80h


