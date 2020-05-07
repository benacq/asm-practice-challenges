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
	one db '1'
	two db '2'
	three db '3'
	four db '4'
	five db '5'
	six db '6'
	seven db '7'

	carets db '>>> '
	carets_len equ $-carets
	
	
	program_section dw 0xa, 0xa, '++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++', 0xa,'+++++++++++++++++++++++++++++++  STARTING UP WASHING MACHINE   +++++++++++++++++++++++++', 0xa, 0xa
	program_section_len equ $-program_section


	power_on db '1 - Power On', 0Xa, '2 - Exit',0xa, 0xa
	power_on_len equ $-power_on

	boot_msg db 'Starting Projector...',0xa, 'Started',0xa,0xa
	boot_msg_len equ $-boot_msg

	start_msg db '1 - Power off', 0xa, '2 - Standby', 0xa, '3 - Menu', 0xa,0xa
	start_msg_len equ $-start_msg

	shutdown db 'Shutting down projector... done', 0xa,0xa
	shutdown_len equ $-shutdown

	standby_msg db 'Putting device to standby... done', 0xa,0xa
	standby_len equ $-standby_msg

	resume_msg db 'Resuming session... done', 0xa,0xa
	resume_msg_len equ $-resume_msg

	resume db '1 - Resume',0xa, 0xa
	resume_len equ $-resume


	;MAIN MENU
	menu_options dw '1 - Display', 0xa,'2 - Projection',0xa, '3 - Control panel lock',0xa,'4 - Back',0xa,0xa	
	menu_options_len equ $-menu_options
	
	;MENU > DISPLAY
	display_menu_options db '1 - Display Background',0xa,'2 - Startup Screen',0xa,'3 - A/V mute',0xa, '4 - Back',0xa,0xa
        display_menu_options_len equ $-display_menu_options
	
	;MENU > DISPLAY > DISPLAY BACKGROUND
	display_background_colors db 'Select a background color to set when no signal is received',0xa,0xa,'1 - Red', 0xa,'2 - Blue',0xa,'3 - Yellow',0xa,'4 - Green',0xa,'5 - Back',0xa,0xa
	display_background_colors_len equ $-display_background_colors 	

	;MENU > DISPLY > DISPLAY BACKGROUND > COLORS => choices
	red db 'Display background set to red', 0xa,0xa
	red_len equ $-red

	blue db 'Display background set to blue', 0xa,0xa
        blue_len equ $-blue

	yellow db 'Display background set to yellow', 0xa,0xa
        yellow_len equ $-yellow

	green db 'Display background set to green', 0xa,0xa
        green_len equ $-green



	;MENU DISPLAY > STARTUP SCREEN
	display_startup db 'Set special screen for projector on startup?',0xa,0xa,'1 - Yes',0xa,'2 - No', 0xa,0xa
	display_startup_len equ $-display_startup

	startup_screen_yes db 'Special screen set for projector startup', 0xa,0xa
	startup_yes_len equ $-startup_screen_yes



	;MENU > DISPLAY > A/V MUTE
        av_color db 'Select a screen color to display when A/V mute is turned on',0xa,0xa,'1 - Grey', 0xa,'2 - Brown',0xa,'3 - Orange',0xa,'4 - Purple',0xa,'5 - Back',0xa,0xa
        av_color_len equ $-av_color

        ;MENU > DISPLY > A/V MUTE > COLORS => choices
        grey db 'Screen color will be set to Grey when a/v is turned on', 0xa,0xa
        grey_len equ $-grey

        brown db 'Screen color will be set to Brown when a/v is turned on', 0xa,0xa
        brown_len equ $-brown

        orange db 'Screen color will be set to Orange when a/v is turned on', 0xa,0xa
        orange_len equ $-orange

        purple db 'Screen color will be set to Purple when a/v is turned on', 0xa,0xa
        purple_len equ $-purple






	;MENU > PROJECTION

        projection_options db 'Set projector position for proper image orientation',0xa,0xa,'1 - Front', 0xa,'2 - Front/Upside Down',0xa,'3 - Rear',0xa,'4 - Rear/Upside Down',0xa,'5 - Back',0xa,0xa
        projection_options_len equ $-projection_options

        ;MENU > DISPLY > A/V MUTE > COLORS => choices
        front db 'Projector position set to Front', 0xa,0xa
        front_len equ $-front

        front_upside db 'Projector position set to Front/Upside Down', 0xa,0xa
        front_upside_len equ $-front_upside

        rear db 'Projector position set to Rear', 0xa,0xa
        rear_len equ $-rear

        rear_upside db 'Projector position set to Rear/Upside Down', 0xa,0xa
        rear_upside_len equ $-rear_upside



	;MENU > CONTROL PANEL LOCK
	control_panel db 'Set projector button locking',0xa,0xa,'1 - Full lock', 0xa,'2 - Partial lock',0xa,'3 - Off',0xa,'4 - Back',0xa,0xa
        control_panel_len equ $-control_panel

        ;MENU > DISPLY > A/V MUTE > COLORS => choices
        full db 'All projector buttons locked', 0xa,0xa
        full_len equ $-full

        partial db 'All projector buttons locked except power button', 0xa,0xa
        partial_len equ $-partial

        off db 'Projector button lock disabled', 0xa,0xa
        off_len equ $-off



section .text
global _start
_start:
	outputs program_section, program_section_len
	
startup:
	outputs power_on, power_on_len
	outputs carets, carets_len
	inputs choice
	compare [choice], [one], started
	compare [choice], [two], exit



power_off:
	outputs shutdown, shutdown_len
	JMP startup

started:
	outputs boot_msg, boot_msg_len
resuming:
	outputs start_msg, start_msg_len
	outputs carets, carets_len
	inputs choice
	compare [choice], [one], power_off
	compare [choice], [two], standby
	compare [choice], [three], menu

standby:
	outputs standby_msg, standby_len
	outputs resume, resume_len
	outputs carets, carets_len
	inputs choice

resumed:
	outputs resume_msg, resume_msg_len
	JMP resuming


;MENU
menu:
	outputs menu_options, menu_options_len
	outputs carets, carets_len
	inputs choice	
	compare [choice], [one], display
        compare [choice], [two], projection
        compare [choice], [three], control_panel_lock
        compare [choice], [four], resuming ;BACK


;MENU > DISPLAY
display:
	outputs display_menu_options, display_menu_options_len
	outputs carets,carets_len
	inputs choice
	compare [choice], [one], display_bg
        compare [choice], [two], startup_screen
        compare [choice], [three], av_mute
	compare [choice], [four], menu ;BACK


projection:
	outputs projection_options, projection_options_len
	outputs carets, carets_len
	inputs choice
	compare [choice], [one], project_front
        compare [choice], [two], project_front_upside
        compare [choice], [three], project_rear
        compare [choice], [four], project_rear_upside
        compare [choice], [five], menu

control_panel_lock:
	outputs control_panel, control_panel_len
        outputs carets, carets_len
        inputs choice
        compare [choice], [one], full_lock
        compare [choice], [two], partial_lock
        compare [choice], [three], off_lock
        compare [choice], [four], menu






;MENU > DISPLAY > BACKGROUND
display_bg:
	outputs display_background_colors, display_background_colors_len
	outputs carets, carets_len
	inputs choice
	compare [choice], [one], red_bg
        compare [choice], [two], blue_bg
        compare [choice], [three], yellow_bg
        compare [choice], [four], green_bg
	compare [choice], [five], display


startup_screen:
	outputs display_startup, display_startup_len
	outputs carets, carets_len
	inputs choice	
	compare [choice], [two], display


startup_yes:
	outputs startup_screen_yes, startup_yes_len
	JMP display


av_mute:
	outputs av_color, av_color_len
	outputs carets, carets_len
	inputs choice
	
	compare [choice], [one], av_grey
        compare [choice], [two], av_brown
        compare [choice], [three], av_orange
        compare [choice], [four], av_purple
	compare [choice], [five], display
	


;DISPLAY > BACKGROUND > COLORS
red_bg:
	outputs red, red_len
	JMP display

blue_bg:
	outputs blue, blue_len
        JMP display

yellow_bg:
	outputs yellow, yellow_len
        JMP display


green_bg:
	outputs green, green_len
        JMP display



;DISPLAY > AV/MUTE > COLORS
av_grey:
        outputs grey, grey_len
        JMP display

av_brown:
        outputs blue, brown_len
        JMP display

av_orange:
        outputs orange, orange_len
        JMP display

av_purple:
        outputs purple, purple_len
        JMP display



;DISPLAY > PROJECTION > OPTIONS
project_front:
	outputs front, front_len
        JMP menu

project_front_upside:
	outputs front_upside, front_upside_len
        JMP menu

project_rear:
	outputs rear, rear_len
        JMP menu

project_rear_upside:
	outputs rear_upside, rear_upside_len
        JMP menu

;DISPLAY > CONTROL PANEL LOCK > OPTIONS
full_lock:
	outputs full, full_len
        JMP menu

partial_lock:
	outputs partial, partial_len
        JMP menu

off_lock:
	outputs off, off_len
        JMP menu






 exit:
	 mov eax, 1
   	 mov ebx, 0
   	 int 80h














