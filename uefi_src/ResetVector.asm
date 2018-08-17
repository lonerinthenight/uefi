;------------------------------------------------------------------------------
; Module Name:  ResetVec.asm
; Abstract:  Reset Vector Data structure(located at 0xFFFFFFC0)
;------------------------------------------------------------------------------
    .model  tiny
    .686p
    .stack  0h
    .code
	
;0xFFFFFFC0: FIT table pointer for LT-SX
			ORG     0h
			FitTablePointer DD 0eeeeeeeeh, 0eeeeeeeeh

;0xFFFFFFD0: 
			ORG     10h
			mov     di, "AP"
			jmp     ApStartup

;0xFFFFFFE0: PEI core entry point
			ORG     20h
			PeiCoreEntryPoint DD 87654321h
			
;0xFFFFFFE4: the handler for all kinds of exceptions. 
			;仅用于debugging，来定位异常源
			InterruptHandler    PROC
				jmp     $
				iret
			InterruptHandler    ENDP

;0xFFFFFFF0: the reset vector of IA32
			ORG     30h
			ResetHandler:
			wbinvd

;0xFFFFFFF2: Jmp to SEC Entry Point(机器码避免编译器优化)
			ApStartup:
			DB      0e9h ; jump
			DW      -3   ; 0xF7E3(fixed up by build tool)

;0xFFFFFFF8: Ap reset vector segment address
			ORG     38h
			ApSegAddress DD 12345678h 

;0xFFFFFFFC: BFV Base
			ORG     3ch
			BfvBase     DD 12345678h

			; Nothing can go here, otherwise the layout of this file would change.
			END
