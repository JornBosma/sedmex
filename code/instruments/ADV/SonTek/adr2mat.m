function [varargout]=adr2mat(adrname,varargin)

%ADR2MAT:Read the binary file from an ADV recorder into
%a struct in the workspace
%
%syntax: [xyz]=adr2matc2(adrname,[btORbk])
%Input:
%	adrname: the binary file name, a string;
%
% 	btORbk -when it is bk (blocksize): 
%		an integer value in MB, optional. 
%	 	It allows users to save the struct (xyz), read 
%	 	from a LARGE binary file, into multiple mat files 
%	 	when the computer memory is limited.
%      
%	 	btORbk<=0, No mat file saved, same as 
%	  	btORbk being ommited, default.
%   
%	 	btORbk>0, divides the binary file into 
%	  	blocks of [btORbk] (approximately) MB
%	  	and save each block, along with the metadata, 
%	  	into a mat file identified by the ADV serial 
%	  	number. The saved file could be several 
%	  	times larger than btORbk MB.
%
% 	btORbk -when it is bt (burst range):
%		In the form of [b0, b1] where b0 and b1 represent the
%		starting and ending burst numbers. It MUST have two values
%		and b1 >= b0.
%
%Output:
%	xyz: the struct. that holds everything, optional
%
% jpx @ usgs, 04-20-01
% jpx @ usgs, 12-10-03, to handle different sampling of different record types

if ~ispc
   error('This program does NOT work on MAC.');
   return;
end;
if nargin<1 | ~ischar(adrname)
   help(mfilename);
   return;
end;
if nargin>1
   btORbk=varargin{1};
   if length(btORbk)<2
      btORbk=[btORbk -1E+10];
   end;
else
   btORbk=[1E+10 -1E+10];
end;
fid=fopen(adrname);
fseek(fid,0,1);%fast forward to end
filesize=ftell(fid);
fseek(fid,0,-1); %rewind to beginning
%fclose(fid);return;
%---read hardware config. (24 byptes)----
pointer2={'down','up','side'};
pointer3={'No','Yes'};
a=fread(fid,2,'uchar');
b.cpusoftwarevernum=num2str(0.1*a(1),'%2.1f');
b.dspsoftwarevernum=num2str(0.1*a(2),'%2.1f');
a=fread(fid,6,'char');
%b.advtype=pointer1{1+a(1)};
b.sensororientation=pointer2{1+a(2)};
b.compassinstalled=pointer3{1+a(3)};
b.recorderinstalled=pointer3{1+a(4)};
b.tempinstalled=pointer3{1+a(5)};
b.pressinstalled=pointer3{1+a(6)};

a=fread(fid,2,'int32');
b.pressscale=a(1);
b.pressoffset=a(2);
b.compassoffset=fread(fid,1,'int16');
a=fread(fid,3,'char');
b.pressfreqoffset=a(1);
b.extsensorinstalled=a(2);
if a(3)>0
pointer1={'Paros','Druck','ParosFreq'};
b.extpressinstalled=pointer1{a(3)};
end;
b.pressscale_2=fread(fid,1,'int16');
b.ctdinstalled=fread(fid,1,'char');

%---read probe config. (164 byptes)----
pointer1={'DOWN XYZ 5CM','DOWN XYZ 5CM','UP XYZ 5CM','SIDE XYZ 5CM',...
      'DOWN XZ 5CM','UP XZ 5CM','SIDE XY 5CM','CABLE XYZ 5CM',...
      'DOWN XYZ 10CM','UP XYZ 10CM','SIDE XYZ 10CM',...
      'DOWN XZ 10CM','UP XZ 10CM','SIDE XY 10CM','CABLE XYZ 10CM',...
      'OCEAN PROBE','Micro DOWN XYZ 5CM','Micro UP XYZ 5CM',...
      'Micro SIDE XYZ 5CM','Micro DOWN XZ 5CM','Micro UP XZ 5CM',...
      'Micro SIDE XY 5CM','Micro CABLE XYZ 5CM'};
pointernum=[0 1 2 3 4 5 6 10 17 18 19 20 21 22 26 41 81 82 83 84 85 86 90];
fseek(fid,10,0);
a=fread(fid,[1,6],'char');
a(a==0)=[];
b.serialnum=char(a);
a=fread(fid,2,'char');
indx=find(pointernum==a(1));
b.probetype=pointer1{indx};
fseek(fid,102,0);
b.xfercoeff=fread(fid,[3,3],'float32');
b.xmtrecdist=fread(fid,1,'float32');
b.calcw=fread(fid,1,'float32');

%---read deployment parameter (253 byptes)----
pointer1={'User value','Measured'};
pointer2={'Disable','Start','Sample'};
pointer3={'Beam','XYZ','ENU'};
pointer4(1,:)={'v1','v2','v3'};
pointer4(2,:)={'Vx','Vy','Vz'};
pointer4(3,:)={'u','v','w'};
a=fread(fid,2,'uchar');
b.configtype=a(1);
b.configver=a(2);
b.nbytes=fread(fid,1,'uint16');
fseek(fid,8,0); %skip config time
a=fread(fid,3,'int16');
b.temp=0.1*a(1); %deg C
b.sal=0.1*a(2); %ppt
b.cw=0.1*a(3); %m/s
a=fread(fid,2,'uchar');
b.tempmode=pointer1{1+a(1)};
b.velrangeind=a(2);
a=fread(fid,2,'uchar');
b.syncmode=pointer2{1+a(1)};
b.coordsystem=pointer3{1+a(2)};
vnames=pointer4(1+a(2),:);
a=fread(fid,[3,3],'uint16');
b.samprate=0.01*a(:,1)'; %Hz
b.burstinterval=a(:,2)'; %seconds
b.sampleperburst=a(:,3)';
b.rectype=fread(fid,[1,3],'uchar');
bitsize=[0 3 4 0 0 4 6 4];
rectype=[];rflag=[];
for irec=1:3,
	tata=dec2bin(b.rectype(irec));
	rectype2='00000000';
	rectype2(8-length(tata)+1 : 8)=tata;
	rflag2=str2num(rectype2(:))';
	sampsize(irec)=8+sum(bitsize(rflag2>0));
   rectype=[rectype;fliplr(rectype2)];
   rflag=[rflag;rflag2];
end;
pointer1={'Auto','Polled'};
pointer2={'Binary','Ascii'};
pointer3={'DISABLED','ENABLED'};
pointer4={'NORMAL MODE','BUFFER MODE'};
a=fread(fid,5,'char');
b.outmode=pointer1{1+a(1)};
b.outformat=pointer2{1+a(2)};
b.recorderenabled=pointer3{1+a(3)};
b.recordermode=pointer4{1+a(4)};
b.deploymentmode=pointer3{1+a(5)};
a=fread(fid,[1,9],'char');
a(a==0)=[];
b.deploymentname=char(a);
datetime(1)=fread(fid,1,'int16');
a=fread(fid,6,'char');
b.begindeploymentdatetime=[datetime,a(2),a(1),a(4),a(3),a(6),a(5)];
comments=[];
for j=1:3
	a=char(fread(fid,[1,60],'char'));
	a(a==0)=[];
	eval(['b.comment' num2str(j) '=a;']);
end;
b.autosleep=fread(fid,1,'char');
fseek(fid,7,0);
fprintf('\nBurst: ');
burst0=0;
newstart=0;
fnum=0;
saved=0;
endflag=0;
while ~feof(fid)
	%---read burst header (60 byptes)----
	fseek(fid,14,0);
   burst=fread(fid,1,'uint32');
	if isempty(burst)
		break;
   end;
   if diff(btORbk)>=0 & burst>btORbk(2)
      break;
   end;
   burst=burst-burst0;
	datetime(1)=fread(fid,1,'int16');
	a=fread(fid,6,'char');
	fseek(fid,2,0);
   a1=fread(fid,2,'uint16');
   samprate=0.01*a1(1);
   spb=a1(2);
   idx1=find(b.samprate==samprate);
   idx2=find(b.sampleperburst==spb);
   if isequal(idx1,idx2)
      jrec=idx1;
   else
      error('Something wrong with the data!');
   end;
   
   burstsize=rflag(jrec,4)*38 + rflag(jrec,1)*16 +spb*sampsize(jrec);
	if burstsize > (filesize-ftell(fid)+1)
		fprintf('\n\nBurst # %d is not full therefore abandoned.',burst+burst0);
      burst=burst-1;
      endflag=1;
		break;
	end;
   fseek(fid,2,0);
   a2=fread(fid,1,'uint16');
   a3=fread(fid,2,'int16');
   a4=fread(fid,[1,20],'uchar');
  	if diff(btORbk)<0 | burst>= btORbk(1)
      fprintf(['\n' num2str(burst+burst0) '...']);
  	end;
   
 if diff(btORbk)>=0 & burst<btORbk(1)
   c=[];
   fseek(fid,burstsize,0);
 else
   if diff(btORbk)>=0
      burst=burst-btORbk(1)+1;
   end;
	c.time(burst,1)=julian([datetime,a(2),a(1),a(4),a(3),a(6)+0.01*a(5)]);
	c.samprate(burst,1)=0.01*a1(1); %Hz
 	c.sampleperburst(burst,1)=spb;
	c.soundspd(burst,1)=0.1*a2; % m/s
	c.brange(burst,1)=0.01*a3(1); % cm
	c.vbrange(burst,1)=0.01*a3(2); % cm
	c.status(burst,:)=a4;
   vel1=0.01*fread(fid,spb,'int16',sampsize(jrec)-2);
   fseek(fid,-sampsize(jrec)*spb+2,0);
   vel2=0.01*fread(fid,spb,'int16',sampsize(jrec)-2);
   fseek(fid,-sampsize(jrec)*spb+2,0);
   vel3=0.01*fread(fid,spb,'int16',sampsize(jrec)-2);
   fseek(fid,-sampsize(jrec)*spb+2,0);
   eval(['c.' vnames{1} '{burst}(:,1)=vel1;']);
   eval(['c.' vnames{2} '{burst}(:,1)=vel2;']);
   eval(['c.' vnames{3} '{burst}(:,1)=vel3;']);
   if isequal(rectype(jrec,1),'1')
     for kk=1:6
   	ampcorr(:,kk)=fread(fid,spb,'uchar',sampsize(jrec)-1);
      fseek(fid,-sampsize(jrec)*spb+1,0);
     end;
     c.amp{burst}=ampcorr(:,1:3);
     c.corr{burst}=ampcorr(:,4:6);
     ampcorr=[];
   else
     for kk=1:2
   	ampcorr(:,kk)=fread(fid,spb,'uchar',sampsize(jrec)-1);
      fseek(fid,-sampsize(jrec)*spb+1,0);
     end;
    c.amp{burst}=ampcorr(:,1);
     c.corr{burst}=ampcorr(:,2);
     ampcorr=[];
   end;
 if isequal(rectype(jrec,2),'1')
   c.heading{burst}(:,1)=0.1*fread(fid,spb,'int16',sampsize(jrec)-2);
   fseek(fid,-sampsize(jrec)*spb+2,0);
   c.pitch{burst}(:,1)=0.1*fread(fid,spb,'int16',sampsize(jrec)-2);
   fseek(fid,-sampsize(jrec)*spb+2,0);
   c.roll{burst}(:,1)=0.1*fread(fid,spb,'int16',sampsize(jrec)-2);
   fseek(fid,-sampsize(jrec)*spb+2,0);
 end;
 if isequal(rectype(jrec,3),'1')
   c.temperature{burst}(:,1)=0.01*fread(fid,spb,'int16',sampsize(jrec)-2);
   fseek(fid,-sampsize(jrec)*spb+2,0);
   c.pressure{burst}(:,1)=fread(fid,spb,'int16',sampsize(jrec)-2);
   fseek(fid,-sampsize(jrec)*spb+2,0);
 end;
 if isequal(rectype(jrec,6),'1')
   c.extsensor{burst}(:,1)=fread(fid,spb,'int16',sampsize(jrec)-2);
   fseek(fid,-sampsize(jrec)*spb+2,0);
   c.extsensor{burst}(:,2)=fread(fid,spb,'int16',sampsize(jrec)-2);
   fseek(fid,-sampsize(jrec)*spb+2,0);
 end;
 if isequal(rectype(jrec,7),'1')
  c.extpress{burst}(:,1)=fread(fid,spb,'ubit24',(sampsize(jrec)-3)*8);
   fseek(fid,-sampsize(jrec)*spb+3,0);
 end;
 fseek(fid,sampsize(jrec)*(spb-1),0);
 if isequal(rectype(jrec,5),'1')
      means=[fread(fid,[1,6],'uchar'),...
		0.1*fread(fid,[1,3],'int16'),...
		0.01*fread(fid,1,'int16'),...
		fread(fid,[1,1],'int32')];       
		stds=[fread(fid,[1,6],'uchar'),...
		0.1*fread(fid,[1,3],'int16'),...
		0.01*fread(fid,1,'int16'),...
		fread(fid,[1,1],'int16')];   
		c.mean(burst,:)=[means mean([vel1 vel2 vel3])];
      c.std(burst,:)=[stds std([vel1 vel2 vel3])];
		c.soundspeed(burst,1)=fread(fid,1,'uint16');
 end;
 if isequal(rectype(jrec,8),'1')
   c.ctd(burst,:)=fread(fid,[1,4],'int32');
 end;
fseek(fid,2,0); % checksum
whereisit=ftell(fid);
if diff(btORbk)<0 & whereisit-newstart > btORbk(1)*1024*1024 % btORbk MB
   c.burstrange=[burst0+1 burst+burst0];
   c.metadata=b;
   burst0=burst+burst0;
   newstart=whereisit;
   fnum=fnum+1;
   matname=[b.serialnum '_' num2str(fnum)];
   fprintf('\nThe above bursts are saved in file [%s.mat]\n',matname);
   advdata=c;
   save(matname,'advdata');
   c=[];
   saved=1;
end;
%	if burst==2 break;end;
end;
end;  %while
if diff(btORbk)>=0
   c.burstrange=btORbk;
end;
fclose(fid);
c.metadata=b;
varargout{1}=c;
if saved & endflag 
   c.burstrange=[burst0+1 burst+burst0];
   fnum=fnum+1;
   matname=[b.serialnum '_' num2str(fnum)];
   fprintf('\nThe above bursts are saved in file [%s.mat]\n',matname);
   advdata=c;
   save(matname,'advdata');
end;
fprintf('\nCompleted.\n');
return;
