(
SynthDef("synthy",{
	arg freq=0.5, amp=0.1, feedback=0.8,ctlFilter=0,ctlDistortion=1;
	var snd;
	var local;
	var scaleD,scaleFull;
	
	amp=VarLag.kr(amp,2,warp:\sine);
	feedback=Lag.kr(feedback,2);
	ctlFilter=Lag.kr(ctlFilter,0.2);
	ctlDistortion=Lag.kr(ctlDistortion,2);

	scaleD=Scale.newFromKey(\dorian);
	scaleFull=16+(scaleD.degrees++(12+scaleD.degrees)++(24+scaleD.degrees)++(36+scaleD.degrees)++(48+scaleD.degrees));
	freq = Select.kr(Lag.kr(LinLin.kr(freq,0,1,0,scaleFull.size),0.1),scaleFull).poll.midicps;
	snd=Array.fill(2,{arg i;
		var snd2;
		var freq2=freq*(2**i);
		var modBank={LFTri.kr(LFNoise0.kr(rrand(1/60,1/3)).range(1/60,1/3))}!8;
		var modAmp=modBank[0].range(0.2,0.5); // convert to correct range
		var modWidth=modBank[1].range(0.2,0.8);
		var midinote=freq2.cpsmidi;
		var detune=0.5;
		var modFreq=modBank[2].range(midinote-detune,midinote+detune).midicps;
		snd2=PulseDPW.ar(
			freq:modFreq,
			mul:modAmp/(2**i),
			width:modWidth,
		);

		// the envelope
		snd2=snd2*EnvGen.kr(Env.asr(rrand(1,10)));

		// add filter, a resonant lpf
		// each part of it is modulated
		snd2=RLPF.ar(snd2,
			freq:LinExp.kr(modBank[4],-1,1,freq,20000),
			rq:modBank[5].range(0.01,1)
		);

		// add panning
		snd2=Pan2.ar(snd2,modBank[6].range(-0.5,0.5));

		// add delay!
		snd2 = snd2 + CombC.ar(snd2,
			maxdelaytime:0.5,
			delaytime:rrand(0.2,0.5)+VarLag.kr(LFNoise0.kr(rrand(1/60,1/3)),1/2,warp:\sine).range(-0.2,0),
			decaytime:rrand(1,3),
		);
		snd2=LeakDC.ar(snd2); // remove DC bias JIC
	});
	snd=Mix.ar(snd);
	snd=Splay.ar(snd);

	// // global moog filter
	snd=MoogFF.ar(snd,Clip.kr(LinExp.kr(ctlFilter,0,1,10,40000),20,20000),1);

	Out.ar(0,snd*amp);
}.add;

)


// load up one synth for each hand
(
x=Synth("synthy");
y=Synth("synthy");
~o1 = OSCFunc({ arg msg, time, addr, recvPort; [msg, time, addr, recvPort].postln;
	x.set(\amp,msg[1],\freq,msg[2],\ctlFilter,msg[3]);
}, '/left'); 
~o2 = OSCFunc({ arg msg, time, addr, recvPort; [msg, time, addr, recvPort].postln;
	x.set(\amp,msg[1],\freq,msg[2],\ctlFilter,msg[3]);
}, '/right'); 
)

