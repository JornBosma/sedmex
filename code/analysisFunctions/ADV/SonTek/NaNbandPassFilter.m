function xF = NaNbandPassFilter(x,Fs,fband)

% apply bandPassFilter to series x which may contain NaNs
%
% INPUT
%    x, series [Nt x 1]
%    Fs, sampling frequency (Hz)
%    fband, [flow fhigh] Hz: frequency to include in bandpass
% OUTPUT
%    xF, bandpass-filtered series x [Nt x 1]
%
% Series x is detrended (second-order polynomial). NaNs are set to 0. The amplitude
% of frequencies outside fband are set to 0 and an inverse FFT is applied. NaNs are
% then put back. 
% 
% v1, Gerben Ruessink, 30-12-2012

% x should be a column
x = x(:);

% detrend (just to make sure...)
% x = NaNdetrend(x,2);

% number of observations
Nt = size(x,1);

% frequency axis
df = Fs/Nt;
odd = (round(Nt/2)-(Nt/2) == 0.5);
if odd
   f = 0:(Nt-1)/2;
   f = [f,-(Nt-1)/2+f(1:(Nt-1)/2)];
else
   f = 0: Nt/2;
   f = [f,-Nt/2+f(2:(Nt/2))];
end
f = f(:)*df;

% replace NaNs by 0
idNaN = isnan(x);
x(idNaN) = 0;

% fft data
Y = fft(x);

% apply band-pass filter
Y((abs(f) < fband(1)) | (abs(f) > fband(2))) = 0;

% inverse fft
xF = real(ifft(Y));

% put NaNs back
xF(idNaN) = NaN;

% ready
return
