# 250-FinalProject


This is the final project for 250a. The requirements of the project were very open, we just had to do a interactive design object that allowed an interesting musical experience and perform with it.

# Video Example
The following video is an example of the possibilities of this instrument

# General Idea

The idea was to use Dual Voic Coil Speakers (DVC) which have a pair of concentric coils driving the same membrane. Most of the time, this type of speaker is driven with quasi-similar signals on both coils to achieve better harmonic distortion values. However in this case, Im using one of the coils as a speaker and the other one as a microphone. The purpose of this is then to use the microphone as a control signal that determines the amplitude of the sound coming out of the speaker itself. Clearly this call for problems with feedback making the system almost unstable by nature.

However, this is then used as an advantage to create a resonant system with interesting interactive properties. For example, not only the sound is produced from the movement of the membrane but it is heard by the interpreter as coming from the membrane. Additionally, given that the feedback loop is running through the membrane, the performer has the possibility to tap into this quasi-karlpustrong algorithm to interrupt, excite or slightly attenuate the signal in a very natural way.

In this case, 5 of these DVC speakers were mounted on a hexagonal pyramidal shape and made into a percussive instrument meant to be playd with your hands or soft mallets.

# General Structure

The project is based around faust to achieve the lowest latency possible, as this value will be crucial for the feedback values. On the other hand, given that the algorithm is written through parallel syntaxis, it is very hard to achieve specific parameters for each speaker so, I used Chuck as an organizer of parameters and meta control over the algorithm sending osc messages through the built in osc support in faust. Additionally, this allows to send midi data from an additionaly teensy that is used to manuplate some values in real time. In this sense, chuck is not producing or processing any audio at all.

# Faust side

The faust code is based on a simple generator composed by multiple sine oscillators. The amplitudes of this generator is the multiplied by a leaky integrator that is calculating the overall amplitude of the input. In this sense, the feedback is not direct; however, theres always a possibility of having a signal so big that will always drive the generator bigger.

Additionally, the one pole filter (leaky integrator) controlls very intimately the resonance of the system, so it is used as the center of calibration to achieve a value as close as possible to unstability without being unstable. After all of this, the generator goes through some filtering and reverb. (Notice that this reverb is just extending in time the decay of the signal, but cannot really work as a reverb as it is in the middle of the feedback loop.

# Chuck Side

Chuck, as stated before, is just intended for osc control over the faust code; therefore it only runs midi and osc control.


# The controller

The box was built in thick plywood and structurally designed to hold 5 speakers and a panel of connectors. The CAD files can be found in this repository.
