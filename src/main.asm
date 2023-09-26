                    !cpu 6510

DEBUG = 0
RELEASE = 1
; ==============================================================================
ENABLE              = 0x20
ENABLE_JMP          = 0x4C
DISABLE             = 0x2C

BLACK               = 0x00
WHITE               = 0x01
RED                 = 0x02
CYAN                = 0x03
PURPLE              = 0x04
GREEN               = 0x05
BLUE                = 0x06
YELLOW              = 0x07
ORANGE              = 0x08
BROWN               = 0x09
PINK                = 0x0A
DARK_GREY           = 0x0B
GREY                = 0x0C
LIGHT_GREEN         = 0x0D
LIGHT_BLUE          = 0x0E
LIGHT_GREY          = 0x0F

MEMCFG              = 0x36

PAL_CYCLES          = 19655
; ------------------------------------------------------------------------------
;                   BADLINEs (0xD011 default)
;                   -------------------------
;                   00 : 0x33
;                   01 : 0x3B
;                   02 : 0x43
;                   03 : 0x4B
;                   04 : 0x53
;                   05 : 0x5B
;                   06 : 0x63
;                   07 : 0x6B
;                   08 : 0x73
;                   09 : 0x7B
;                   10 : 0x83
;                   11 : 0x8B
;                   12 : 0x93
;                   13 : 0x9B
;                   14 : 0xA3
;                   15 : 0xAB
;                   16 : 0xB3
;                   17 : 0xBB
;                   18 : 0xC3
;                   19 : 0xCB
;                   20 : 0xD3
;                   21 : 0xDB
;                   22 : 0xE3
;                   23 : 0xEB
;                   24 : 0xF3
; ------------------------------------------------------------------------------
IRQ_LINE00          = 0x00                    ; music #1
IRQ_LINE01          = 0x31                    ; yellow bar / hires mode
IRQ_LINE02          = 0x32+(8*1)              ; grey bar
IRQ_LINE03          = 0x32+(8*2)              ; pink bar
IRQ_LINE04          = 0x32+(8*3)              ; orange bar
IRQ_LINE05          = 0x32+(8*4)              ; red bar
IRQ_LINE06          = 0x32+(8*5)              ; brown bar
IRQ_LINE07          = 0x32+(8*6)              ; blue bar
IRQ_LINE08          = 0x32+(8*7)              ; dark grey bar
IRQ_LINE09          = 0x32+(8*8)              ; purple bar
IRQ_LINE10          = 0x32+(8*9)              ; light blue bar
IRQ_LINE11          = 0x32+(8*10)             ; green bar
IRQ_LINE12          = 0x32+(8*11)             ; cyan bar
IRQ_LINE13          = IRQ_LINE12+15           ; char mode / sprites / music #2
IRQ_LINE14          = 0xF9                    ; open border
IRQ_LINE15          = 0x21                    ; sprites multiplex
; ==============================================================================
                    !source "krill/loadersymbols-c64.inc"
zp_start            = 0x02
flag_irq_ready      = zp_start
zp_temp0            = flag_irq_ready+1
zp_temp0_lo         = zp_temp0
zp_temp0_hi         = zp_temp0+1
zp_temp1            = zp_temp0_hi+1
zp_temp1_lo         = zp_temp1
zp_temp1_hi         = zp_temp1+1
flag_irq_top        = 0xFB
; ==============================================================================
KEY_CRSRUP          = 0x91
KEY_CRSRDOWN        = 0x11
KEY_CRSRLEFT        = 0x9D
KEY_CRSRRIGHT       = 0x1D
KEY_RETURN          = 0x0D
KEY_STOP            = 0x03

getin               = 0xFFE4
keyscan             = 0xEA87
; ==============================================================================
code_start          = 0x0800
songdata            = 0x3300
vicbank0            = 0x4000
charset0            = vicbank0+0x0000
charset1            = vicbank0+0x2800
vidmem0             = vicbank0+0x2000
vidmem1             = vicbank0+0x2400
data_start          = 0x1000
loader_resident     = loadcompd
loader_init         = data_start
sprite_data         = vicbank0+0x3000
sprite_base         = <((sprite_data-vicbank0)/0x40)
bitmap0             = vicbank0
dd00_val0           = <!(vicbank0/0x4000) & 3
d018_val0           = <(((vidmem0-vicbank0)/0x400) << 4)+ <(((charset0-vicbank0)/0x800) << 1)
d018_val1           = <(((vidmem1-vicbank0)/0x400) << 4)+ <(((charset1-vicbank0)/0x800) << 1)
; ==============================================================================
                    !macro flag_set .flag {
                        lda #1
                        sta .flag
                    }
                    !macro flag_clear .flag {
                        lda #0
                        sta .flag
                    }
                    !macro flag_get .flag {
                        lda .flag
                    }
; ==============================================================================
                    *= loader_resident
                    !bin "krill/loader-c64.prg",,2
                    *= loader_init
                    !bin "krill/install-c64.prg",,2
; ==============================================================================
                    *= bitmap0
                    !bin "gfx/hires_top.prg",(13*40)*8,2
                    *= vidmem0
                    ;!bin "gfx/hires_top.prg",(13*40),0x1F40+2
;     0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35  36  37  38  39
!by $70,$00,$00,$00,$00,$00,$00,$00,$00,$00,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$70,$00,$00,$50,$30,$D0,$F0,$A0,$80,$70,$70,$70,$70,$70 ; 0
!by $F0,$00,$1B,$13,$13,$13,$13,$13,$1B,$00,$F0,$00,$F0,$F0,$F0,$F0,$F0,$F0,$00,$F0,$F0,$F0,$F0,$F0,$F0,$00,$F0,$00,$1B,$10,$30,$D0,$F0,$A0,$80,$00,$F0,$F0,$F0,$F0 ; 1
!by $A0,$A0,$B0,$1B,$B0,$13,$B0,$1B,$B0,$00,$10,$00,$A0,$A0,$A0,$A0,$A0,$10,$00,$A0,$A0,$A0,$A0,$A0,$10,$00,$A0,$A0,$B0,$13,$00,$D0,$F0,$A0,$10,$00,$A0,$A0,$A0,$A0 ; 2
!by $80,$80,$80,$B0,$00,$13,$00,$B0,$00,$10,$13,$10,$80,$80,$80,$80,$10,$13,$10,$80,$80,$80,$80,$10,$13,$10,$80,$80,$00,$13,$00,$D0,$F0,$10,$13,$10,$80,$80,$80,$80 ; 3
!by $20,$20,$20,$20,$00,$13,$00,$00,$10,$1B,$B0,$1B,$10,$00,$00,$10,$1B,$B0,$1B,$10,$00,$00,$10,$1B,$B0,$1B,$10,$20,$00,$13,$00,$00,$10,$1B,$B0,$1B,$10,$20,$20,$20 ; 4
!by $90,$90,$90,$00,$00,$13,$00,$1B,$13,$B0,$00,$B0,$13,$10,$1B,$13,$B0,$00,$B0,$13,$10,$1B,$13,$B0,$00,$B0,$13,$10,$00,$13,$00,$1B,$13,$B0,$1B,$13,$13,$10,$90,$90 ; 5
!by $60,$60,$60,$00,$1B,$13,$00,$B0,$1B,$10,$00,$10,$1B,$B0,$B0,$1B,$10,$10,$00,$13,$B0,$B0,$1B,$10,$10,$00,$13,$B0,$1B,$13,$00,$B0,$1B,$10,$B0,$B0,$B0,$B0,$00,$60 ; 6
!by $B0,$B0,$B0,$B0,$B0,$1B,$10,$00,$B0,$1B,$13,$1B,$B0,$00,$00,$B0,$1B,$1B,$00,$13,$00,$B0,$B0,$1B,$1B,$00,$13,$00,$B0,$1B,$10,$00,$B0,$1B,$13,$1B,$00,$00,$00,$B0 ; 7
!by $40,$40,$40,$40,$40,$B0,$B0,$B0,$40,$B0,$1B,$B0,$40,$40,$40,$40,$B0,$B0,$00,$13,$00,$40,$40,$B0,$B0,$00,$13,$00,$E0,$B0,$B0,$00,$F0,$B0,$1B,$B0,$40,$4A,$4A,$40 ; 8
!by $E0,$E0,$E0,$E0,$E0,$E0,$00,$E0,$E0,$00,$B0,$E0,$E0,$E0,$E0,$E0,$E0,$00,$1B,$1B,$00,$E0,$E0,$E0,$00,$1B,$1B,$00,$E0,$50,$00,$00,$F0,$00,$B0,$E0,$E0,$AE,$AE,$E0 ; 9
!by $50,$50,$50,$50,$50,$50,$50,$50,$50,$00,$50,$50,$50,$50,$50,$50,$50,$50,$B0,$B0,$50,$50,$50,$50,$50,$B0,$B0,$50,$E0,$50,$30,$D0,$F0,$00,$80,$50,$50,$50,$50,$50 ; 10
!by $30,$30,$34,$34,$34,$34,$34,$34,$30,$30,$34,$34,$34,$34,$34,$34,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$E0,$50,$30,$D0,$F0,$A0,$80,$30,$30,$30,$30,$30 ; 11
!by $30,$30,$36,$36,$36,$36,$36,$36,$30,$30,$36,$36,$36,$36,$36,$36,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$30,$E0,$50,$30,$D0,$F0,$A0,$80,$30,$30,$30,$30,$30 ; 12
                    *= charset1
                    !bin "gfx/charset.chr"
                    *= charset1 + (8*0x80)
                    !bin "gfx/shineandspider-chars.bin"
                    *= vidmem1
                    !fi (13*40), " "
                    !bin "gfx/petscii_bottom.bin",(12*40)
                    *= sprite_data
                    !bin "gfx/bar_sprites.bin"
colram_data:        !bin "gfx/colramdata.bin"
scrolltext:
                    !src "scrolltext.asm"
; ==============================================================================
                    *= code_start
                    lda #0x7F
                    sta 0xDC0D
                    lda #MEMCFG
                    sta 0x01
                    lda #0x0B
                    sta 0xD011
                    lda #CYAN
                    sta 0xD020
                    jmp init_code
; ==============================================================================
                    !zone IRQ
                    NUM_IRQS = 0x10
irq:                !if MEMCFG = 0x35 {
                        sta .irq_savea+1
                        stx .irq_savex+1
                        sty .irq_savey+1
                        lda 0x01
                        sta .irq_save0x01+1
                        lda #0x35
                        sta 0x01
                    }
irq_next:           jmp irq00
irq_end:            lda 0xD012
-                   cmp 0xD012
                    beq -
.irq_index:         ldx #0
                    lda irq_tab_lo,x
                    sta irq_next+1
                    lda irq_tab_hi,x
                    sta irq_next+2
                    lda irq_lines,x
                    sta 0xD012
                    inc .irq_index+1
                    lda .irq_index+1
                    cmp #NUM_IRQS
                    bne +
                    lda #0
                    sta .irq_index+1
+                   asl 0xD019
                    !if MEMCFG = 0x37 {
                        jmp 0xEA31
                    }
                    !if MEMCFG = 0x36 {
                        jmp 0xEA81
                    }
                    !if MEMCFG = 0x35 {
.irq_save0x01:          lda #0x35
                        sta 0x01
                        cmp #0x36
                        beq +
.irq_savea:             lda #0
.irq_savex:             ldx #0
.irq_savey:             ldy #0
                        rti
+                       jmp 0xEA81
                    }

irq00:              !if DEBUG=1 {
                        inc 0xD020
                    }
                    lda #d018_val0
                    sta 0xD018
music_play_2x:      bit 0x0000
                    !if DEBUG=1 {
                        dec 0xD020
                    }
                    jsr scroller
                    +flag_set flag_irq_top
                    jmp irq_end

irq01:              nop
                    nop
                    nop
                    nop
                    inc 0xCFFF
                    dec 0xCFFF
                    lda 0xDD04
                    and #7
                    eor #7
                    sta *+4
                    bpl *+2
                    lda #0xA9
                    lda #0xA9
                    lda 0xEAA5
                    nop
                    nop
                    nop
                    nop
                    nop
                    lda #0x3B
                    ldy #YELLOW
                    sta 0xD011
                    sty 0xD020
                    jmp irq_end

irq02:              ldx #2
-                   dex
                    bpl -
                    nop
                    lda #LIGHT_GREY
                    sta 0xD020
                    jmp irq_end

irq03:              ldx #2
-                   dex
                    bpl -
                    nop
                    lda #PINK
                    sta 0xD020
                    jmp irq_end

irq04:              ldx #2
-                   dex
                    bpl -
                    nop
                    lda #ORANGE
                    sta 0xD020
                    jmp irq_end

irq05:              ldx #2
-                   dex
                    bpl -
                    lda #RED
                    sta 0xD020
                    jmp irq_end

irq06:              ldx #2
-                   dex
                    bpl -
                    nop
                    lda #BROWN
                    sta 0xD020
                    jmp irq_end

irq07:              ldx #2
-                   dex
                    bpl -
                    nop
                    lda #BLUE
                    sta 0xD020
                    jmp irq_end

irq08:              ldx #2
-                   dex
                    bpl -
                    nop
                    lda #DARK_GREY
                    sta 0xD020
                    jmp irq_end

irq09:              ldx #2
-                   dex
                    bpl -
                    nop
                    lda #PURPLE
                    sta 0xD020
                    jmp irq_end

irq10:              ldx #2
-                   dex
                    bpl -
                    nop
                    lda #LIGHT_BLUE
                    sta 0xD020
                    jmp irq_end

irq11:              ldx #2
-                   dex
                    bpl -
                    nop
                    lda #GREEN
                    sta 0xD020
                    jmp irq_end

irq12:              ldx #2
-                   dex
                    bpl -
                    nop
                    lda #CYAN
                    sta 0xD020
                    lda #BLACK
                    sta 0xD021
                    jmp irq_end

irq13:              ldx #14
-                   dex
                    bpl -
                    nop
                    lda #0x1B
                    sta 0xD011
                    lda #d018_val1
                    sta 0xD018
                    jsr sprites_bar_setup
                    !if DEBUG = 1 {
                        dec 0xD020
                    }
music_play:         bit 0x0000
                    !if DEBUG = 1 {
                        inc 0xD020
                    }
                    jsr scroller_colcycle
                    jsr col_icons
                    jmp irq_end

irq14:              lda #CYAN
                    sta 0xD021
                    lda #0x93
                    sta 0xD011
enable_cursor_place:
                    jsr cursor_place
enable_cursor_anim:
                    jsr cursor_anim
enable_loadbar:     bit print_loadbar
enable_timer:       bit timer_increase
enable_check_end:   bit timer_check_end
enable_song_end:    bit song_end
enable_song_fade:   bit song_fadeout
                    jsr print_timer
                    jsr colorletters
                    jsr colorlovers
                    +flag_set flag_irq_ready
                    jmp irq_end

irq15:              jsr sprites_multiplex
                    lda #0x1B
                    sta 0xD011
                    jmp irq_end

irq_tab_lo:         !byte <irq00, <irq01, <irq02, <irq03
                    !byte <irq04, <irq05, <irq06, <irq07
                    !byte <irq08, <irq09, <irq10, <irq11
                    !byte <irq12, <irq13, <irq14, <irq15
irq_tab_hi:         !byte >irq00, >irq01, >irq02, >irq03
                    !byte >irq04, >irq05, >irq06, >irq07
                    !byte >irq08, >irq09, >irq10, >irq11
                    !byte >irq12, >irq13, >irq14, >irq15
irq_lines:          !byte IRQ_LINE00, IRQ_LINE01, IRQ_LINE02, IRQ_LINE03
                    !byte IRQ_LINE04, IRQ_LINE05, IRQ_LINE06, IRQ_LINE07
                    !byte IRQ_LINE08, IRQ_LINE09, IRQ_LINE10, IRQ_LINE11
                    !byte IRQ_LINE12, IRQ_LINE13, IRQ_LINE14, IRQ_LINE15
; ==============================================================================
init_code:          jsr install
                    jsr init_timer
                    jsr init_nmi
                    jsr init_vic
                    jsr init_irq
                    jsr print_window
                    jsr cursor_place
                    jmp mainloop

init_irq:           lda irq_lines
                    sta 0xD012
                    lda #<irq
                    sta 0x0314
                    !if MEMCFG = 0x35 {
                        sta 0xFFFE
                    }
                    lda #>irq
                    sta 0x0315
                    !if MEMCFG = 0x35 {
                        sta 0xFFFF
                    }
                    lda #0x0B
                    sta 0xD011
                    lda #0x01
                    sta 0xD019
                    sta 0xD01A
                    rts

init_timer:         lda #0x00
init_cia2_a:        cmp 0xD012
                    bne init_cia2_a
                    ldy #0x08
                    sty 0xDD04
-                   dey
                    bne -
                    sty 0xDD05
                    sta 0xDD0E,y
                    lda #0x11
                    cmp 0xD012
                    sty 0xD015
                    bne init_cia2_a
                    rts

init_nmi:           lda #<nmi
                    sta 0x0318
                    !if MEMCFG = 0x35 {
                        sta 0xFFFA
                    }
                    lda #>nmi
                    sta 0x0319
                    !if MEMCFG = 0x35 {
                        sta 0xFFFB
                    }
                    rts

init_vic:           lda #dd00_val0
                    sta 0xDD00
                    lda #d018_val0
                    sta 0xD018

                    ldx #0
-                   lda colram_data+0x000,x
                    sta 0xD800+0x000,x
                    lda colram_data+0x100,x
                    sta 0xD800+0x100,x
                    lda colram_data+0x200,x
                    sta 0xD800+0x200,x
                    lda colram_data+0x2E8,x
                    sta 0xD800+0x2E8,x
                    dex
                    bne -

                    jsr scroller_prepare

                    lda #BLACK
                    sta 0xD021

                    lda #0
                    sta vicbank0+0x3FFF
                    rts


init_music:         lda #0
init_addr:          jsr 0x0000
                    ldx #2
init_time:          lda 0x0000,x
                    sta timer_current,x
                    dex
                    bpl init_time
                    jsr wait_irq_top
                    lda #ENABLE
                    sta music_play
init_addr_2x:       lda #0
                    beq +
                    jsr wait_irq_top
                    lda #ENABLE
                    sta music_play_2x
+                   lda #ENABLE
                    sta enable_timer
                    sta enable_check_end
                    rts
; ==============================================================================
                    !zone MAINLOOP
mainloop:           jsr wait_irq
loadflag:           lda #1
                    beq +
                    lda #0
                    sta loadflag+1
                    jsr song_disable
                    jsr load_song
                    jsr init_music
+
enable_keyboard:    bit keyboard_get
enable_print_win:   bit print_window
                    jmp mainloop
; ==============================================================================
load_song:          lda #DISABLE
                    sta enable_timer
                    sta enable_check_end
                    sta enable_song_end
                    sta enable_song_fade
                    lda #0x0F
                    sta volume
                    lda #50
                    sta framecounter
                    lda #'0'
                    sta timer_current
                    sta timer_current+1
                    sta timer_current+2
                    sta timer_init
                    sta timer_init+1
                    sta timer_init+2
                    lda #ENABLE
                    sta enable_loadbar
                    ldx songtoload
                    stx songselected
                    lda song_windowpos,x
                    sta songwindowtop
                    jsr cursor_delete
                    lda #DISABLE
                    sta enable_cursor_place
                    sta enable_cursor_anim
                    lda song_cursorpos,x
                    sta cursorpos
                    lda songplaylist,x
                    tax
                    lda songtimes_lo,x
                    sta init_time+1
                    lda songtimes_hi,x
                    sta init_time+2
                    lda songplay_lo,x
                    sta music_play+1
                    sta music_play_2x+1
                    lda songplay_hi,x
                    sta music_play+2
                    sta music_play_2x+2
                    lda songinit_hi,x
                    sta init_addr+2
                    lda songinit_lo,x
                    sta init_addr+1
                    lda songspeedlist,x
                    sta init_addr_2x+1
                    lda songlooplist,x
                    sta song_end+1
                    lda songfade_lo,x
                    sta song_fadeout+1
                    sta song_fadeout_dest+1
                    lda songfade_hi,x
                    sta song_fadeout+2
                    sta song_fadeout_dest+2
                    txa
                    jsr hex2text
                    sta filename
                    stx filename+1
                    lda #0x00
                    sta loadaddrlo
                    sta loadaddrhi
                    ldx #<filename
                    ldy #>filename
                    jsr loadcompd
                    bcc +
                    jmp *
+                   lda #ENABLE
                    sta enable_cursor_place
                    sta enable_cursor_anim
                    sta enable_keyboard
                    sta enable_print_win
                    lda #DISABLE
                    sta enable_loadbar
                    jsr reset_loadbar
                    rts
filename:           !tx "00"
; ==============================================================================
                    !zone NMI
nmi:                lda #0x37               ; restore 0x01 standard value
                    sta 0x01
                    lda #0                  ; if AR/RR present
                    sta 0xDE00              ; reset will lead to menu
                    jmp 0xFCE2              ; reset
; ==============================================================================
                    !zone WAIT
wait_irq:           +flag_clear flag_irq_ready
.wait_irq:          +flag_get flag_irq_ready
                    beq .wait_irq
                    rts
wait_irq_top:       +flag_clear flag_irq_top
.wait_irq_top:      +flag_get flag_irq_top
                    beq .wait_irq_top
                    rts
; ==============================================================================
                    !zone HEX2TEXT
hex2text:           sta .savea+1
                    and #%00001111
                    tax
                    lda .hextab,x
                    sta .low_nibble+1
.savea:             lda #0
                    lsr
                    lsr
                    lsr
                    lsr
                    tax
                    lda .hextab,x
.low_nibble:        ldx #0
                    rts
.hextab:            !tx "0123456789ABCDEF"
; ==============================================================================
                    !zone KEYBOARD
keyboard_get:       !if DEBUG=1 { dec 0xD020 }
                    jsr keyscan
                    jsr getin
                    bne +
                    jmp .key_exit
+                   cmp #KEY_CRSRUP
                    bne +
                    jmp .crsr_up
+                   cmp #KEY_CRSRDOWN
                    bne +
                    jmp .crsr_down
+                   cmp #KEY_CRSRRIGHT
                    bne +
                    jmp .crsr_right
+                   cmp #KEY_CRSRLEFT
                    bne +
                    jmp .crsr_left
+                   cmp #KEY_RETURN
                    bne +
                    jmp .return
+                   cmp #KEY_STOP
                    bne +
                    jmp .key_exit ; pause
+
.key_exit:          !if DEBUG=1 { inc 0xD020 }
                    rts
.crsr_up:           lda cursorpos
                    beq +
                    jsr cursor_delete
                    dec cursorpos
                    dec songselected
-                   rts
+                   lda songwindowtop
                    beq -
                    dec songwindowtop
                    dec songselected
                    lda #ENABLE
                    sta enable_print_win
                    rts
.crsr_down:         lda songselected
                    cmp #38
                    bne +
                    rts
+                   lda cursorpos
                    cmp #9
                    beq +
                    jsr cursor_delete
                    inc cursorpos
                    inc songselected
-                   rts
+                   lda songwindowtop
                    cmp #38-9
                    beq -
                    inc songwindowtop
                    inc songselected
                    lda #ENABLE
                    sta enable_print_win
                    rts

.crsr_right:        lda songselected
                    cmp #30
                    bcs ++
                    adc #10
                    sta songselected
                    cmp #39
                    bne +
                    dec songselected
+                   jsr cursor_delete
                    ldx songselected
                    lda song_cursorpos,x
                    sta cursorpos
                    lda song_windowpos,x
                    sta songwindowtop
                    lda #ENABLE
                    sta enable_print_win
++                  rts

.crsr_left:         lda songselected
                    cmp #10
                    bcc +
                    sbc #10
                    sta songselected
                    jsr cursor_delete
                    ldx songselected
                    lda song_cursorpos,x
                    sta cursorpos
                    lda song_windowpos,x
                    sta songwindowtop
                    lda #ENABLE
                    sta enable_print_win
+                   rts

.return:            lda songselected
                    sta songtoload
                    sta songplaying
                    lda #DISABLE
                    sta enable_keyboard
                    lda #1
                    sta loadflag+1
                    rts
; ==============================================================================
                    !zone TIMER
timer_increase:     dec framecounter
                    beq +
                    rts
+                   lda timer_init+2
                    cmp #0x39
                    bne +++
                    lda #0x2F
                    sta timer_init+2
                    lda timer_init+1
                    cmp #0x39
                    bne ++
                    lda #0x2F
                    sta timer_init+1
                    lda timer_init
                    cmp #0x39
                    bne +
                    lda #0x2F
                    sta timer_init
+                   inc timer_init
++                  inc timer_init+1
+++                 inc timer_init+2
                    lda #50
                    sta framecounter
                    rts
framecounter:       !byte 50

timer_check_end:    lda timer_init+2
                    cmp timer_current+2
                    bne +
                    lda timer_init+1
                    cmp timer_current+1
                    bne +
                    lda timer_init
                    cmp timer_current
                    bne +
                    lda #DISABLE
                    sta enable_timer
                    lda #DISABLE
                    sta enable_check_end
                    lda #ENABLE
                    sta enable_song_end
+                   rts
; ==============================================================================
                    !zone SONGSCODE
song_end:           lda #0x00
                    bne ++
                    ldx songplaying
                    inx
                    cpx #39
                    bne +
                    ldx #0
+                   stx songtoload
                    stx songplaying
                    lda #1
                    sta loadflag+1
                    rts
++                  lda #ENABLE
                    sta enable_song_fade
                    lda #DISABLE
                    sta enable_song_end
                    sta enable_keyboard
                    rts

song_fadeout:       lda 0x0000
                    and #0xF0
                    ora volume
song_fadeout_dest:  sta 0x0000
.enable_delay:      jmp .fade_delay
                    ldx volume
                    lda fade_curve,x
                    sta .fade_delay+1
                    lda #ENABLE_JMP
                    sta .enable_delay
                    dex
                    bpl +
                    lda #DISABLE
                    sta enable_song_fade
                    lda #ENABLE
                    sta enable_song_end
                    lda #0
                    sta song_end+1
                    ldx #0x0F
+                   stx volume
                    rts
.fade_delay:        lda #0
                    beq +
                    dec .fade_delay+1
                    rts
+                   lda #DISABLE
                    sta .enable_delay
                    rts
fade_curve:         !byte 0x00, 0x30, 0x30, 0x28, 0x28, 0x28, 0x20, 0x20
                    !byte 0x18, 0x18, 0x10, 0x10, 0x08, 0x08, 0x08, 0x08
volume:             !byte 0x0F

song_disable:       lda #DISABLE
                    sta music_play
                    sta music_play_2x
                    lda #0
                    sta 0xD418
                    rts
; ==============================================================================
                    !zone CURSOR
                    CRSR_CHAR = 64
                    CRSR_CHAR_INV = 192
                    CRSR_ANIM_SPEED = 6
cursor_place:       ldx cursorpos
                    lda cursorvidmem_lo,x
                    sta .crsr_vid_dest+1
                    lda cursorvidmem_hi,x
                    sta .crsr_vid_dest+2
.crsr_char_mod:     lda #CRSR_CHAR
.crsr_vid_dest:     sta 0x0000
                    rts

cursor_anim:        lda #CRSR_ANIM_SPEED
                    beq +
                    dec cursor_anim+1
                    rts
+                   lda #CRSR_ANIM_SPEED
                    sta cursor_anim+1
                    lda .crsr_char_mod+1
                    cmp #0x20
                    beq +
                    eor #(CRSR_CHAR XOR CRSR_CHAR_INV)
                    sta .crsr_char_mod+1
+                   jmp .crsr_char_mod

cursor_delete:      lda #0x20
                    jmp .crsr_vid_dest

cursorpos:          !byte 0x00
cursorvidmem_lo:    !for i, 0, 9 {
                        !byte <(vidmem1+0x0230+(i*40))
                    }
cursorvidmem_hi:    !for i, 0, 9 {
                        !byte >(vidmem1+0x0230+(i*40))
                    }
; ==============================================================================
                    !zone PRINT
print_window:       lda songwindowtop
                    sta .current_index
                    clc
                    adc #10
                    sta .cmp_end+1
                    lda songplaying
                    sta .cmp_playing+1
                    lda .current_index
.loop:              tax
                    lda songplaylist,x
                    tax
                    lda songtitles_lo,x
                    sta .src+1
                    lda songtitles_hi,x
                    sta .src+2
.vidmempointer:     ldy #0
                    lda songvidmem_lo,y
                    sta .dest+1
                    lda songvidmem_hi,y
                    sta .dest+2
                    lda songcolmem_lo,y
                    sta .coldest+1
                    lda songcolmem_hi,y
                    sta .coldest+2
                    lda .current_index
.cmp_playing:       cmp #0
                    bne +
                    ldx #LIGHT_GREEN
                    !byte 0x2C
+                   ldx #YELLOW
                    ldy #25
-                   txa
.coldest:           sta 0x0000,y
.src:               lda 0x0000,y
.dest:              sta 0x0000,y
                    dey
                    bpl -
                    inc .vidmempointer+1
                    inc .current_index
                    lda .current_index
.cmp_end:           cmp #0
                    bne .loop
                    lda #0
                    sta .vidmempointer+1
                    lda songwindowtop
                    cmp #30
                    bne +
                    lda #0x20
                    ldy #25
-                   sta vidmem1+0x0231+(9*40),y
                    dey
                    bpl -
+                   lda #DISABLE
                    sta enable_print_win
                    rts
.current_index:     !byte 0x00

                    LOADBAR_FIRST_CHAR = 247
                    LOADBAR_LAST_CHAR = 255
print_loadbar:
.xsav:              ldx #0
                    cpx #18
                    bne .char
                    rts
.char:              lda #LOADBAR_FIRST_CHAR
                    sta vidmem1+0x0231+(10*40)+9,x
                    inc .char+1
                    lda .char+1
                    cmp #0
                    bne +
                    lda #LOADBAR_FIRST_CHAR
                    sta .char+1
                    inc .xsav+1
+
                    rts

reset_loadbar:      lda #LOADBAR_FIRST_CHAR
                    sta .char+1
                    lda #0
                    sta .xsav+1
                    lda #0x20
                    ldx #17
-                   sta vidmem1+0x0231+(10*40)+9,x
                    dex
                    bpl -
                    rts

print_timer:        ldx #2
-                   lda timer_init,x
                    sta vidmem1+0x0231+(0*40)+35,x
                    lda timer_current,x
                    sta vidmem1+0x0231+(1*40)+35,x
                    dex
                    bpl -
                    rts
timer_init:         !scr "000"
timer_current:      !scr "000"
; ==============================================================================
                    !zone SONGSDATA
                    *= songdata
                    ;!scr"01234567890123456789012345"
songtitles:         !scr "64K Memory Lane           "         ; 00
                    !scr "Anticipation              "         ; 01
                    !scr "Boreal Sunrise            "         ; 02
                    !scr "Bring mich nach Hause, Sp."         ; 03
                    !scr "Cute Bundle of Fluff      "         ; 04
                    !scr "Defier of Deadlines       "         ; 05
                    !scr "Euphoria                  "         ; 06
                    !scr "Fireflies                 "         ; 07
                    !scr "Flowing Slowly (extended) "         ; 08
                    !scr "Glacial Blues             "         ; 09
                    !scr "Homecoming                "         ; 10
                    !scr "Irrlicht                  "         ; 11
                    !scr "Jaded                     "         ; 12
                    !scr "Kicks Like a M.U.L.E.     "         ; 13
                    !scr "Little Heart              "         ; 14
                    !scr "Maniac Marstall (LuheCon) "         ; 15
                    !scr "Mayday! in Monsterland    "         ; 16
                    !scr "MuckelSID                 "         ; 17
                    !scr "Nappy Go Lucky            "         ; 18
                    !scr "Nightlights               "         ; 19
                    !scr "Notch It                  "         ; 20
                    !scr "Oakyard Memories          "         ; 21
                    !scr "Pantheon                  "         ; 22
                    !scr "Pompeii                   "         ; 23
                    !scr "Quietus                   "         ; 24
                    !scr "Redshift Infinite         "         ; 25
                    !scr "Rogaland Revisited        "         ; 26
                    !scr "Selenopolis 2.0           "         ; 27
                    !scr "Sparkle                   "         ; 28
                    !scr "Supremacy Intro           "         ; 29
                    !scr "Tao Tao                   "         ; 30
                    !scr "Tidal Waves               "         ; 31
                    !scr "Transmission 64           "         ; 32
                    !scr "Unity                     "         ; 33
                    !scr "Ursa Minor                "         ; 34
                    !scr "Valiant Adventurer 1983   "         ; 35
                    !scr "Welc0me Aboard            "         ; 36
                    !scr "Wieselflink               "         ; 37
                    !scr "Wintry Haze               "         ; 38

songtitles_lo:      !for i, 0, 38 {
                        !byte <(songtitles+(i*26))
                    }
songtitles_hi:      !for i, 0, 38 {
                        !byte >(songtitles+(i*26))
                    }
songvidmem_lo:      !for i, 0, 9 {
                        !byte <(vidmem1+0x0231+(i*40))
                    }
songvidmem_hi:      !for i, 0, 9 {
                        !byte >(vidmem1+0x0231+(i*40))
                    }
songcolmem_lo:      !for i, 0, 9 {
                        !byte <(0xD800+0x0231+(i*40))
                    }
songcolmem_hi:      !for i, 0, 9 {
                        !byte >(0xD800+0x0231+(i*40))
                    }
songplaylist:
                    !byte 26, 16, 27, 2, 12, 22, 10, 37
                    !byte 28, 11, 7, 24, 31, 21, 0, 19
                    !byte 18, 8, 6, 15, 25, 38, 14, 23
                    !byte 32, 1, 9, 30, 34, 13, 17, 5
                    !byte 20, 36, 4, 33, 29, 35, 3

                    !if DEBUG=1 {
                        *= songplaylist
                        !for i, 0, 38 {
                            !byte i
                        }
                    }
songplaylist_end:
songspeedlist:
                    !byte 0, 1, 0, 0, 0, 1, 1, 0
                    !byte 0, 0, 1, 0, 0, 0, 0, 0
                    !byte 0, 0, 0, 0, 0, 0, 0, 1
                    !byte 0, 0, 0, 1, 0, 0, 0, 0
                    !byte 0, 0, 0, 0, 0, 0, 0

songplaying:        !byte 0
songtoload:         !byte 0
songwindowtop:      !byte 0
songselected:       !byte 0
songinit_lo:
                    !byte <0x1000, <0x10B8, <0x1000, <0x1000, <0x1000, <0x10B8, <0x10B8, <0x1000
                    !byte <0x1000, <0x1000, <0x10B8, <0x1000, <0x1000, <0x1000, <0x1000, <0x1000
                    !byte <0x1000, <0x1000, <0x1000, <0x1000, <0x1000, <0x1000, <0x1000, <0x10B8
                    !byte <0x1000, <0x1000, <0x1000, <0x10B8, <0x1000, <0x1000, <0x1000, <0x1000
                    !byte <0x1000, <0x1000, <0x1000, <0x1000, <0x1000, <0x1000, <0x1000
songinit_hi:
                    !byte >0x1000, >0x10B8, >0x1000, >0x1000, >0x1000, >0x10B8, >0x10B8, >0x1000
                    !byte >0x1000, >0x1000, >0x10B8, >0x1000, >0x1000, >0x1000, >0x1000, >0x1000
                    !byte >0x1000, >0x1000, >0x1000, >0x1000, >0x1000, >0x1000, >0x1000, >0x10B8
                    !byte >0x1000, >0x1000, >0x1000, >0x10B8, >0x1000, >0x1000, >0x1000, >0x1000
                    !byte >0x1000, >0x1000, >0x1000, >0x1000, >0x1000, >0x1000, >0x1000
songplay_lo:
                    !byte <0x1003, <0x10CF, <0x1003, <0x1003, <0x1003, <0x10CF, <0x10CF, <0x1003
                    !byte <0x1003, <0x1003, <0x10CF, <0x1003, <0x1003, <0x1003, <0x1003, <0x1003
                    !byte <0x1003, <0x1003, <0x1003, <0x1003, <0x1003, <0x1003, <0x1003, <0x10CF
                    !byte <0x1003, <0x1003, <0x1003, <0x10CF, <0x1003, <0x1003, <0x1003, <0x1003
                    !byte <0x1003, <0x1003, <0x1003, <0x1003, <0x1003, <0x1003, <0x1003
songplay_hi:
                    !byte >0x1003, >0x10CF, >0x1003, >0x1003, >0x1003, >0x10CF, >0x10CF, >0x1003
                    !byte >0x1003, >0x1003, >0x10CF, >0x1003, >0x1003, >0x1003, >0x1003, >0x1003
                    !byte >0x1003, >0x1003, >0x1003, >0x1003, >0x1003, >0x1003, >0x1003, >0x10CF
                    !byte >0x1003, >0x1003, >0x1003, >0x10CF, >0x1003, >0x1003, >0x1003, >0x1003
                    !byte >0x1003, >0x1003, >0x1003, >0x1003, >0x1003, >0x1003, >0x1003

songfade_lo:
                    !byte 0xDE, 0xFE, 0xF8, 0xDE, 0xA6, 0xFE, 0xFE, 0xA6
                    !byte 0xF8, 0xFE, 0xFE, 0x9C, 0xFE, 0xDE, 0xDE, 0xFE
                    !byte 0xFE, 0xDE, 0xDE, 0xFE, 0xDE, 0xFE, 0x15, 0x55
                    !byte 0xDE, 0xFE, 0xA6, 0xFE, 0x94, 0xDE, 0xFE, 0xDE
                    !byte 0xDE, 0xDE, 0xDE, 0xFE, 0xDE, 0xDE, 0xDE
songfade_hi:
                    !byte 0x10, 0x12, 0x11, 0x10, 0x11, 0x12, 0x12, 0x11
                    !byte 0x11, 0x11, 0x12, 0x11, 0x11, 0x10, 0x10, 0x11
                    !byte 0x11, 0x10, 0x10, 0x11, 0x10, 0x11, 0x11, 0x12
                    !byte 0x10, 0x11, 0x11, 0x12, 0x11, 0x10, 0x11, 0x10
                    !byte 0x10, 0x10, 0x10, 0x11, 0x10, 0x10, 0x10

songtimes:
                    !scr "180"
                    !scr "161"
                    !scr "140"
                    !scr "105"
                    !scr "113"
                    !scr "150"
                    !scr "123"
                    !scr "211"
                    !scr "059"
                    !scr "215"
                    !scr "156"
                    !scr "114"
                    !scr "195"
                    !scr "307"
                    !scr "184"
                    !scr "150"
                    !scr "171"
                    !scr "046"
                    !scr "128"
                    !scr "248"
                    !scr "055"
                    !scr "213"
                    !scr "106"
                    !scr "222"
                    !scr "177"
                    !scr "219"
                    !scr "050"
                    !scr "241"
                    !scr "052"
                    !scr "063"
                    !scr "096"
                    !scr "249"
                    !scr "198"
                    !scr "134"
                    !scr "058"
                    !scr "174"
                    !scr "173"
                    !scr "172"
                    !scr "223"

songtimes_lo:       !for i, 0, 38 {
                        !byte <(songtimes+(i*3))
                    }
songtimes_hi:       !for i, 0, 38 {
                        !byte >(songtimes+(i*3))
                    }
songlooplist:
                    !byte 1, 1, 1, 1, 1, 0, 0, 0
                    !byte 1, 1, 0, 1, 1, 1, 1, 1
                    !byte 1, 1, 1, 0, 1, 0, 0, 0
                    !byte 1, 1, 1, 0, 1, 0, 1, 1
                    !byte 1, 1, 1, 0, 0, 0, 1

song_windowpos:     !for i, 0, 9 {
                        !byte 0
                    }
                    !for i, 10, 19 {
                        !byte 10
                    }
                    !for i, 20, 29 {
                        !byte 20
                    }
                    !for i, 30, 38 {
                        !byte 30
                    }

song_cursorpos:     !for i, 0, 9 {
                        !byte i
                    }
                    !for i, 0, 9 {
                        !byte i
                    }
                    !for i, 0, 9 {
                        !byte i
                    }
                    !for i, 0, 8 {
                        !byte i
                    }
; ==============================================================================
                    !zone SPRITES
                    SPRITES_BAR_X_START = (28*8)+0x18
                    SPRITES_BAR_Y_START = 0xF8
sprites_bar_setup:  ldx #sprite_base
                    stx vidmem0+0x3F8+2
                    stx vidmem1+0x3F8+2
                    inx
                    stx vidmem0+0x3F8+1
                    stx vidmem1+0x3F8+1
                    inx
                    stx vidmem0+0x3F8+3
                    stx vidmem1+0x3F8+3
                    stx vidmem0+0x3F8+4
                    stx vidmem1+0x3F8+4
                    stx vidmem0+0x3F8+6
                    stx vidmem1+0x3F8+6
                    inx
                    stx vidmem0+0x3F8
                    stx vidmem1+0x3F8
                    stx vidmem0+0x3F8+5
                    stx vidmem1+0x3F8+5
                    inx
                    stx vidmem0+0x3F8+7
                    stx vidmem1+0x3F8+7
                    lda #BLACK
                    sta 0xD025
                    sta 0xD02E
                    lda #LIGHT_BLUE
                    sta 0xD029
                    lda #GREEN
                    sta 0xD02A
                    lda #LIGHT_GREEN
                    sta 0xD02B
                    lda #LIGHT_GREY
                    sta 0xD02C
                    lda #PINK
                    sta 0xD02D
                    lda #ORANGE
                    sta 0xD028
                    lda #CYAN
                    sta 0xD027

                    lda #%00000110
                    sta 0xD01C

                    lda #%10000000
                    sta 0xD01D

                    lda #SPRITES_BAR_Y_START
                    sta 0xD001
                    sta 0xD003
                    sta 0xD005
                    sta 0xD007
                    sta 0xD009
                    sta 0xD00B
                    sta 0xD00D
                    sta 0xD00F

                    lda #<(SPRITES_BAR_X_START+48)
                    sta 0xD000+2
                    lda #SPRITES_BAR_X_START
                    sta 0xD000+4
                    lda #<(SPRITES_BAR_X_START+8)
                    sta 0xD000+6
                    lda #<(SPRITES_BAR_X_START+16)
                    sta 0xD000
                    lda #<(SPRITES_BAR_X_START+24)
                    sta 0xD000+8
                    lda #<(SPRITES_BAR_X_START+32)
                    sta 0xD000+10
                    lda #<(SPRITES_BAR_X_START+40)
                    sta 0xD000+12
                    lda #<(SPRITES_BAR_X_START+8)
                    sta 0xD000+14

                    lda #0
                    sta 0xD01B

                    lda #%11111011
                    sta 0xD010

                    lda #%11111111
                    sta 0xD017
                    sta 0xD015
                    rts

sprites_multiplex:  lda #0x08
                    sta 0xD001
                    sta 0xD003
                    sta 0xD005
                    sta 0xD007
                    sta 0xD009
                    sta 0xD00B
                    sta 0xD00D
                    sta 0xD00F
                    rts
; ==============================================================================
                    !zone COLORLETTERS
                    COLORLETTERS_DELAY = 0xAF
                    COLORLETTERS_SPEED = 0x02

colorletters:       lda #COLORLETTERS_DELAY
                    beq +
                    dec colorletters+1
                    rts
+
.spd_chng:          lda #COLORLETTERS_SPEED
                    sta colorletters+1
enable_color_next:  jsr color_next
                    jsr color_get
.routine:           jsr 0x0000
.letter_done:       lda #0
                    beq +
                    lda #0
                    sta .letter_done+1
                    inc .letter_count+1
.letter_count:      lda #0
                    cmp #6
                    bne +
                    jsr .readfromtab
                    lda #0
                    sta .letter_count+1
                    lda #COLORLETTERS_DELAY
                    sta colorletters+1
+                   rts

.readfromtab:       ldx #5
.srclo:             lda .lettersrc_lo,x
                    sta .lettertab_lo,x
.srchi:             lda .lettersrc_hi,x
                    sta .lettertab_hi,x
                    dex
                    bpl .srclo
.repeat:            lda #3
                    bne +
                    lda #3
                    sta .repeat+1
                    lda #<.lettersrc_lo
                    sta .srclo+1
                    lda #>.lettersrc_lo
                    sta .srclo+2
                    lda #<.lettersrc_hi
                    sta .srchi+1
                    lda #>.lettersrc_hi
                    sta .srchi+2
                    rts
+                   clc
                    lda .srclo+1
                    adc #6
                    sta .srclo+1
                    lda .srclo+2
                    adc #0
                    sta .srclo+2
                    clc
                    lda .srchi+1
                    adc #6
                    sta .srchi+1
                    lda .srchi+2
                    adc #0
                    sta .srchi+2
                    dec .repeat+1
                    rts

color_next:         ldx #5
                    lda .lettertab_lo,x
                    sta .routine+1
                    lda .lettertab_hi,x
                    sta .routine+2
                    dex
                    bpl +
                    ldx #5
+                   stx color_next+1
                    lda #DISABLE
                    sta enable_color_next
                    rts

.lettertab_lo:      !byte <color_e, <color_l, <color_g1, <color_g0
                    !byte <color_o, <color_t
.lettertab_hi:      !byte >color_e, >color_l, >color_g1, >color_g0
                    !byte >color_o, >color_t

.lettersrc_lo:      !byte <color_t, <color_e, <color_o, <color_l
                    !byte <color_g0, <color_g1
                    !byte <color_g1, <color_g0, <color_l, <color_o
                    !byte <color_e, <color_t
                    !byte <color_t, <color_o, <color_g0, <color_g1
                    !byte <color_l, <color_e
                    !byte <color_e, <color_l, <color_g1, <color_g0
                    !byte <color_o, <color_t
.lettersrc_hi:      !byte >color_t, >color_e, >color_o, >color_l
                    !byte >color_g0, >color_g1
                    !byte >color_g1, >color_g0, >color_l, >color_o
                    !byte >color_e, >color_t
                    !byte >color_t, >color_o, >color_g0, >color_g1
                    !byte >color_l, >color_e
                    !byte >color_e, >color_l, >color_g1, >color_g0
                    !byte >color_o, >color_t

color_get:          ldx #14
                    lda .fade_tab,x
                    jsr color_set
                    dex
                    bpl +
                    lda #ENABLE
                    sta enable_color_next
                    lda #1
                    sta .letter_done+1
                    ldx #14
+                   stx color_get+1
                    rts
                    ; color_set: expects color in A
color_set:          asl
                    asl
                    asl
                    asl
                    sta .high_nib
                    lda .coltype0
                    and #0x0F
                    ora .high_nib
                    sta .coltype0
                    lda .coltype1
                    and #0x0F
                    ora .high_nib
                    sta .coltype1
                    lda .coltype2
                    and #0x0F
                    ora .high_nib
                    sta .coltype2
                    rts

color_t:            lda .coltype0
                    sta vidmem0+(7*40)+6
                    lda .coltype1
                    sta vidmem0+(1*40)+3
                    sta vidmem0+(1*40)+4
                    sta vidmem0+(1*40)+5
                    sta vidmem0+(1*40)+6
                    sta vidmem0+(1*40)+7
                    sta vidmem0+(2*40)+5
                    sta vidmem0+(3*40)+5
                    sta vidmem0+(4*40)+5
                    sta vidmem0+(5*40)+5
                    sta vidmem0+(6*40)+5
                    lda .coltype2
                    sta vidmem0+(1*40)+2
                    sta vidmem0+(1*40)+8
                    sta vidmem0+(2*40)+3
                    sta vidmem0+(2*40)+7
                    sta vidmem0+(6*40)+4
                    sta vidmem0+(7*40)+5
                    rts

color_o:            lda .coltype0
                    sta vidmem0+(2*40)+10
                    sta vidmem0+(3*40)+9
                    sta vidmem0+(3*40)+11
                    sta vidmem0+(4*40)+8
                    sta vidmem0+(4*40)+12
                    sta vidmem0+(5*40)+13
                    sta vidmem0+(6*40)+9
                    sta vidmem0+(6*40)+11
                    lda .coltype1
                    sta vidmem0+(3*40)+10
                    sta vidmem0+(5*40)+8
                    sta vidmem0+(5*40)+12
                    sta vidmem0+(7*40)+10
                    lda .coltype2
                    sta vidmem0+(4*40)+9
                    sta vidmem0+(4*40)+11
                    sta vidmem0+(5*40)+7
                    sta vidmem0+(6*40)+8
                    sta vidmem0+(6*40)+12
                    sta vidmem0+(7*40)+9
                    sta vidmem0+(7*40)+11
                    sta vidmem0+(8*40)+10
                    rts

color_g0:           lda .coltype0
                    sta vidmem0+(2*40)+17
                    sta vidmem0+(3*40)+16
                    sta vidmem0+(3*40)+18
                    sta vidmem0+(4*40)+15
                    sta vidmem0+(4*40)+19
                    sta vidmem0+(5*40)+20
                    sta vidmem0+(6*40)+16
                    sta vidmem0+(6*40)+17
                    lda .coltype1
                    sta vidmem0+(3*40)+17
                    sta vidmem0+(5*40)+15
                    sta vidmem0+(5*40)+19
                    sta vidmem0+(6*40)+19
                    sta vidmem0+(7*40)+19
                    sta vidmem0+(8*40)+19
                    lda .coltype2
                    sta vidmem0+(4*40)+16
                    sta vidmem0+(4*40)+18
                    sta vidmem0+(5*40)+14
                    sta vidmem0+(6*40)+15
                    sta vidmem0+(7*40)+16
                    sta vidmem0+(7*40)+17
                    sta vidmem0+(9*40)+18
                    sta vidmem0+(9*40)+19
                    rts

color_g1:           lda .coltype0
                    sta vidmem0+(2*40)+17+7
                    sta vidmem0+(3*40)+16+7
                    sta vidmem0+(3*40)+18+7
                    sta vidmem0+(4*40)+15+7
                    sta vidmem0+(4*40)+19+7
                    sta vidmem0+(5*40)+20+7
                    sta vidmem0+(6*40)+16+7
                    sta vidmem0+(6*40)+17+7
                    lda .coltype1
                    sta vidmem0+(3*40)+17+7
                    sta vidmem0+(5*40)+15+7
                    sta vidmem0+(5*40)+19+7
                    sta vidmem0+(6*40)+19+7
                    sta vidmem0+(7*40)+19+7
                    sta vidmem0+(8*40)+19+7
                    lda .coltype2
                    sta vidmem0+(4*40)+16+7
                    sta vidmem0+(4*40)+18+7
                    sta vidmem0+(5*40)+14+7
                    sta vidmem0+(6*40)+15+7
                    sta vidmem0+(7*40)+16+7
                    sta vidmem0+(7*40)+17+7
                    sta vidmem0+(9*40)+18+7
                    sta vidmem0+(9*40)+19+7
                    rts

color_l:            lda .coltype0
                    sta vidmem0+(1*40)+29
                    sta vidmem0+(7*40)+30
                    lda .coltype1
                    sta vidmem0+(2*40)+29
                    sta vidmem0+(3*40)+29
                    sta vidmem0+(4*40)+29
                    sta vidmem0+(5*40)+29
                    sta vidmem0+(6*40)+29
                    lda .coltype2
                    sta vidmem0+(1*40)+28
                    sta vidmem0+(6*40)+28
                    sta vidmem0+(7*40)+29
                    rts

color_e:            lda .coltype0
                    sta vidmem0+(2*40)+34
                    sta vidmem0+(3*40)+33
                    sta vidmem0+(3*40)+35
                    sta vidmem0+(4*40)+32
                    sta vidmem0+(4*40)+36
                    sta vidmem0+(5*40)+37
                    sta vidmem0+(6*40)+33
                    lda .coltype1
                    sta vidmem0+(3*40)+34
                    sta vidmem0+(5*40)+32
                    sta vidmem0+(5*40)+35
                    sta vidmem0+(5*40)+36
                    sta vidmem0+(7*40)+34
                    lda .coltype2
                    sta vidmem0+(4*40)+33
                    sta vidmem0+(4*40)+35
                    sta vidmem0+(5*40)+31
                    sta vidmem0+(5*40)+34
                    sta vidmem0+(6*40)+32
                    sta vidmem0+(7*40)+33
                    sta vidmem0+(7*40)+35
                    sta vidmem0+(8*40)+34
                    rts

.high_nib:          !byte 0x00
.coltype0:          !byte 0x00
.coltype1:          !byte 0x03
.coltype2:          !byte 0x0B

.fade_tab:          !byte WHITE, LIGHT_GREEN, CYAN, GREY
                    !byte PURPLE, RED, BROWN, BLACK
                    !byte BROWN, RED, PURPLE, GREY, CYAN
                    !byte LIGHT_GREEN, WHITE
; ==============================================================================
                    !zone COLORLOVERS
                    COLORLOVERS_SPEED = 0x02
colorlovers:        lda #1
                    beq +
                    dec colorlovers+1
                    rts
+                   lda #COLORLOVERS_SPEED
                    sta colorlovers+1
                    lda vidmem0+(11*40)+3
                    sta vidmem0+(11*40)+2
                    lda vidmem0+(11*40)+4
                    sta vidmem0+(11*40)+3
                    lda vidmem0+(11*40)+5
                    sta vidmem0+(11*40)+4
                    lda vidmem0+(11*40)+6
                    sta vidmem0+(11*40)+5
                    lda vidmem0+(11*40)+7
                    sta vidmem0+(11*40)+6
                    lda vidmem0+(11*40)+10
                    sta vidmem0+(11*40)+7
                    lda vidmem0+(11*40)+11
                    sta vidmem0+(11*40)+10
                    lda vidmem0+(11*40)+12
                    sta vidmem0+(11*40)+11
                    lda vidmem0+(11*40)+13
                    sta vidmem0+(11*40)+12
                    lda vidmem0+(11*40)+14
                    sta vidmem0+(11*40)+13
                    lda vidmem0+(11*40)+15
                    sta vidmem0+(11*40)+14
                    lda .tmp_top
                    sta vidmem0+(11*40)+15

                    lda vidmem0+(12*40)+3
                    sta vidmem0+(12*40)+2
                    lda vidmem0+(12*40)+4
                    sta vidmem0+(12*40)+3
                    lda vidmem0+(12*40)+5
                    sta vidmem0+(12*40)+4
                    lda vidmem0+(12*40)+6
                    sta vidmem0+(12*40)+5
                    lda vidmem0+(12*40)+7
                    sta vidmem0+(12*40)+6
                    lda vidmem0+(12*40)+10
                    sta vidmem0+(12*40)+7
                    lda vidmem0+(12*40)+11
                    sta vidmem0+(12*40)+10
                    lda vidmem0+(12*40)+12
                    sta vidmem0+(12*40)+11
                    lda vidmem0+(12*40)+13
                    sta vidmem0+(12*40)+12
                    lda vidmem0+(12*40)+14
                    sta vidmem0+(12*40)+13
                    lda vidmem0+(12*40)+15
                    sta vidmem0+(12*40)+14
                    lda .tmp_bot
                    sta vidmem0+(12*40)+15

.x_pt:              ldx #38
                    lda .coltab_top,x
                    sta .tmp_top
                    lda .coltab_bot,x
                    sta .tmp_bot
                    dex
                    bpl +
                    ldx #48
+                   stx .x_pt+1
                    rts

.tmp_top:           !byte 0x34
.tmp_bot:           !byte 0x36

.coltab_top:        !fi 40,0x34
                    !byte 0x34, 0x32, 0x3A, 0x37, 0x31, 0x31, 0x37, 0x3A, 0x32
.coltab_bot:        !fi 40,0x36
                    !byte 0x36, 0x32, 0x3A, 0x37, 0x31, 0x31, 0x37, 0x3A, 0x32
; ==============================================================================
                    *= bitmap0 + 0x1100
                    !zone SCROLLER
scroller:           lda #0
                    beq .need_new
                    dec scroller+1
                    jmp .softscroll
.need_new:          jsr .get_text
                    cmp #0xFF
                    bne +
                    jsr .text_reset
+                   jmp .fill_buf

.get_text:
.pt_scrolltext:     lda scrolltext
                    tay
                    clc
                    lda .pt_scrolltext+1
                    adc #0x01
                    sta .pt_scrolltext+1
                    lda .pt_scrolltext+2
                    adc #0x00
                    sta .pt_scrolltext+2
                    tya
                    rts

.text_reset:        lda #<scrolltext
                    sta .pt_scrolltext+1
                    lda #>scrolltext
                    sta .pt_scrolltext+2
                    lda #0x20
                    rts

.fill_buf:          clc
                    cmp #0x40
                    bcc +
                    ldy #(>charset1+0x200)
                    sty .char_point+2
                    sec
                    sbc #0x40
                    clc
+                   rol
                    rol
                    rol
                    sta .char_point+1
                    bcc +
                    inc .char_point+2
+                   ldx #0x07
.char_point:        lda charset1,x
                    sta .scrollchar,x
                    dex
                    bpl .char_point

                    lda #(<charset1)
                    sta .char_point+1
                    lda #(>charset1)
                    sta .char_point+2

                    lda .scrollchar
                    sta .buf_top+0
                    sta .buf_top+1
                    lda .scrollchar+1
                    sta .buf_top+2
                    sta .buf_top+3
                    lda .scrollchar+2
                    sta .buf_top+4
                    sta .buf_top+5
                    lda .scrollchar+3
                    sta .buf_top+6
                    sta .buf_top+7
                    lda .scrollchar+4
                    sta .buf_bot+0
                    sta .buf_bot+1
                    lda .scrollchar+5
                    sta .buf_bot+2
                    sta .buf_bot+3
                    lda .scrollchar+6
                    sta .buf_bot+4
                    sta .buf_bot+5
                    lda .scrollchar+7
                    sta .buf_bot+6
                    sta .buf_bot+7

                    lda #8
                    sta scroller+1

.softscroll:        !for i, 0, 7 {
                      clc
                      rol .buf_top+i
                      rol charset1+(8*0x74)+i
                      rol charset1+(8*0x73)+i
                      rol charset1+(8*0x72)+i
                      rol charset1+(8*0x71)+i
                      rol charset1+(8*0x70)+i
                    }
                    !for i, 0, 7 {
                      clc
                      rol .buf_bot+i
                      rol charset1+(8*0x79)+i
                      rol charset1+(8*0x78)+i
                      rol charset1+(8*0x77)+i
                      rol charset1+(8*0x76)+i
                      rol charset1+(8*0x75)+i
                    }
                    rts

.buf_top:           !byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
.buf_bot:           !byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
.scrollchar:        !byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00

scroller_prepare:   ldx #0x70
                    stx vidmem1+(22*40)+39-4
                    inx
                    stx vidmem1+(22*40)+39-3
                    inx
                    stx vidmem1+(22*40)+39-2
                    inx
                    stx vidmem1+(22*40)+39-1
                    inx
                    stx vidmem1+(22*40)+39-0
                    inx
                    stx vidmem1+(23*40)+39-4
                    inx
                    stx vidmem1+(23*40)+39-3
                    inx
                    stx vidmem1+(23*40)+39-2
                    inx
                    stx vidmem1+(23*40)+39-1
                    inx
                    stx vidmem1+(23*40)+39-0
                    rts

                    SCROLLCOLCYCLE_SPEED = 0x04
scroller_colcycle:  lda #SCROLLCOLCYCLE_SPEED
                    beq +
                    dec scroller_colcycle+1
                    rts
+                   lda #SCROLLCOLCYCLE_SPEED
                    sta scroller_colcycle+1
                    lda cycletab+4
                    sta 0xD800+(22*40)+39-4
                    sta 0xD800+(23*40)+39-4
                    lda cycletab+3
                    sta 0xD800+(22*40)+39-3
                    sta 0xD800+(23*40)+39-3
                    lda cycletab+2
                    sta 0xD800+(22*40)+39-2
                    sta 0xD800+(23*40)+39-2
                    lda cycletab+1
                    sta 0xD800+(22*40)+39-1
                    sta 0xD800+(23*40)+39-1
                    lda cycletab+0
                    sta 0xD800+(22*40)+39-0
                    sta 0xD800+(23*40)+39-0
shift_cycletab:     lda cycletab
                    sta cycletab_buffer
                    ldx #0
-                   lda cycletab+1,x
                    sta cycletab,x
                    inx
                    cpx #0xE
                    bne -
                    rts
cycletab:           !byte BROWN         ; 0
                    !byte RED           ; 1
                    !byte PURPLE        ; 2
                    !byte ORANGE        ; 3
                    !byte PINK          ; 4
                    !byte LIGHT_GREY    ; 5
                    !byte YELLOW        ; 6
                    !byte WHITE         ; 7
                    !byte YELLOW        ; 8
                    !byte LIGHT_GREY    ; 9
                    !byte PINK          ; A
                    !byte ORANGE        ; B
                    !byte PURPLE        ; C
                    !byte RED           ; D
cycletab_buffer:    !byte 0x00
; ==============================================================================
                    !zone ICONS
                    ICONCOL_SPEED = 0x02
col_icons:          lda #ICONCOL_SPEED
                    beq +
                    dec col_icons+1
                    rts
+                   lda #ICONCOL_SPEED
                    sta col_icons+1
.mod_src:           lda .col_icon_tab + (0xFF)
                    !for i, 17, 20 {
                        sta 0xD800+(i*40)+36
                        sta 0xD800+(i*40)+37
                        sta 0xD800+(i*40)+38
                    }
                    inc .mod_src+1
                    rts
                    !align 255,0
.col_icon_tab:      !for i, 0, 7 {
                        !fi 23, BLACK
                        !byte DARK_GREY
                        !byte GREY
                        !byte LIGHT_GREY
                        !byte YELLOW
                        !byte WHITE
                        !byte WHITE
                        !byte YELLOW
                        !byte LIGHT_GREY
                        !byte GREY
                    }
