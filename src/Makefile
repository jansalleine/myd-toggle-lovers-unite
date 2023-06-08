include Makefile.inc

TITLE=toggle

BINDIR=../bin

IMAGE=$(BINDIR)/$(TITLE)_dev.d64

MAIN=main.asm

LOADER=krill/install-c64.prg \
krill/loader-c64.prg \
krill/loadersymbols-c64.inc

SIDS=sids/64K_Memory_Lane.exo \
sids/Anticipation.exo \
sids/Boreal_Sunrise.exo \
sids/Bring_Mich_Nach_Hause_Spider.exo \
sids/Cute_Bundle_of_Fluff.exo \
sids/Defier_of_Deadlines.exo \
sids/Euphoria.exo \
sids/Fireflies.exo \
sids/Flowing_Slowly_extended.exo \
sids/Glacial_Blues.exo \
sids/Homecoming.exo \
sids/Irrlicht.exo \
sids/Jaded.exo \
sids/Kicks_Like_a_M_U_L_E.exo \
sids/Little_Heart.exo \
sids/Maniac_Marstall_LuheCon_Theme.exo \
sids/Mayday_in_Monsterland.exo \
sids/MuckelSID.exo \
sids/Nappy_Go_Lucky.exo \
sids/Nightlights.exo \
sids/Notch_It.exo \
sids/Oakyard_Memories.exo \
sids/Pantheon.exo \
sids/Pompeii.exo \
sids/Quietus.exo \
sids/Redshift_Infinite.exo \
sids/Rogaland_Revisited.exo \
sids/Selenopolis_2_0.exo \
sids/Sparkle.exo \
sids/Supremacy_Intro.exo \
sids/Tao_Tao.exo \
sids/Tidal_Waves.exo \
sids/Transmission_64.exo \
sids/Unity.exo \
sids/Ursa_Minor.exo \
sids/Valiant_Adventurer_1983.exo \
sids/Welc0me_Aboard.exo \
sids/Wieselflink.exo \
sids/Wintry_Haze.exo

.PHONY: all release test clean distclean

all: $(MAIN) $(LOADER) $(SIDS)
	$(RM) $(IMAGE)
	make RELEASE=1 $(IMAGE)
	$(EMU) $(EMUFLAGS) $(IMAGE)

main.o: $(MAIN)
	$(ASS) $(ASSFLAGS) -l labels.asm -o $@ $<
	./sortLabels > labels.txt

main.prg: main.o
	$(PACKER) sfx 0x0800 -s "lda #\$$0b sta \$$d011" -x2 -o $@ $<

$(BINDIR):
	mkdir -p $(BINDIR)

$(IMAGE): $(BINDIR) main.prg
	[[ "$(RELEASE)" == 1 ]]

	$(CBMDISK) -format "<3   toggle   <3,01" d64 $(IMAGE)

	$(CBMDISK) -attach $(IMAGE) -write main.prg "toggle <3   /myd"

	let i=0; \
	for sid in $(SIDS); do \
		$(CBMDISK) -attach $(IMAGE) -write $$sid $$(printf "%02x" $$i); \
		let i=i+1; \
	done

clean:
	$(RM) *.prg
	$(RM) *.o

distclean: clean
	$(RM) $(IMAGE)
