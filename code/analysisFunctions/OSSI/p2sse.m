function t_surf = p2sse(data,dt,z,h,fRange)

% t_surf = function p2sse(data,dt,z,h);
%
% Deze functie corrigeert een druksignaal m.b.v. lineaire golftheorie terug naar het oppervlak
% INPUT
%   data, de tijdserie
%   dt, de inwinperiode
%   z, de sensorhoogte (0 is de bodem, positief naar boven)
%   h, de totale waterdiepte
% OUTPUT
%   t_surf, de oppervlakte tijdserie

% maak kolom van "data"
data = data(:);

% bepaal en verwijder trend (2de orde polynoom)
Nt = size(data,1);
t = ((0:Nt-1)*dt)';
P = polyfit(t,data,2);
trend = polyval(P,t);
dataNoTrend = data - trend;

% fft data
Y = fft(dataNoTrend);

% bepaal de f as van Y
df = 1/(Nt*dt);
odd = (round(Nt/2)-(Nt/2) == 0.5);
if odd,
   f = (0:(Nt-1)/2);
   f = [f,-(Nt-1)/2+f(1:(Nt-1)/2)];
else
   f = (0: Nt/2);
   f = [f,-Nt/2+f(2:(Nt/2))];
end;
f = f(:)*df;

% bepaal de matrix k, golfgetal voor elke f
Nf = length(f);
k = ones(Nf,1);
k(2:Nf) = w2k(2*pi*abs(f(2:Nf)),0,h,9.81);

% bereken de correctie-factor (lineaire theorie)
if z>=0,
   
   % sensor is boven de bodem
   factor = cosh(k*h)./cosh(k*z);
   
else
   
   % sensor is in de bodem
   factor = cosh(k*h)./exp(k*z);
end;
factor(1) = 1;

% Vinden van te hoge factoren. Er zijn verscheidene mogelijkheden:
% 1) factor > sqrt(5-10) --> afkappen
% 2) dS ./ L > 0.2-0.4 (Bishop and Donelan, 1987) [HIER GEBRUIKT]
L = 2*pi./k;
dS = h - z;
maxFactor = 0.2; % aan de veilige kant
factor(dS./L > maxFactor) = max(factor(dS./L <= maxFactor));

% en binnen fRange
if exist('fRange','var'),
    factor(abs(f) < fRange(1) | abs(f) > fRange(2)) = 0;
end;

% toepassen factor
Y = Y.*factor;

% en terug naar tijdsdomein + trend er bovenop
t_surf = real(ifft(Y)) + trend;