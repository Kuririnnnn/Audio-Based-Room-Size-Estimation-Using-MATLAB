# Audio-Based Room Size Estimation using MATLAB
This project estimates room size (volume) from recorded audio using RT60 reverberation time.  
The method is based on the Sabine formula, which extracts reverberation decay from a clap sound.

## Features
* Records or loads a clap sound.
* Extracts the Room Impulse Response (RIR).
* Estimates RT60 using Schroeder’s energy decay method.
* Calculates the approximate room volume.
* Plots the energy decay curve.

## Example Results (For clap2.wav)
Estimated RT60: 1.23 seconds
Estimated Room Volume: 93.41 cubic meters

<img width="751" height="472" alt="Image" src="https://github.com/user-attachments/assets/9b642546-36fe-4f10-9704-b94b6ce608b2" />
