Steps to create this database:

symbols:
+ create/add file
> run script
>> run command

01) create database folder structure
	+ code
        + analysisFunctions
        + bedLevel
        + dataAnalysis
			+ OSSI
		+ dataProcessing
		+ DB
		+ instruments
			+ OSSI
		+ other
		+ time
	+ data
        + GPS
		+ Keller
		+ OSSI
	+ dataRaw
		+ Keller
		+ OSSI
	+ DB
	+ docs
	+ results
        + OSSI
	+ readme.txt
02) create start-up file
	+ sedmexInit.m
	+ sedmexExit.m (optionally)
03) in subfolder code\time create time files, which define the starting date of the research period
	+ MET2sedmextime.m
	+ sedmex2METtime.m
	+ sedmextime2METstring.m
04) in subfolder code\other 
	a) create and run study-site file
		+ makeSiteEntries.m
		> makeSiteEntries.m (creates site.mat in DB folder)
	b) create file-naming function
		+ makeFileName.m
05) in folder DB create empty instrument file
	>> clear all (to empty workspace)
	>> save([basePath 'DB' filesep 'instruments.mat'])
	+ instruments.mat
06) in subfolder code\DB add database functions
	+ DBGetDatabase.m
	+ DBGetDatabaseEntry.m
    + DBGetInstrumentHeightManual.m
	+ addStructure2AvailableDataDB.m
07) in subfolder code\other add database functions
	+ readtext.m

08) in subfolder dataRaw\Keller add raw data of KellerAir
	+ _08_09_2021-00_00_00.TXT
09) in subfolder code\other
	a) create Keller (atmospheric pressure) meta data
		+ makeKellerDBentries.m
		> makeKellerDBentries.m (adds meta data to instruments.mat)
	b) create and run Keller (atmospheric pressure) processing file
		+ makeAirPressureFile.m
		> makeAirPressureFile.m (creates ref pressure data files)

10) in subfolder code\instruments\OSSI add OSSI-specific function files
	+ readOSSIinASCIIformat.m
	+ estimateOssiTimeOffset.m
	+ calibrateOSSI.m		
11) in subfolder code\analysisFunctions add the following function files
    + fft_filter.m
    + NaNdetrend.m
    + p2sseNaN.m
    + w2k.m
12) in subfolder dataRaw\OSSI add raw data of L1C2_OSSI
	+ WLOG_001.CSV
	+ WLOG_002.CSV
	+ ...
    + log
13) in subfolder code\other create and append OSSI meta data
	+ makeOSSIDBentries.m
	> makeOSSIDBentries.m (adds meta data to instruments.mat)
14) in subfolder code\dataProcessing\OSSI create and run OSSI processing file
	+ processL1C2_OSSI.m
	> processL1C2_OSSI.m (creates pressure data files)
15) in subfolder code\bedLevel create and run to generate file with manually recorded sensor height wrt the bed
    + makeManualBedLevelFileL1C2_OSSI.m
    > makeManualBedLevelFileL1C2_OSSI.m (adds sensor-height data to data\misc and meta data to instruments.mat)
16) in subfolder code\dataAnalysis\OSSI create and run OSSI anaylsis file
    + baseParametersL1C2_OSSI.m
    > baseParametersL1C2_OSSI.m (creates base-parameter data file in subfolder results\OSSI)
Repeat steps 12-16 for the other OSSI deployments.


