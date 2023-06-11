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
                    !bin "gfx/hires_top.prg",(13*40),0x1F40+2
                    *= charset1
                    !bin "gfx/charset.chr"
                    *= vidmem1
                    !fi (13*40), " "
                    !bin "gfx/petscii_bottom.prg",(12*40),2
                    *= sprite_data
                    !bin "gfx/bar_sprites.bin"
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
                    lda #0x3B
                    ldy #YELLOW
                    sta 0xD011
                    sty 0xD020
                    jmp irq_end

irq02:              ldx #2
-                   dex
                    bpl -
                    lda #LIGHT_GREY
                    sta 0xD020
                    jmp irq_end

irq03:              ldx #2
-                   dex
                    bpl -
                    lda #PINK
                    sta 0xD020
                    jmp irq_end

irq04:              ldx #2
-                   dex
                    bpl -
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
                    lda #BROWN
                    sta 0xD020
                    jmp irq_end

irq07:              ldx #2
-                   dex
                    bpl -
                    lda #BLUE
                    sta 0xD020
                    jmp irq_end

irq08:              ldx #2
-                   dex
                    bpl -
                    lda #DARK_GREY
                    sta 0xD020
                    jmp irq_end

irq09:              ldx #2
-                   dex
                    bpl -
                    lda #PURPLE
                    sta 0xD020
                    jmp irq_end

irq10:              ldx #2
-                   dex
                    bpl -
                    lda #LIGHT_BLUE
                    sta 0xD020
                    jmp irq_end

irq11:              ldx #2
-                   dex
                    bpl -
                    lda #GREEN
                    sta 0xD020
                    jmp irq_end

irq12:              ldx #2
-                   dex
                    bpl -
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
                    jmp irq_end

irq14:              lda #CYAN
                    sta 0xD021
                    lda #0x93
                    sta 0xD011
                    jsr cursor_place
                    jsr cursor_anim
enable_loadbar:     bit print_loadbar
enable_timer:       bit timer_increase
enable_check_end:   bit timer_check_end
enable_song_end:    bit song_end
enable_song_fade:   bit song_fadeout
                    jsr print_timer
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
                    lda #YELLOW
                    ldx #0
-                   sta 0xD800+0x000,x
                    sta 0xD800+0x100,x
                    sta 0xD800+0x200,x
                    sta 0xD800+0x2e8,x
                    dex
                    bne -
                    lda #BLACK
                    ldx #39
-                   sta 0xD800+(12*40),x
                    dex
                    bpl -
                    lda #CYAN
                    sta 0xD020
                    sta 0xD800+0x0208
                    sta 0xD800+0x0208+39
                    sta 0xD800+0x0208+(11*40)
                    sta 0xD800+0x0208+(11*40)+39
                    !for i, 0, 11 {
                        sta 0xD800+0x0208+(i*40)+30
                    }
                    lda #LIGHT_BLUE
                    !for i, 0, 11 {
                        sta 0xD800+0x0208+(i*40)+28
                    }
                    lda #GREEN
                    !for i, 0, 11 {
                        sta 0xD800+0x0208+(i*40)+29
                    }
                    lda #LIGHT_GREEN
                    !for i, 0, 11 {
                        sta 0xD800+0x0208+(i*40)+31
                    }
                    lda #LIGHT_GREY
                    !for i, 0, 11 {
                        sta 0xD800+0x0208+(i*40)+32
                    }
                    lda #PINK
                    !for i, 0, 11 {
                        sta 0xD800+0x0208+(i*40)+33
                    }
                    lda #ORANGE
                    !for i, 0, 11 {
                        sta 0xD800+0x0208+(i*40)+34
                    }
                    lda #WHITE
                    !for i, 0, 9 {
                        sta 0xD800+0x0230+(i*40)
                    }
                    sta 0xD800+0x0231+(0*40)+35
                    sta 0xD800+0x0231+(0*40)+36
                    sta 0xD800+0x0231+(0*40)+37

                    ldx #16
                    lda #PINK
-                   sta 0xD800+0x0231+(10*40)+9,x
                    dex
                    bpl -

                    sta 0xD800+0x0231+(1*40)+35
                    sta 0xD800+0x0231+(1*40)+35+1
                    sta 0xD800+0x0231+(1*40)+35+2

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
+                   ;!if DEBUG=1 { sta vidmem0+3 }
                    cmp #KEY_CRSRUP
                    bne +
                    jmp .crsr_up
+                   cmp #KEY_CRSRDOWN
                    bne +
                    jmp .crsr_down
+                   cmp #KEY_RETURN
                    bne +
                    jmp .return ; select
+                   cmp #KEY_STOP
                    bne +
                    jmp .key_exit ; pause
+
.key_exit:
                    !if DEBUG=1 { inc 0xD020 }
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
.crsr_down:         lda cursorpos
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
                    !byte 26, 37, 30, 2, 8, 22, 10, 16
                    !byte 11, 28, 31, 12, 7, 24, 0, 19
                    !byte 18, 21, 6, 15, 25, 38, 14, 23
                    !byte 32, 1, 9, 27, 34, 13, 17, 5
                    !byte 36, 20, 4, 33, 29, 35, 3

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
                    lda #DISABLE
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
