	.CR scmp
	.TF ledMatchOctal-lf12-gf12.hex, INT
	;
	; Led Match Octal game for SC MK-14
	; 2026 Princz László
	;
	; Keyboard matrix:
	;                        0D00  0D01  0D02  0D03  0D04  0D05  0D06  0D07
	; D7 128          Col8 -  0     1     2     3     4     5     6     7
	; D6 64           Col4 -  8     9
	; D5 32           Col2 -             Go    Mem  Abort              Term
	; D4 16           Col1 -  A     B     C     D                 E     F
	;
	; Load: 0x0F12
	; Enter at 0x0f12

	.IN config.asm
	.IN macros.asm

	.OR 0x0f12
InitGame:
	>LDP 1,DispKey		; P1 start address of display and keyboard memory
	>LDP 2,DataSegment	; P2 start address of video ram and data segment
	>LDP 3,CRom		; P3 start address of ROM charset
StartNextPuzzle:
	LDI 11			; the last byte for clear [ 11 - 0 ]
ClearLoop:			; 
	    XAE			; E := A
	    LDI 0		; Data for clear
	    ST E(2)		; Clear data segment E. byte
	    LDI 0xFF		; -1
	    CCL			; Clear Cy
	    ADE			; A := E-1
	JP ClearLoop		; Jump if A >= 0
	LD NewPuzzle(2)		; Activate new puzzle
	ANI 127			; Only 7 segments
	ST Puzzle(2)
StartWithKeyStateArchive:
	LD KeybState(2)
	ST LastKeybState(2)	; Store previous keyboard state ( 0, 248-255 )
Start:	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;; Display and keyboard manager block
	;;; Display the contents of video memory (0D00-0D07), and reading the keyboard status simultaneously
	;;; If you read the keyboard, the display will flash, so you need to operate these two devices together
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	LDI 0
	ST KeybState(2)		; Init keyboard status
	; ST LastNumChar(2)	; init key character format too
	LDI 8
	ST Addr(2)		; Init displayAddress shift
DisplayLoop:
	    DLD Addr(2)		; A = address shift: 7 .. 0
	    XAE			; E := A ( 7 .. 0 )
	    LD E(2)		; A := (Dram+E)
	    ST E(1)		; Show character at position E in video memory
	    LD E(1)		; Read keyboard state from position E
	    XRI 0xFF		; 0, if nothing is pressed
	    JZ KeyNotPressed	
		XRI 32		; Go and Term keybord row ( D5 )
		JZ MaybeGoPressed
		XRI 160		; Check 0-7 keys (D7)
		JNZ KeyNotPressed
	        LDE		; E store pressed key value: 0..7
		XRI 0xFF	; Xor key number, because 0 means: "no key pressed"
	        ST KeybState(2)
KeyNotPressed:
	    LD Addr(2)
	JNZ DisplayLoop
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;;; End of display and keyboard manager block
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	LD Success(2)		; Chack game state
	JNZ SuccessLoop		; Jump if puzzle solved

	; Puzzle is not solved, check the pressed or release keys
	LD KeybState(2)		;
	XAE			; E := KeybState
	LD LastKeybState(2)	; A := LastKeybState
	XRE			; A := A xor E
	JZ Start		; No change keyboard, nothing doing 
	    ; A contains last keyboard state (0 or 248-255)
	    ; E contanins current keyboard state. 0 if released
	    ; A or E is 0 => A or E is not 0
	XAE			; A=current keyboard state, E=last keyboard state
	JZ StartWithKeyStateArchive		; jump if release key
	; Now a new key is pressed
	XRI 0xFF		; A contains key value: 0-7
	XAE			; E := A
	LD E(3)			; A := (CRom+E), character format
	ST LastNumChar(2)	; store character format for toggle and display (show if not exists or hide if exists)
	; A contanins character format
	LDI MaxSelectionCounter	; 5
	ST Addr(2)
	ST EmptyDRamAddr(2)	; An invlaid ram address for display. This value means no other free space
DRamClearLoop:			; First, seek for pressed number, remove if found
	DLD Addr(2)		; 4..0
	XAE			; E := A video ram shift position: 4-0
	LD E(2)			; A := (videoRamStart+E)
	JNZ DRamByteInUse	; Jump if video ram byte in use
	; This byte is empty. Store shift value (position)
	XAE
	ST EmptyDRamAddr(2)	; Store shift value
	XAE
DRamByteInUse:			; E contains position, A contanins displayed value (format)
	XAE			; E := character format in E. position of video ram
	LD LastNumChar(2)	; A contanins character format of last pressed key
	XRE			; Equals?
	JNZ CheckNextDisplayedCharacter	; If A != E, check next position
	; remove current character from display (toggle). Warning: A == 0
	XAE			; E := 0
	LD Addr(2)		; A := current shift address
	XAE			; E := shift address and A = 0, for clear
	ST E(2)			; (video ram start + E) := 0 clear displayed character
	JMP StartWitXorSum	; checking finished
CheckNextDisplayedCharacter:
	LD ADDR(2)
	JNZ DRamClearLoop

	; Here there is no pressed key in the video ram
	LD EmptyDRamAddr(2)
	XAE
	LDE
	XRI MaxSelectionCounter
	JZ StartWithKeyStateArchive				; Nincs több szabad hely, nem módosítunk
	; E contains the free position
	LD LastNumChar(2)
	ST E(2)					; Clear video ram E. position
StartWitXorSum:
	LD LastNumChar(2)
	XOR XorSum(2)
	ST XorSum(2)				; A contanins current XOR value
	XAE
	LD Puzzle(2)
	XRE
	JNZ StartWithKeyStateArchive
;;; Success
	ST XorSum(2)
SuccessLoop:
	DLD FlashCounter(2)			; For slow flash
	JNZ NextPuzzle
	LDI 61					; G caharcter format
	XOR XorSum(2)
	ST XorSum(2)
	LDI 63					; O caharcter format
	XOR StatusPosition(2)
	ST StatusPosition(2)
NextPuzzle:
	ILD NewPuzzle(2)
	JZ NextPuzzle
	ST Success(2)
	>BigJumpInPage StartWithKeyStateArchive

MaybeGoPressed:
	LD Success(2)
	JZ NoGo					; Amíg 0, addig nem lehet a Go-val a következőt elkérni
	LDE
	XRI 2					; Go key
	JNZ NoGo
	>BigJumpInPage StartNextPuzzle
BigJumpKeyNotPressed:
	>BigJumpInPage KeyNotPressed
NoGo:
	LDE					; Check Term key
	XRI 7					; Term key
	JNZ BigJumpKeyNotPressed
	ILD NewPuzzle(2)
	>BigJumpInPage StartNextPuzzle

DispKey		.EQ 0x0D00			; Display and keyboard Address
CRom		.EQ 0x110B			; Charset start address
DataSegment:	.DB 0,0,0,0,0,0,0,0		; Video ram
		.DB 0,0,0			; variables to be initialized
		.DB 0,0,0,DefaultPuzzle,0	; variables that don't need to be initialized
Puzzle:		.EQ PuzzlePosition		; Use direct in video ram
XorSum:		.EQ CurrentPosition		; Use direct in video ram
LastNumChar:	.EQ 8				; Last pressed key number character format: (between 1-127, not 0)
KeybState:	.EQ 9				; The 1's complement of the value of the currently pressed key, or 0 (248-255 or 0)
EmptyDRamAddr:	.EQ 10				; Last empty byte position in video ram
Success:	.EQ 11
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; variables that don't need to be initialized
LastKeybState:	.EQ 12				; Last keyboard state
Addr:		.EQ 13				; Address variable for loops ( 8-0, 5-0 )
NewPuzzle:	.EQ 14				; The next puzzle value
FlashCounter:	.EQ 15				; Counter for slow flash effect
