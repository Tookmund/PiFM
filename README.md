# PiFM

Based on PiFM by Oliver Mattos and Oskar Weigl
https://github.com/rm-hull/pifm

and

PiFMPlay by Mikael Jakhelln
https://github.com/Mikael-Jakhelln/PiFMPlay



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

## How to Use PiFM
From https://github.com/rm-hull/pifm

Connect a 20cm or so plain wire to GPIO 4 (which is pin 7 on header P1) to
act as an antenna, and tune an FM radio to 103.3Mhz
The antenna is optional, but range is reduced from ~100 meters to ~10cm without
the antenna. The sound file must be 16 bit mono wav format.

### New! Now with stereo

```
sudo ./pifm left_right.wav 103.3 22050 stereo

# Example command lines
# play an MP3
ffmpeg -i input.mp3 -f s16le -ar 22.05k -ac 1 - | sudo ./pifm -

# Broadcast from a usb microphone (see arecord manual page for config)
arecord -d0 -c2 -f S16_LE -r 22050 -twav -D copy | sudo ./pifm -
```

### How to change the broadcast frequency

Run the ./pifm binary with no command line arguments to find usage.

The second command line argument is the frequency to transmit on, as a number in Mhz. Eg. This will transmit on 100.0

> sudo ./pifm sound.wav 100.0

It will work from about 1Mhz up to 250Mhz, although the useful FM band is 88 Mhz to 108 Mhz in most countries.

Most radio receivers want a signal to be an odd multiple of 0.1 MHz to work properly.

### The details of how it works

Below is some code that was hacked together over a few hours at the [Code Club pihack](http://blog.codeclub.org.uk/blog/brief/). It uses the hardware on the raspberry pi that is actually meant to generate spread-spectrum clock signals on the GPIO pins to output FM Radio energy. This means that all you need to do to turn the Raspberry-Pi into a (ridiculously powerful) FM Transmitter is to plug in a wire as the antenna (as little as 20cm will do) into GPIO pin 4 and run the code posted below. It transmits on 100.0 MHz.

When testing, the signal only started to break up after we went through several conference rooms with heavy walls, at least 50m away, and crouched behind a heavy metal cabinet. The sound quality is ok, but not amazing, as it currently plays some clicks when the CPU gets switched away to do anything else than play the music. The plan was to make a kernel mode driver that would be able to use the ~~DMA controller to offload the CPU and play smooth music without loading the CPU, but we ran out of time.~~ Now Done and working, DMA from userspace is awesome and awful at the same time!

~~If you're v. smart, you might be able to get stereo going!~~ Done!

### Accessing Hardware

The python library calls a C program. The C program maps the Peripheral Bus (0x20000000) in physical memory into virtual address space using /dev/mem and mmap. To do this it needs root access, hence the sudo. Next it sets the clock generator module to enabled and sets it to output on GPIO4 (no other accessible pins can be used). It also sets the frequency to ~~100.0Mhz (provided from PLLD@500Mhz, divided by 5)~~ 103.3, which provides a carrier. At this point, radios will stop making a "fuzz" noise, and become silent.

Modulation is done by adjusting the frequency using the fractional divider between 103.325Mhz and 103.275Mhz, which makes the audio signal. ~~The fractional divider doesn't have enough resolution to produce more than ~6 bit audio, but since the PI is very fast, we can do oversampling to provide about 9.5 bit audio by using 128 subsamples per real audio sample.~~ We were being naive with our subsampling algorithm - you can now get full 16 bit quality sound, and it even does FM pre-emphasis so that the result doesn't sound bass-heavy. 

### Notes

This is a copy of the updated documentation and code from 
http://www.icrobotics.co.uk/wiki/index.php/Turning_the_Raspberry_Pi_Into_an_FM_Transmitter
