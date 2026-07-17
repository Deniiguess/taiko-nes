# Taiko NES
![Taiko NES Title](img/taikonestitle.png?raw=true "Taiko NES Title")

## About
This is an NES port of Taiko No Tatsujin written completely in assembly using the N163 mapper chip for better audio and for more code and graphics space.

**Make sure that you're using a compatible emulator (ex. Mesen). Not all emulators support that mapper chip.**

## Building
TODO: Test both

### Windows
1. Obtain cc65 (refer to https://cc65.github.io/getting-started.html)
2. Run `git clone https://github.com/Deniiguess/taiko-nes/`
3. Copy the `ca65.exe` and `ld65.exe` from the `bin` folder into the `taiko-nes` folder (or just access the 2 .exe files somehow)
4. Open Command Prompt in the `taiko-nes` directory
5. Run `ca65.exe code/main.asm -o main.o` and `ld65.exe main.o -C nes.cfg -o taiko.nes`

### Linux
1. Obtain cc65 (refer to https://cc65.github.io/getting-started.html)
2. Run `git clone https://github.com/Deniiguess/taiko-nes/` (make sure you have the `git` package installed)
3. Copy the `ca65` and `ld65` from the `bin` folder into the `taiko-nes` folder (or just access the 2 files somehow)
4. Open the terminal and go to the `taiko-nes` directory in it
5. Run `ca65 code/main.asm -o main.o` and `ld65.exe main.o -C nes.cfg -o taiko.nes`

## Credits
**Karippa Boss** - [Adonete](https://www.youtube.com/@Adonete42/)

**Who Unleashed The Dog** *(WHO UNLEASH. DOG in-game)* - [DDRKirby(ISQ)](https://ddrkirbyisq.bandcamp.com) *(DDRKIRBY ISQ in-game)*

**Euphoria** (Rave Racer) - __Ayako Saso__

**Bean Brained** - [Adonete](https://www.youtube.com/@Adonete42/)

**Remix 8 DS** *[Sunsoft 5B Cover](https://www.youtube.com/watch?v=OUfYOx_-B50)* (Rhythm Heaven DS) - __Masami Yone__

**Finned Frontier** - __ThePurpleAnon__ *(THEPURPLANON in-game)*


## Disclamer
This port is **NOT AFFILIATED** with Bandai Namco or the Taiko No Tatsujin franchise in any way, nor uses any music, charts, code or graphics from any Taiko No Tatsujin game.

This is a project made purely just for fun and I am not making any money from this whatsoever, and you **CANNOT earn money from this yourself** by selling it on bootleg Famiclones or something like that.
