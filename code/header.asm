.segment "HEADER"
.byte $4e, $45, $53, $1a ; Magic string that always begins an iNES header
.byte $07        ; Number of 16KB PRG-ROM banks
.byte $02        ; Number of 8KB CHR-ROM banks
.byte %00110011  ; MMMM (Mapper, 19), Alt nametable (Off), 512-byte trainer (Off), Contains PRG-RAM (On), Mirroring (Horizontal)
.byte %00010000  ; MMMM (Mapper, 19), NN (NES 2.0 Format, Off), Hint Screen Data (PlayChoice-10, Off), VS Unisystem (Off)
.byte $01        ; PRG-RAM size
.byte $00        ; NTSC (0) or PAL (1)
