# Air Synth

Air Synth is Air Guitar, but for synthesizers.

Use any webcam and a computer with SuperCollider installed and you can control synth sounds, filters, and effects with hand gestures.


airsynth simply uses [MediaPipe Hands](https://google.github.io/mediapipe/solutions/hands.html) to calculate hand posiiton (x, y coordinates of both left and right hands) and hand gesture (via "spread" measuring clenched vs open hand) and sends this values to SuperCollider.

demo: https://vimeo.com/567293081

## Install

First install SuperCollider, then download and run airsynth.

### Installing SuperCollider

<details><summary><strong>Windows</strong></summary>


[Click here](https://github.com/supercollider/supercollider/releases/download/Version-3.11.2/SuperCollider-3.11.2-Windows-32bit-VS.exe) to download the latest Windows release. This is the *32-bit* release, rather than the 64-bit release, because [the most recent Windows Update prevents the 64-bit version from starting](https://github.com/supercollider/supercollider/issues/4368#issuecomment-832050665). But 32-bit will work just fine!

Then [click here](https://github.com/supercollider/sc3-plugins/releases/download/Version-3.11.1/sc3-plugins-3.11.1-Windows-32bit-VS.zip) to download the 32-bit sc3-plugins. Unzip these plugins and then copy and paste the `SC3plugins` folder into the following folder:

```
C:\Users\<yourname>\AppData\Local\SuperCollider\Extensions\
```

</details>

<details><summary><strong>Mac OS</strong></summary>


[Click here](https://supercollider.github.io/download) to go to the website to download SuperCollider. *Make sure to check your version* of Mac OS and install the correct version of SuperCollider.

Then, [click here](https://github.com/supercollider/sc3-plugins/releases/download/Version-3.11.1/sc3-plugins-3.11.1-macOS-signed.zip) to download the plugins for Mac OS. Unzip this archive. Then copy the `SC3plugins` folder to your Extensions folder:

```
/Users/<yourname>/Library/Application Support/SuperCollider/Extensions
```

</details>

### Installing airsynth

The easiest way to install is to download the latest version from [the releases](https://github.com/schollz/airsynth/releases/latest).

If you have Go installed, you can also install from source:

```
go install github.com/schollz/airsynth@latest
```


## Usage

To use, first open SuperCollider and run the `airsynth.scd` file. There are two different blocks in there that you can run to setup the synth.

Then you can just double-click the `airsynth` binary, or in a terminal type:

```
airsynth
```

This will open up your browser that will autodetect your webcam and start sending OSC messages to SuperCollider about your current hand gestures.


The current example changes th filter open/close with palm open/close. You can raise your hand to add feedback, or move hand across to change pitch. The left hand and right hand control separate oscillators.





