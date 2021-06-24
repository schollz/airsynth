(			
SynthDef("icarussynth",{ 
				arg amp=0.5, hz=220, pan=0, envgate=0,
				pulse=0,saw=0,
				attack=0.015,decay=1,release=2,sustain=0.9,
				lpf=20000,resonance=0,portamento=0.1,tremelo=0,destruction=0,
				pwmcenter=0.5,pwmwidth=0.05,pwmfreq=10,detuning=0.1,
				feedback=0.5,delaytime=0.25, delaytimelag=0.1, sublevel=0;

				// vars
				var ender,snd,local,in,ampcheck;

				// envelope stuff
				ender = EnvGen.ar(
					Env.new(
						curve: 'cubed',
						levels: [0,1,sustain,0],
						times: [attack+0.015,decay,release],
						releaseNode: 2,
					),
					gate: envgate,
				);

				// dreamcrusher++
				in = VarSaw.ar(Lag.kr(hz+(
					SinOsc.kr(LFNoise0.kr(1))*
					(((hz).cpsmidi+1).midicps-(hz))*detuning
					),portamento),
					width:
					LFTri.kr(pwmfreq+rrand(0.1,0.3),mul:pwmwidth/2,add:pwmcenter),
					mul:0.5
				);
				// add suboscillator
				in = in + Pulse.ar(Lag.kr(hz/2+(
					SinOsc.kr(LFNoise0.kr(1))*
					(((hz/2).cpsmidi+1).midicps-(hz/2))*detuning
					),portamento),
					width:
					LFTri.kr(pwmfreq+rrand(0.1,0.3),mul:pwmwidth/2,add:pwmcenter),
					mul:0.5*sublevel	
				);
				in = Splay.ar(in);

				// random panning
				in = Balance2.ar(in[0] ,in[1],SinOsc.kr(
					LinLin.kr(LFNoise0.kr(0.1),-1,1,0.05,0.2)
				)*0.1);

				in = in * ender;
			    ampcheck = Amplitude.kr(Mix.ar(in));
			    in = in * (ampcheck > 0.02); // noise gate
			    local = LocalIn.ar(2);
			    local = OnePole.ar(local, 0.4);
			    local = OnePole.ar(local, -0.08);
			    local = Rotate2.ar(local[0], local[1],0.2);
				local = DelayC.ar(local, 0.5,
					Lag.kr(delaytime,0.2)
				);
			    local = LeakDC.ar(local);
			    local = ((local + in) * 1.25).softclip;

			    local = MoogLadder.ar(local,Lag.kr(lpf,1),res:Lag.kr(resonance,1));
				// add destruction thing
				local = ((local*((1-EnvGen.kr(
				        Env(
				            levels: [0, 1,0], 
				            times: [0.1,0.1],
							curve:\sine,
				        ),
				        gate: Dust.kr(destruction)
				))))+local)/2;
				// add tremelo
                // local = local * ((tremelo>0)*SinOsc.kr(tremelo,0,0.4)+(tremelo<0.0001));

			    LocalOut.ar(local*Lag.kr(feedback,1));
				
				snd= Balance2.ar(local[0]*0.2,local[1]*0.2,SinOsc.kr(
					LinLin.kr(LFNoise0.kr(0.1),-1,1,0.05,0.2)
				)*0.1);

				// manual pan
				snd = Mix.ar([
					Pan2.ar(snd[0],-1+(2*pan),amp),
					Pan2.ar(snd[1],1+(2*pan),amp),
				]);
				Out.ar(0,snd)
			}).add;	
)

// control pitch with X direction (so left hand is low, right hand is high)
// control feedback with Y direction
// control lpf with spread
