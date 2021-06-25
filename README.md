# airsynth

airsynth simply uses [MediaPipe Hands](https://google.github.io/mediapipe/solutions/hands.html) to calculate hand posiiton (x, y coordinates of both left and right hands) and hand gesture (via "spread" measuring clenched vs open hand) and sends this values to SuperCollider.

demo: https://vimeo.com/567293081

## usage

first make sure you have Go 1.16+ installed.

```
git clone https://github.com/schollz/airsynth.git
cd airsynth
go build -v
./airsynth
```

this should open a browser webpage that will load the hand capture.

now run SuperCollider. open up `icarus.scd` and run the first and the second block. 
make sure to keep the browser open with the hand gesture mapping, otherwise it might goto sleep.

filter open/close with palm open/close. raise hand to add feedback, move hand across to change pitch. left hand and right hand control separate oscillators.




