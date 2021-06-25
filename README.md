# Air Synth

Air Synth is Air Guitar, but for synthesizers.

Use any webcam and a computer with SuperCollider installed and you can control synth sounds, filters, and effects with hand gestures.


airsynth simply uses [MediaPipe Hands](https://google.github.io/mediapipe/solutions/hands.html) to calculate hand posiiton (x, y coordinates of both left and right hands) and hand gesture (via "spread" measuring clenched vs open hand) and sends this values to SuperCollider.

demo: https://vimeo.com/567293081

## Usage

First install SuperCollider, then download and run airsynth.

### Installing SuperCollider

<details><summary><strong>Windows</strong></summary>

#### Downloading

[Click here](https://github.com/supercollider/supercollider/releases/download/Version-3.11.2/SuperCollider-3.11.2-Windows-32bit-VS.exe) to download the latest Windows release. This is the *32-bit* release, rather than the 64-bit release, because [the most recent Windows Update prevents the 64-bit version from starting](https://github.com/supercollider/supercollider/issues/4368#issuecomment-832050665). But 32-bit will work just fine!

Then [click here](https://github.com/supercollider/sc3-plugins/releases/download/Version-3.11.1/sc3-plugins-3.11.1-Windows-32bit-VS.zip) to download the 32-bit sc3-plugins. Unzip these plugins and then copy and paste the `SC3plugins` folder into the following folder:

```
C:\Users\<yourname>\AppData\Local\SuperCollider\Extensions\
```

</details>

<details><summary><strong>Mac OS</strong></summary>

#### Downloading

[Click here](https://supercollider.github.io/download) to go to the website to download SuperCollider. *Make sure to check your version* of Mac OS and install the correct version of SuperCollider.

Then, [click here](https://github.com/supercollider/sc3-plugins/releases/download/Version-3.11.1/sc3-plugins-3.11.1-macOS-signed.zip) to download the plugins for Mac OS. Unzip this archive. Then copy the `SC3plugins` folder to your Extensions folder:

```
/Users/<yourname>/Library/Application Support/SuperCollider/Extensions
```

</details>

first make sure you have Go 1.16+ installed.

```
git clone https://github.com/schollz/airsynth.git
cd airsynth
go build -v
./airsynth
```

this should open a browser webpage that will load the hand capture.

now run SuperCollider. open up `airsynth.scd` and run the first and the second block. 
make sure to keep the browser open with the hand gesture mapping, otherwise it might goto sleep.

filter open/close with palm open/close. raise hand to add feedback, move hand across to change pitch. left hand and right hand control separate oscillators.




