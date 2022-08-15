% base parameters L1C2_OSSI

close all
clear
clc

sedmexInit
global basePath

% time axis
tStart = DBGetDatabaseEntry('instruments','L1C2_OSSI','timeIN',MET2sedmextime([2021 9 10 0 0 0])); % Dates are not used, output is start and end time
tEnd = DBGetDatabaseEntry('instruments','L1C2_OSSI','timeOUT',MET2sedmextime([2021 9 10 0 0 0]));
% dt = 30*60;   % dit is de tijdstap van de ADV bursts [s]
dt = 60*10;   % dit is de tijdstap van de pressure bursts [s]
tAxis = (tStart:dt:tEnd)';
Nt = length(tAxis);

% initialize parameter matrix
L1C2_OSSI_par = NaN([Nt 9]);
L1C2_OSSI_par(:,1) = tAxis;

% some settings
HFreq = [0.05 1];
LFreq = [0.005 0.05];

% now work through the time axis for pressure !
w8bar = waitbar(0, 'Starting');

for t = 1:Nt

   fprintf(1,'%i\n',t)
   waitbar(t/Nt, w8bar, sprintf('Progress: %d %%', floor(t/Nt*100)))
    
   try
       Fs = DBGetDatabaseEntry('instruments','L1C2_OSSI','sampleFrequency',tAxis(t));
       data = DBGetData('L1C2_OSSI',[tAxis(t) tAxis(t)+dt-1/Fs],{'p'});
   catch
       continue;
   end 

   p = data(:,2);
   if sum(isnan(p)) ~= length(p)
  
      % pressure data
      id = find(isnan(p));
      if ~isempty(id)
          if id(1) == 1
             p(id) = [];
          else
             p(id(1):end) = [];
          end
      end
      
      zInstrumentMANUAL = DBGetInstrumentHeightManual('L1C2_OSSI',{L1C2_OSSI_par(t,1)});
      zPT = zInstrumentMANUAL(2);
      if (sum((p + min(zPT,0)) > 0.04) > 0.99*length(p)) && ~isnan(zPT)
         h = mean(p) + zPT;                                   % total waterdepth
         sse = p2sseNaN(p,1/Fs,zPT,h,[0 1]);                  % to sea surface elevation in the [0 1] Hz range, OR instead use p2sse()
         sse = NaNdetrend(1:length(sse),sse,2);               % remove trend (second-order), OR instead use poly_detrend()
         sseHF = fft_filter(sse,1/Fs,HFreq(1),HFreq(2));    
         sseLF = fft_filter(sse,1/Fs,LFreq(1),LFreq(2));   

         % spectral analysis
         NFFT = floor(length(p)/5);
         [S,f] = pwelch(sse,NFFT,floor(0.5*NFFT),NFFT,Fs);    % estimate spectrum
         HF = f(f>=HFreq(1) & f <=HFreq(2));                  % the "high frequencies"  
         [dummy,id] = max(S(f>=HFreq(1) & f <= HFreq(2)));    % id in HF for Tpeak
      
         L1C2_OSSI_par(t,2) = h;                                       % total waterdepth 
         L1C2_OSSI_par(t,3) = zPT;                                     % z
         L1C2_OSSI_par(t,4) = 4*std(sseHF);                            % Hm0 HF
         L1C2_OSSI_par(t,5) = 1/(HF(id));                              % peak period
         L1C2_OSSI_par(t,6) = skewness(sseHF);                         % skewness HF
         L1C2_OSSI_par(t,7) = skewness(imag(hilbert(sseHF)));          % asymmetry HF
         L1C2_OSSI_par(t,8) = 4*std(sseLF);                            % Hm0 LF

         id = find(f >= HFreq(1) & f <= HFreq(2));
         Tm_10 = trapz(f(id),(f(id).^(-1)).*(S(id))) ./ trapz(f(id),S(id));  % Tm_10
         L1C2_OSSI_par(t,9) = Tm_10;                                   % Tm_10
      end
   end
      
end
close(w8bar)

save([basePath 'results' filesep 'OSSI' filesep 'baseParameters_L1C2_OSSI.mat'], 'L1C2_OSSI_par');
