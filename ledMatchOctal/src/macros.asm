
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Load value into Pointer
;   LD_P n address.
;      n:       1..3 ; not used for P0!
;      address: fix cím
;   Example: LD_P 1 Disp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
LDP .MA pIndex,Address
        LDI /]2	; A cím magas bájtja
        XPAH ]1
        LDI #]2	; A cím alacsony bájtja
        XPAL ]1	; Pn-ben a cím
    .EM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Jump anywhere to Address use Px
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
BigJump .MA pointerIndex,Address
        LDI /]2-1	; A cím magas bájtja
        XPAH ]1
        LDI #]2-1	; A cím alacsony bájtja
        XPAL ]1	; P]1-ben a cím
        XPPC P]1	; PC<=>P]1
    .EM

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Jump to Address if PC high not changed
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
BigJumpInPage	.MA Address
        LDI	#]1-1
        XPAL	0
    .EM
