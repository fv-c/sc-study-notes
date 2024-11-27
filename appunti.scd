/*

Title: Notes on Supercollider tutorials
Author: Francesco Vitucci

*/


//----------------------------------------------------------------------------
// Set Server options. Then boot (and quit)
//----------------------------------------------------------------------------

(
s.options.sampleRate = 48000;
s.options.hardwareBufferSize = 128;
)

s.boot; // command-b

s.quit;

// command-. to stop running processes and sound in SC

//----------------------------------------------------------------------------
// FUNCTIONS: the simplest case
//----------------------------------------------------------------------------

(
f = { 1.0.rand };
f.value; /* the method ".value" evaluates the function and return the Function object */
) // command-return just to the right of round bracket

//----------------------------------------------------------------------------
// FUNCTIONS: a less simple case
//----------------------------------------------------------------------------

(
f = {
	arg max;
	max.rand;
};
f.value(1.0); /* the method ".value" is called with one argument */
// f.value(max:1.0) //this works too: "-value" is called with keyword argument
)

//----------------------------------------------------------------------------
// FUNCTIONS: an even less simple case
//----------------------------------------------------------------------------

(
var max = 1.0; // local variable within the round brackets scope
f = {
	max.rand;
};
f.value(1.0); /* the method ".value" is called with one argument */
)

max // outside the round brackets the variable is not defined

//----------------------------------------------------------------------------
// Functions and Sound
//----------------------------------------------------------------------------

{ SinOsc.ar(440, 0, 0.2) }.play; // An istance of audio rate SinOsc

(
{
	var amplitude = SinOsc.kr(1, 0, 0.5, 0.5); // an istance of control rate SinOsc
	SinOsc.ar(440, 0, amplitude);
}.play;
)

//----------------------------------------------------------------------------
// The same but on two channels!
//----------------------------------------------------------------------------

(
{
	var amplitude1 = SinOsc.kr(1, 0, 0.5, 0.5);
	var amplitude2 = SinOsc.kr(1, pi, 0.5, 0.5);
	[ SinOsc.ar(440, 0, amplitude1), SinOsc.ar(440, 0, amplitude2) ];
}.play;
)

//----------------------------------------------------------------------------
// Multichannel expansion
//----------------------------------------------------------------------------

// Just an equivalence:
{ [ SinOsc.ar(440, 0, 0.2), SinOsc.ar(442, 0, 0.2)] }.play;
// ==
{ SinOsc.ar([440, 442], 0, 0.2) }.play;

// If you plug an Array into one of UGen's argument, you get an Array of that UGen

//----------------------------------------------------------------------------
// Mix
//----------------------------------------------------------------------------

// .new method
{ Mix.new(SinOsc.ar([440, 442], 0, 0.2)) }.play; // .new is the most common method for creating new object
// ===
{ Mix(SinOsc.ar([440, 442], 0, 0.2)) }.play;

// .fill method
(
{
	var n = 10;
	Mix.fill(
		n, // number of istances to mix
		{
			arg index; // index of iteration, starting from 0
			index.postln; // check the console
			SinOsc.ar((440*index)+10.rand, 0, 1/(n+1)) // content of each instance
	})
}.play;
)

//----------------------------------------------------------------------------
// Panning sound sources on two-channels listening system
//----------------------------------------------------------------------------

{ Pan2.ar(SinOsc.ar(440), SinOsc.kr(1)) }.play;

//----------------------------------------------------------------------------
// Graphical representation
//----------------------------------------------------------------------------

{ SinOsc.ar(1, 0, 1) }.plot(1); // plot 1 second of the function waveform

{ SinOsc.ar(1, 0, 1) }.scope; // plot continuously the function waveform and play it
{ SinOsc.ar(1, 0, 1) }.scope(zoom: 10); // zoom inside the waveform

// s.scope; // also the server can be scoped

//----------------------------------------------------------------------------
// Synth Def
//----------------------------------------------------------------------------

{ SinOsc.ar(440, 0, 0.2) }.play;
// ==
(
x = SynthDef.new(
		"simple synth", // name, as string, of the SynthDef
	{
		arg out; // SynthDef Control input - an OutputProxy object
		out.postln;
		Out.ar(out, SinOsc.ar(440, 0, 0.2))
	} // UGen Graph Function
).play;
)

x.free; // free the UGen instance related to the variable


// An other example

(
SynthDef.new(
		"simple synth", // name, as string, of the SynthDef
	{
		arg out; // SynthDef Control input - an OutputProxy object
		out.postln;
		Out.ar(out, SinOsc.ar(440, 0, 0.2))
	} // UGen Graph Function
).add;
) // THIS CONTENT IS EVALUATED ONLY ONCE (PAY ATTENTION FOR .rand METHOD! IT'S BETTER Rand())

x = Synth.new("simple synth");

x.free;

// To use randomness...

(
SynthDef.new(
		"simple synth with randomness",
	{
		arg out;
		out.postln;
		Out.ar(out, SinOsc.ar(440+Rand(-200,200), 0, 0.2))
	}
).add;
)

x = Synth.new("simple synth");

x.free;

// Now we add arguments

(
SynthDef.new(
		"simple synth with randomness and arguments",
	{
		arg fundFreq = 440,
		out = 0;
		out.postln;
		Out.ar(out, SinOsc.ar(440+Rand(-200,200), 0, 0.2))
	}
).add;
)

x = Synth.new("simple synth", ["fundFreq", 220, "out", 1]);

x.free;
