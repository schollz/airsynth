# oschands

oschands simply uses [MediaPipe Hands](https://google.github.io/mediapipe/solutions/hands.html) to calculate hand posiiton (x, y coordinates of both left and right hands) and hand gesture (via "spread" measuring clenched vs open hand) and sends this values to SuperCollider.

## usage

```
git clone https://github.com/schollz/oschands.git
cd oschands
go build -v
./oschands
```

this should open a browser webpage that will load the hand capture.

now run SuperCollider. open up `icarus.scd` and run the first and the second block. 
make sure to keep the browser open with the hand gesture mapping, otherwise it might goto sleep.

filter open/close with palm open/close. raise hand to add feedback, move hand across to change pitch. left hand and right hand control separate oscillators.




