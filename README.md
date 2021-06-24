# oschands

oschands simply uses [MediaPipe Hands](https://google.github.io/mediapipe/solutions/hands.html) to calculate hand posiiton (x, y coordinates of both left and right hands) and hand gesture (via "spread" measuring clenched vs open hand) and sends this values to SuperCollider.

## usage

```
git clone https://github.com/schollz/oschands.git
cd oschands
go build -v
./oschands
```

now run SuperCollider. open up `hands.scd` and run the first and the second block. 
make sure to keep the browser open with the hand gesture mapping, otherwise it might goto sleep.



