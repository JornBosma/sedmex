function sse = p2sseNaN(p,Fs,z,h,gf)

% turn into column (if necessary)
p = p(:);
Nt = size(p,1);

% sampling period
dt = 1/Fs;

% remove trend (second order)
pNoTrend = NaNdetrend(p,2);

% NaNs?
id = find(isnan(pNoTrend));
if length(id) > length(p)*gf
    sse = NaN*p;  % number of NaNs too large: return NaN matrix
    return;
end

% fft p
pNoTrend(id) = 0;
Yp = fft(pNoTrend);

% determine the frequency axis for Yp
df = 1/(Nt*dt);
odd = (round(Nt/2)-(Nt/2) == 0.5);
if odd
   f = (0:(Nt-1)/2);
   f = [f,-(Nt-1)/2+f(1:(Nt-1)/2)];
else
   f = (0: Nt/2);
   f = [f,-Nt/2+f(2:(Nt/2))];
end
f = f(:)*df;

% get wavenumber (use linear theory)
Nf = length(f);
k = ones(Nf,1);
k(2:Nf) = w2k(2*pi*abs(f(2:Nf)),0,h,9.81);

% determine correction factor (linear theory)
if z>=0
   
   % sensor is above the bed
   factor = cosh(k*h)./cosh(k*z);
   
else
   
   % sensor is in the bed
   factor = cosh(k*h)./exp(k*z);
end
factor(1) = 1; % no correction for f = 0 Hz

% In the high-frequency tail of the spectrum, factors are huge and will amplify
% noise to unacceptable levels. There are various opportunities to kill these factors:
% 1) factor > sqrt(5-10) --> set it sqrt(5-10)
% 2) dS ./ L > 0.2-0.4 (Bishop and Donelan, 1987) [used here]
L = 2*pi./k;
dS = h - z;
maxFactor = 0.2; % to be on the safe side
factor(dS./L > maxFactor) = max(factor(dS./L <= maxFactor));  % set huge factors to the largest acceptable one

% apply correction
Ysse = Yp.*factor;

% convert back to time domain
sse = real(ifft(Ysse));

% put NaNs back in
sse(id) = NaN;

% ready
return
