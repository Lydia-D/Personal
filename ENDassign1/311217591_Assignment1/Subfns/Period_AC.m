%% L Drabsch 24/3/16
% Find period of orbit with autocorrelation based on Wiener-Khinchin Theorem
% Inputs: X = signal to analyse, eg X_ECI
%         dt = timestep (s)
% Output: P = period (hours)

function P = Period_AC(X,dt)
    Fr = fft(X);
    S = Fr.*conj(Fr);
    R = ifft(S);
    [~,loc] = findpeaks(R);
    P = loc(1)*dt/(60*60);
end