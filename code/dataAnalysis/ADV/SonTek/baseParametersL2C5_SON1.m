% compute base parameters L2C5_SON1

close all
clear
clc

sedmexInit
global basePath

% time axis
tStart = DBGetDatabaseEntry('instruments','L1C2_OSSI','timeIN',MET2sedmextime([2021 9 10 0 0 0]));
tEnd = DBGetDatabaseEntry('instruments','L1C2_OSSI','timeOUT',MET2sedmextime([2021 9 10 0 0 0]));
dt = 30*60;   % dit is de tijdstap van de ADV bursts
tAxis = (tStart:dt:tEnd)';
Nt = length(tAxis);

% initialize parameter matrix
L2C5_SON1_par = NaN([Nt 16]); % excludes pressure data (deemed unreliable)
L2C5_SON1_par(:,1) = tAxis;

% some settings
HFreq = [0.05 1];
LFreq = [0.005 0.05];
dryThreshold = 0.04;
Fs = 10;

% sensorhoogte gebaseerd op SRPS i.p.v. eigenbodemschatting
% zADVsrps = DBGetInstrumentHeight('L2C5_SON1',{tAxis},'SRPS');
zADVmanual = DBGetInstrumentHeightManual('L2C5_SON1',{tAxis});
% zADV = zADVsrps;
% id = isnan(zADVsrps(:,2));
% zADV(id,2) = zADVmanual(id,2);
% zADV(:,2) = interp1(zADV(~isnan(zADV(:,2)),1),zADV(~isnan(zADV(:,2)),2),zADV(:,1));
% 

% nu nog alleen de handmatig gemeten hoogten
zADV = zADVmanual;
zPT = zADV(:,2) + 0.4;   % 0.4 is hoogte PT boven transducer vlak

% now work through the time axis
w8bar = waitbar(0, 'Starting');

for t = 1:Nt

   fprintf(1,'%i\n',t)
   waitbar(t/Nt, w8bar, sprintf('Progress: %d %%', floor(t/Nt*100)))
    
   % read the data
   try
       L2C5_SON1data = DBGetData('L2C5_SON1',tAxis(t),{'u','v','w'});   
   catch
       continue
   end

   if ~isnan(L2C5_SON1data(1,2))
  
      % velocity data

      u = L2C5_SON1data(:,2);                                    % u, m/s
      v = L2C5_SON1data(:,3);                                    % v, m/s
      w = L2C5_SON1data(:,4);                                    % w, m/s

      [meanAngle,dirSpread] = directionalWaveParameters(u,v,HFreq,Fs);  % angle and spread
      L2C5_SON1_par(t,2) = meanAngle;                              % mean angle [based on pca analysis]
      L2C5_SON1_par(t,3) = dirSpread;                              % spread
      
      uHF = fft_filter(u,1/Fs,HFreq(1),HFreq(2));                  % high-frequency u
      vHF = fft_filter(v,1/Fs,HFreq(1),HFreq(2));                  % high-frequency v
      wHF = fft_filter(w,1/Fs,HFreq(1),HFreq(2));                  % high-frequency w
      uLF = fft_filter(u,1/Fs,LFreq(1),LFreq(2));                  % low-frequency u
      vLF = fft_filter(v,1/Fs,LFreq(1),LFreq(2));                  % low-frequency v
      
      L2C5_SON1_par(t,4) = var(uHF);                               % variance uHF
      L2C5_SON1_par(t,5) = var(vHF);                               % variance vHF
      L2C5_SON1_par(t,6) = sqrt(L2C5_SON1_par(t,4)+L2C5_SON1_par(t,5));        % horizontal rms HF
      L2C5_SON1_par(t,7) = var(wHF);                               % variance wHF
      L2C5_SON1_par(t,8) = var(uLF);                               % variance uLF
      L2C5_SON1_par(t,9) = var(vLF);                               % variance vLF
      L2C5_SON1_par(t,10) = sqrt(L2C5_SON1_par(t,8)+L2C5_SON1_par(t,9));       % horizontal rms LF
      
      L2C5_SON1_par(t,11) = mean(u);                               % mean u
      L2C5_SON1_par(t,12) = mean(v);                               % mean v
      L2C5_SON1_par(t,13) = mean(w);                               % mean w

      L2C5_SON1_par(t,14) = mean(v.*sqrt(u.^2 + v.^2));            % quadratic term mean(v(u^2+v^2)^0.5) 
      
      L2C5_SON1_par(t,15) = skewness(uHF);                         % velocity skewness
      L2C5_SON1_par(t,16) = skewness(imag(hilbert(uHF)));          % velocity asymmetry

%       % pressure data
%       p = L2C5_SON1data(:,5);
%       if sum(p > dryThreshold) > 0.99*length(p)
%           
%              h = mean(p) + zPT(t);
%              sse = p2sse(p,1/Fs,zPT(t),h,[0 1]);               % to sea surface elevation in the [0 1] Hz range
%              sse = poly_detrend(1:length(sse),sse,2);          % remove trend (second-order)
%              sseHF = fft_filter(sse,1/Fs,HFreq(1),HFreq(2));   % HF 
%              sseLF = fft_filter(sse,1/Fs,LFreq(1),LFreq(2));   % LF
%              [S,f] = pwelch(sse,[],[],[],Fs);                  % compute spectrum, use default values ([], see help pwelch)  
%              id = find(f >= HFreq(1) & f <= HFreq(2));
%              Tm_10 = trapz(f(id),(f(id).^(-1)).*(S(id))) ./ trapz(f(id),S(id));  % Tm_10
% 
%              L2C5_SON1_par(t,17) = h;
%              L2C5_SON1_par(t,18) = zPT(t);
%              L2C5_SON1_par(t,19) = 4*std(sseHF);
%              L2C5_SON1_par(t,20) = 4*std(sseLF);
%              L2C5_SON1_par(t,21) = Tm_10;
% 
%       end
      
   end
   
end
close(w8bar)

figure; plot(L2C5_SON1_par(:,1),L2C5_SON1_par(:,4));

save([basePath 'results' filesep 'ADV' filesep 'SonTek' filesep 'baseParameters_L2C5_SON1.mat'], 'L2C5_SON1_par');
