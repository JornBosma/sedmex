% Process all SonTek ADV raw data from L2C5_SON1

% Deze file dient als basis voor het verwerken van een ADR file. De
% activiteiten voordat deze m-files gedraaid kan worden, zijn:
% (1) het inlezen van de ADR file in VIEWHYDRA,
% (2) omzetten naar beam coordinaten,
% (3) exporteren van alle variabelen. Zorg er verder dat de hd1 en ts1 file
% spaties hebben tussen alle kolommen. Gebruik TextPad om dit voor elkaar
% te krijgen (indien nodig).

close all
clear
clc

sedmexInit
global basePath

% ADV and site name in database
SN = 'L2C5_SON1';
load('instruments.mat', SN)
siteName = 'PHZ';

% where is the data?
rawDataPath = [basePath 'dataRaw' filesep 'ADV' filesep 'L2C5 SonTek Hydra #B329' filesep 'raw' filesep];

% file characteristics
fileInfo = dir([rawDataPath, '*.ts1']); % get list of filenames
nRawFiles = size(fileInfo, 1);

for i = 1:nRawFiles
    
    % just to be sure
    clear fileName dataRaw header Nbursts Nsamples Fs
    
    fileNumber = strrep(fileInfo(i).name, '.ts1','');
    fprintf('File %s\n', fileNumber);
    % lees ruwe data; de snelheden moeten beam-coordinaten zijn; gaat dit fout, dan moeten er ergens spaties worden toegevoegd.
    dataRaw = load([rawDataPath, fileNumber, '.ts1']);
    % lees header; gaat dit fout, dan moeten er ergens spaties worden toegevoegd.
    if i < 15 || i > 34
        header = load([rawDataPath, fileNumber, '.hd1']);
    else
        header = readmatrix([rawDataPath, fileNumber, '.hd1'], "FileType", "text", "NumHeaderLines", 1);
    end

    % aantal bursts, samples per burst en meetfrequentie
    Nbursts = header(end,1);
    Nsamples = header(1,9);
    Fs = header(1,8);

    % werk alles per burst af
    for b = 1:Nbursts
        
        % zet wat nuttige info op het scherm
        fprintf(1, 'Working on burst %i...\n', b);
        
        % STAP 1: prepareer output
        data = NaN(Nsamples,10);
    
        % Elke file krijgt een variable die "data" heet. Hier zijn het de
        % volgende kolommen:
        % 1 = SEDMEXtijd
        % 2 = u [m/s]  % kustdwars
        % 3 = v [m/s]  % kustlangs
        % 4 = w [m/s]  % verticaal
        % 5 = amp1 [dB]
        % 6 = amp2 [dB]
        % 7 = amp3 [dB]
        % 8 = cor1 [dB]
        % 9 = cor2 [dB]
        % 10 = cor3 [dB]
        
        % STAP 2: maak tijd-as
        year = header(b,2);
        mon = header(b,3);
        day = header(b,4);
        hour = header(b,5);
        minu = header(b,6);
        sec = header(b,7);
        ti = (0:Nsamples-1)';   
        when = NaN(Nsamples,6);
        when(:,1)= year;
        when(:,2) = mon;
        when(:,3) = day;
        if L2C5_SON1.summerTime % SEDMEX campaign should be in summertime
            when(:,4) = hour;
        else
            when(:,4) = hour+1; % if in wintertime add 1 hour
        end
        when(:,5) = minu;
        when(:,6) = sec + ti*(1/Fs);
        data(:,1) = MET2sedmextime(when);  % eerste kolom is altijd de tijd-as

%         when(:,5) = round((minu-30)/30)*30;  % change from end time of burst to starting time
%         when(:,6) = 0 + ti*(1/Fs);           % given that each burst starts exactly at 0 sec
%     %     data(:,1) = round(Fs*data(:,1))/Fs; % piece of BARDEXII code (seems superfluous)
            
        % STAP 3: kwaliteitscontrole op signaal amplitudes
        id = find(dataRaw(:, 1) == b);
        data(:, 5:7) = dataRaw(id, 6:8);               % amplitudes
        data(:, 8:10) = dataRaw(id, 9:11);             % correlaties
        thresholdAmp = 100;
        [RbadAmp, badAmpId] = ADVqualityControlAmplitudes(data(:,5:7), thresholdAmp);
        if any(RbadAmp > 0.05) % 5% is allowed, Elgar says about 1%, Feddersen about 10% 
            continue;           % sensor stond droog, ga verder met volgende burst
        end
    
        % STAP 4: druk
        % Het druksignaal uit de ADV wordt niet meer gebruikt.
            
        % STAP 5: temperatuur
        Temp = median(dataRaw(id, 15));
        writeTemperature(Temp, SN, data(1,1));
        
        % STAP 6: bodem
        bed(1) = header(b, 12)/100;     % hoogte transducer boven bodem; cm -> m
        bed(2) = header(b, 13)/100;     % hoogte meetvolume boven bodem; cm -> m
        if bed(1) > 0    % negatieve waarde = foutcode
            writeBedLevel(bed, SN, data(1,1));
        end
        
        % STAP 7: detecteren en vervangen van spikes op grond van correlatie methode
        [correctedV, Nspikes, spikesId] = despikeCorrelation(dataRaw(id,3:5),data(:,8:10),Fs,1);        
    
        % STAP 8: omzetten naar XYZ    
        T = DBGetDatabaseEntry('instruments',SN,'transformationMatrix',data(1,1));
        XYZ = beams2XYZ(correctedV,T);
        
        % STAP 9: roteren
        xOrient = DBGetDatabaseEntry('instruments',SN,'xOrientation',data(1,1));
        declination = DBGetDatabaseEntry('site',siteName,'declination',data(1,1));
    
        % positive x-axis ADV (with respect to true N)
        xOrient = mod(xOrient + declination,360);
     
        % shoreline and shore-normal
        SLdir = DBGetDatabaseEntry('site',siteName,'shorelineTrueN',data(1,1));
        SNdir = mod(SLdir - 90,360);
        
        % heading, pitch, roll
        heading = xOrient - SNdir;  % -sign required because xy is anticlockwise, and NESW is clockwise.
        pitch = median(dataRaw(id,13));
        roll = median(dataRaw(id,14));
      
    %     % omzetten van XYZ naar CLU en van cm/s naar m/s
    %     CLU = (XYZ2CLU(XYZ,heading,pitch,roll))/100;
        
        % omzetten van XYZ naar ENU en van cm/s naar m/s
        ENU = (XYZ2ENU(XYZ,heading,pitch,roll))/100;
    
        % STAP 10: phase-space despiking for ENU
        for s = 1:3
    
            % verwijder gemiddelde
            meanSensor = mean(ENU(:,s));
            Vseries = ENU(:,s) - meanSensor;
    
            % verwijder low-pass
            lowpass = fft_filter(Vseries, 1/Fs, 0, 0.03);
            Vseries = Vseries - lowpass;
    
            % pas phase-space methode Mori et al. (2007) toe
            [VseriesNoSpikes, ip] = func_despike_phasespace3d(Vseries);
            spikesId(ip,s) = 1;
            Nspikes(s) = sum(spikesId(:,s));
    
            % vul gaten op
            VseriesNoSpikes = fillGaps(VseriesNoSpikes,Vseries,3*Fs);
    
            % zet terug op originele plek
            ENU(:,s) = VseriesNoSpikes + meanSensor + lowpass;
        end
    
        % zet despike in data
        data(:,2) = ENU(:,1);
        data(:,3) = ENU(:,2);
        data(:,4) = ENU(:,3);
            
        % STAP 12: figuurtje
        figure(1);
        
        subplot 311
        plot(data(:,2));
        title (['Burst ', num2str(b)],'fontsize',11);
        ylabel('u (m/s)','fontsize',11);
        
        subplot 312
        plot(data(:,3));
        ylabel('v (m/s)','fontsize',11);
    
        subplot 313
        plot(data(:,4));
        ylabel('w (m/s)','fontsize',11);
     
        pause(1);
    
        fprintf(1, 'Writing data >>');
    
        % STAP 13: wegschrijven data 
        fileName = makeFileName(data(1,1), siteName, SN);
        save([basePath 'data' filesep 'ADV' filesep 'SonTek' filesep SN filesep fileName], 'data');
    
        % STAP 14: wegschrijven metadata
        meta.fileName = fileName;
        meta.timeIN = data(1,1);
        meta.timeOUT = data(end,1);
        meta.sampleFrequency = Fs;
        meta.u.pos = 2;
        meta.v.pos = 3;
        meta.w.pos = 4;
        meta.amp1.pos = 5;
        meta.amp2.pos = 6;
        meta.amp3.pos = 7;
        meta.r1.pos = 8;
        meta.r2.pos = 9;
        meta.r3.pos = 10;
        meta.u.unit = 'm/s';
        meta.v.unit = 'm/s';
        meta.w.unit = 'm/s';
        meta.amp1.unit = 'dB';
        meta.amp2.unit = 'dB';
        meta.amp3.unit = 'dB';
        meta.r1.unit = '%';
        meta.r2.unit = '%';
        meta.r3.unit = '%';
        meta.Nspikes = Nspikes;
        meta.spikesId = spikesId;
        meta.heading = heading;
        meta.roll = roll;
        meta.pitch = pitch;
        
        addStructure2AvailableDataDB(SN, meta);
    
        fprintf(1,' done!\n\n')
    
    end
end
fprintf(2,' Processing finished!\n\n')

close

% uitlezen van de data uit de database gaat met DBGetData
% Type "help DBGetData" voor informatie en probeer de verschillende opties uit.
% Voorbeeld: data = DBGetData(SN,[from to],{'u'});
% from en to zijn SEDMEX tijden, en de gewenste variabele is u.
% Ander voorbeeld: data = DBGetData(SN,[from to],{'u','v'});
% Nu worden u en v uit de database gehaald.
% En nog eentje: data = DBGetData(SN,[from],{'u','v'});
% Er is nu maar een tijdscodering. Dit betekent dat de u en v uit de burst
% waarin "from" zit, worden teruggegeven.
