function dataFilt = fft_filter(data, dt, flow, fhigh)

% function dataFilt = fft_filter(data, dt, flow, fhigh);
% 
% fft_filter is een spectrale filteractie waarbij de niet gewenste frequenties op 0 worden
% gezet.
% flow en fhigh bepalen of het filter een low-pass, high-pass of band-pass is
% flow = 0 --> low-pass
% fhigh = fNyq --> high-pass
% anders: band-pass
%
% INPUT
%   data is tijdserie die spectraal gefilterd moet worden {elders gedetrend!}
%   dt is inwinningseenheid {in s}
%   flow is laagste te behouden frequentie
%   fhigh is hoogste te behouden frequentie
% OUTPUT
%   dataFilt is de gefilterde tijdserie

% enkele basis zaken
data = data(:);
[Nt, Nx] = size(data);
df = 1/(Nt*dt);

% fft data
Y = fft(data);

% bepaal de f as van Y
odd = (round(Nt/2)-(Nt/2) == 0.5);
if odd,
   f = [0:(Nt-1)/2];
   f = [f,-(Nt-1)/2+f(1:(Nt-1)/2)];
else
   f = [0: Nt/2];
   f = [f,-Nt/2+f(2:(Nt/2))];
end;
f = f(:)*df;

% zoek alle frequenties die weg moeten
t = ((abs(f)< flow) | (abs(f) > fhigh));

% en zet die op 0
Y(t) = 0;

% terug naar tijdsdomein
dataFilt = real(ifft(Y));

