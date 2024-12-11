function simulateETMSingleSource()
    % Simulate an ETM setup for generating multiphoton entangled states using Optickle.

    try
        % Initialize the MATLAB environment
        % disp('Initializing simulation environment...');
        % close all;  % Close any open figures
        % clear;      % Clear workspace variables
        % clc;        % Clear command window

        % Initialize the Optickle model
        disp('Initializing Optickle model...');
        lambda = 780e-9; % Wavelength in meters (780 nm)
        vFrf = 0;        % RF frequencies (none for simplicity)
        opt = Optickle(vFrf, lambda);

        % Add Laser Source
        disp('Adding laser source...');
        laserPower = 30e-3; % 30 mW
        [opt, snLaser] = addSource(opt, 'Ti:Sapphire Laser', sqrt(laserPower));

        % Add Second-Harmonic Generation (SHG)
        disp('Adding SHG module...');
        [opt, snSHG] = addSink(opt, 'SHG', 1);
        [opt] = addLink(opt, snLaser, 'out', snSHG, 'in', 0);

        % Add Spatial Compensation (SC)
        disp('Adding spatial compensation...');
        [opt, snSC] = addSink(opt, 'SC', 1);
        [opt] = addLink(opt, snSHG, 'out', snSC, 'in', 0);

        % Add Temporal Compensation (TC)
        disp('Adding temporal compensation...');
        [opt, snTC] = addSink(opt, 'TC', 1);
        [opt] = addLink(opt, snSC, 'out', snTC, 'in', 0);

        % Add Dynamic Delay Line
        disp('Adding dynamic delay line...');
        [opt, snDelayLine] = addSink(opt, 'DelayLine', 1);
        [opt] = addLink(opt, snTC, 'out', snDelayLine, 'in', 0);

        % Add Multiphoton Interference Module
        disp('Adding interference module...');
        [opt, snInterference] = addSink(opt, 'Interference', 2);

        % Create a combiner to merge EPR inputs
        disp('Creating combiner for EPR inputs...');
        [opt, snCombiner] = addSink(opt, 'Combiner', 2); % Ensure it has 2 input ports

        % Add EPR Photon Sources
        disp('Adding EPR photon sources...');
        [opt, snEPR1] = addSource(opt, 'EPR1', sqrt(laserPower));
        [opt, snEPR2] = addSource(opt, 'EPR2', sqrt(laserPower));
        
        % apparently not necessary?
        % Connecting EPR sources to the combiner...
        % An error occurred during the simulation:
        % Unavailable Sink: EPR1->out already linked to Combiner<-in
        % Connect EPR sources to different inputs of the combiner
        % disp('Connecting EPR sources to the combiner...');
        % [opt] = addLink(opt, snEPR1, 'out', snCombiner, 'in', 0); 
        % [opt] = addLink(opt, snEPR2, 'out', snCombiner, 'in', 1); 

        % Connect Combiner to Interference Module
        disp('Connecting combiner to interference module...');
        [opt] = addLink(opt, snCombiner, 'out', snInterference, 'in', 0);

        % Add Probes
        disp('Adding probes to the model...');
        %[opt, snProbeD1] = addProbe(opt, 'ProbeD1', snInterference, 'out', 0); % Measure output 0 of Interference
        % [opt, snProbeD2] = addProbe(opt, 'ProbeD2', snInterference, 'out', 1); % Measure output 1 of Interference

        % Debugging: Check probe numbers
        disp('Fetching probe numbers...');
        nProbeD1 = getProbeNum(opt, 'ProbeD1');
        nProbeD2 = getProbeNum(opt, 'ProbeD2');
        disp(['ProbeD1: ', num2str(nProbeD1)]);
        disp(['ProbeD2: ', num2str(nProbeD2)]);

        % Define Simulation Frequencies
        disp('Defining simulation frequencies...');
        frequencies = logspace(-1, 3, 200)';
        disp(['Frequency range: ', num2str(frequencies(1)), ' to ', num2str(frequencies(end))]);

        % Run Simulation
        disp('Running simulation...');
        disp('Checking Optickle object...');
        disp(opt); % Display object details for debugging

        [fDC, sigDC, sigAC, mMech, noiseAC] = tickle(opt, [], frequencies);

        % Debugging: Check simulation results
        disp('Simulation results:');
        disp(['Size of fDC: ', mat2str(size(fDC))]);
        disp(['Size of sigDC: ', mat2str(size(sigDC))]);
        disp(['Size of sigAC: ', mat2str(size(sigAC))]);

        % Display Results
        disp('DC Fields:');
        showfDC(opt, fDC);

        disp('Probes (DC Signals):');
        showsigDC(opt, sigDC);

        % Analyze Transfer Functions and Quantum Noise
        disp('Analyzing transfer functions...');
        disp('Checking sigAC...');
        disp(['Size of sigAC: ', mat2str(size(sigAC))]);

        h = getTF(sigAC, nProbeD1, snEPR1);
        disp(['Size of transfer function h: ', mat2str(size(h))]);

        % Plot Transfer Function
        figure(1);
        zplotlog(frequencies, abs(h));
        title('Photon Detection Response for ETM Setup');
        xlabel('Frequency (Hz)');
        ylabel('Amplitude');
        grid on;

        % Plot Quantum Noise
        disp('Plotting quantum noise...');
        noise = noiseAC(nProbeD1, :)';
        disp(['Size of noise: ', mat2str(size(noise))]);
        figure(2);
        loglog(frequencies, abs(noise ./ h));
        title('Quantum Noise Limit for ETM Setup');
        xlabel('Frequency (Hz)');
        ylabel('Noise Amplitude');
        grid on;

        disp('Simulation completed successfully.');

    catch ME
        % Error handling
        disp('An error occurred during the simulation:');
        disp(ME.message);
        disp('Stack trace:');
        for k = 1:length(ME.stack)
            disp(['File: ', ME.stack(k).file]);
            disp(['Name: ', ME.stack(k).name]);
            disp(['Line: ', num2str(ME.stack(k).line)]);
        end
    end
end