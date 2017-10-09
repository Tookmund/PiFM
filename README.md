# PiFM

Based on PiFM by Oliver Mattos and Oskar Weigl
https://github.com/rm-hull/pifm

and

PiFMPlay by Mikael Jakhelln
https://github.com/Mikael-Jakhelln/PiFMPlay


## How to Use PiFM
From https://github.com/rm-hull/pifm

Now connect a 20cm or so plain wire to GPIO 4 (which is pin 7 on header P1) to
act as an antenna, and tune an FM radio to 103.3Mhz
The antenna is optional, but range is reduced from ~100 meters to ~10cm without
the antenna. The sound file must be 16 bit mono wav format.


## How to Use PiFMPlay
From https://github.com/Mikael-Jakhelln/PiFMPlay

>sudo sh pifmplay . 91.3

(91.3 is the default frequency, change it to whatever frequency you want to broadcast on.)

### Play a file with:

>sudo sh pifmplay "/path/to/file.mp3"

>sudo sh pifmplay "/path/to/file.m4a"

>sudo sh pifmplay "/path/to/file.wav"

this will play a file with pifm.

### Play from a pipe

>cat /path/to/file | sudo pifmplay PIPE

to play a file locally (the cat command only being an example here).

>cat <audio file> | ssh pi@raspberrypi 'cat - | sudo /home/pi/pifmplay/pifmplay PIPE'

play a file from your local pc over ssh on the raspberry pi.

### Play a folder with:

>sudo sh pifmplay "/path/to/folder" 101.5

### How to Pause/Stop broadcast and skip songs:
Open another terminal.

>sudo sh pifmplay pause

>sudo sh pifmplay resume

>sudo sh pifmplay stop

>sudo sh pifmplay next

To control pifmplay from the same terminal, run pifm in the background:
>sudo sh pifmplay "/path/to/folder" &
(tho you might want to remove the text output)
