SHELL=/bin/bash

CBMDISK=c1541

ASS=acme
ASSFLAGS=-v4 -f cbm -DRELEASE=$(RELEASE)
PACKER=exomizer3
RM=rm -f
CP=cp -v

EMU?=vice
EMUFLAGS?=-VICIIborders 0
