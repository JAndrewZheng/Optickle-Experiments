% simulate_ETM
% Simulate an ETM setup for generating multiphoton entangled states using Optickle.

% Initialize the Optickle model
lambda = 780e-9; % Wavelength in meters (780 nm)
vFrf = 0;        % RF frequencies (none for simplicity)
opt = Optickle(vFrf, lambda);

% Add Laser Source
laserPower = 30e-3; % 30 mW
[opt, snLaser] = addSource(opt, 'Ti:Sapphire Laser', sqrt(laserPower));

% Add Second-Harmonic Generation (SHG)
[opt, snSHG] = addSink(opt, 'SHG');
[opt] = addLink(opt, snLaser, 'out', snSHG, 'in', 0);

% Add Spatial Compensation (SC)
[opt, snSC] = addSink(opt, 'SC');
[opt] = addLink(opt, snSHG, 'out', snSC, 'in', 0);

% Add Temporal Compensation (TC)
[opt, snTC] = addSink(opt, 'TC');
[opt] = addLink(opt, snSC, 'out', snTC, 'in', 0);

% Add Dynamic Delay Line
delayLength = 13.139e-9; % Delay in seconds
delayEfficiency = 0.867; % Efficiency
[opt, snDelayLine] = addSink(opt, 'DelayLine');
[opt] = addLink(opt, snTC, 'out', snDelayLine, 'in', delayLength);

% Add Multiphoton Interference Module
[opt, snInterference] = addSink(opt, 'Interference');

% Debug: List optics and their ports
disp('Listing available optics and their ports:');
list(opt); % Use the `list` function to display optics

% Connect Delay Line to Interference Module
[opt] = addLink(opt, snDelayLine, 'out', snInterference, 'in', 0); % Replace 'in' with the correct port

% Add EPR Photon Sources
[opt, snEPR1] = addSource(opt, 'EPR1', sqrt(laserPower));
[opt, snEPR2] = addSource(opt, 'EPR2', sqrt(laserPower));

% Connect EPR sources to Interference Module
[opt] = addLink(opt, snEPR1, 'out', snInterference, 'in2', 0); % Replace 'in2' with the correct port
[opt] = addLink(opt, snEPR2, 'out', snInterference, 'in3', 0); % Replace 'in3' with the correct port

% Add Detectors
[opt, snD1] = addSink(opt, 'D1');
[opt, snD2] = addSink(opt, 'D2');

% Connect Interference Module to Detectors
[opt] = addLink(opt, snInterference, 'out1', snD1, 'in', 0); % Replace 'out1' with the correct port
[opt] = addLink(opt, snInterference, 'out2', snD2, 'in', 0); % Replace 'out2' with the correct port

% Define Simulation Frequencies
frequencies = logspace(-1, 3, 200)'; % 0.1 Hz to 1000 Hz

% Run Simulation
[fDC, sigDC, sigAC, mMech, noiseAC] = tickle(opt, [], frequencies);

% Display Results
disp('DC Fields:');
showfDC(opt, fDC);

disp('Probes (DC Signals):');
showsigDC(opt, sigDC);

% Analyze Transfer Functions and Quantum Noise
nD1 = getProbeNum(opt, 'D1');
h = getTF(sigAC, nD1, snEPR1);

% Plot Transfer Function
figure(1);
zplotlog(frequencies, abs(h));
title('Photon Detection Response for ETM Setup');
xlabel('Frequency (Hz)');
ylabel('Amplitude');
grid on;

% Plot Quantum Noise
noise = noiseAC(nD1, :)';
figure(2);
loglog(frequencies, abs(noise ./ h));
title('Quantum Noise Limit for ETM Setup');
xlabel('Frequency (Hz)');
ylabel('Noise Amplitude');
grid on;

disp('Simulation completed successfully.');
