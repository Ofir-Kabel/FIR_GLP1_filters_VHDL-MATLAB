clc;
close all;
clear;

fs=44e3;
N=80;
Lfft=1024;

%filters frequencies
fstopL=3e3;
fpassH=19e3;
fcL=8e3;
fcH=14e3;

%signal frequencies
f0=1e3;
f1=11e3;
f2=21e3;

QSL=2*pi*fstopL/fs;
QPH=2*pi*fpassH/fs;
QCL=2*pi*fcL/fs;
QCH=2*pi*fcH/fs;

n=0:N/2;

%Blackman
wn=0.42-0.5*cos(2*pi.*n/N)+0.08*cos(4*pi.*n/N);
D=12*pi/(N+1);

%Hann
% wn=0.5-0.5*cos(2*pi.*n/N);
% D=8*pi/(N+1);

%Hamming
% wn=0.5-0.5*cos(2*pi.*n/N);
% D=8*pi/(N+1);

%rectangular
% wn=ones(1,N/2);
% D=4*pi/(N+1);

[hnL,n] = LPF(N,QSL,wn);
hnH = HPF(N,QPH,wn);
hnS = LPF(N,QCL,wn)+HPF(N,QCH,wn);      %sum of LPF and Hpf
hnP = conv(LPF(N,QCH,wn),HPF(N,QCL,wn));%conv between LPF and HPF(conv as shiftting func by pi)

% normalization to 1
% hnL=hnL/max(hnL);
% hnH=hnH/max(hnH);
% hnS=hnS/max(hnS);
% hnP=hnP/max(hnP);

fline=0:fs/Lfft:fs*(1-1/Lfft);

%changed freq signal 
% t = 0:0.001:100;
% t_size=length(t)-1;
% f_in_start = 1;
% f_in_end = 20000;
% f_in = linspace(f_in_start, f_in_end, length(t));
% y = sin(2*pi * f_in .* t);
% 
% figure(10)
% semilogx(t,y)
% xlim([0 100]);

sig1 = sin(2*pi.*n*f0/fs);
sig2 = sin(2*pi.*n*f1/fs);
sig3 = sin(2*pi.*n*f2/fs);
sig = sig1+sig2+sig3;

sig=sig/max(sig);

yL=conv(sig,hnL);
yH=conv(sig,hnH);
yS=conv(sig,hnS);
yP=conv(sig,hnP);

%fft
hpL=fft(hnL,Lfft)/max(fft(hnL,Lfft));
hpH=fft(hnH,Lfft)/max(fft(hnH,Lfft));
hpS=fft(hnS,Lfft)/max(fft(hnS,Lfft));
hpP=fft(hnP,Lfft)/max(fft(hnP,Lfft));

sigP=fft(sig,Lfft)/max(fft(sig,Lfft));
yLP=fft(yL,Lfft)/max(fft(yL,Lfft));
yHP=fft(yH,Lfft)/max(fft(yH,Lfft));
ySP=fft(yS,Lfft)/max(fft(yS,Lfft));
yPP=fft(yP,Lfft)/max(fft(yP,Lfft));

% hpL1=fft(hnL1,Lfft)/max(fft(hnL1,Lfft));
% hpH1=fft(hnH1,Lfft)/max(fft(hnH1,Lfft));

fixed_point_format = numerictype; % Signed, 16-bit word length, 15 fractional bits
hnFPL = fi(hnL, fixed_point_format);
int_LP = hnFPL.int; % Get the integer representation of the fixed-point numbers
hex_LP = dec2hex(int_LP,4); % Get the integer representation of the fixed-point numbers

hnFPH = fi(hnH, fixed_point_format);
int_HP = hnFPH.int; % Get the integer representation of the fixed-point numbers
hex_HP = dec2hex(int_HP,4); % Get the integer representation of the fixed-point numbers

hnFS = fi(hnS, fixed_point_format);
int_SF = hnFS.int; % Get the integer representation of the fixed-point numbers
hex_SF = dec2hex(int_SF,4); % Get the integer representation of the fixed-point numbers

hnFP = fi(hnP, fixed_point_format);
int_PF = hnFP.int; % Get the integer representation of the fixed-point numbers
hex_PF = dec2hex(int_PF,4); % Get the integer representation of the fixed-point numbers

sigFP = fi(sig, fixed_point_format);
int_sig = sigFP.int; % Get the integer representation of the fixed-point numbers
hex_sig = dec2hex(int_sig,4); % Get the integer representation of the fixed-point numbers


fileID = fopen('FIR_GLP1_coeff.txt', 'w');
fprintf(fileID, 'constant N : positive:=%d;',N);
fprintf(fileID, '\n\n--LPF_coeff\n\ntype coeff_array is array (0 to %d) of std_logic_vector(15 downto 0);',N);
fprintf(fileID, '\n signal LPF_coeff : coeff_array :=\n');
for i = 1:length(hex_LP)
    if(i==1)
    fprintf(fileID, '(x"%s",', hex_LP(i,:));
    elseif(i~=length(hex_LP)&&i~=1)
    fprintf(fileID, 'x"%s",', hex_LP(i,:));
    elseif(i==length(hex_LP))
    fprintf(fileID, 'x"%s");', hex_LP(i,:));
    end
    if(mod(i,10)==0)
     fprintf(fileID,'\n'); 
    end
end

fprintf(fileID, '\n\n--HPF_coeff\n');
fprintf(fileID, '\n signal HPF_coeff : coeff_array :=\n');
for i = 1:length(hex_HP)
    if(i==1)
    fprintf(fileID, '(x"%s",', hex_HP(i,:));
    elseif(i~=length(hex_HP)&&i~=1)
    fprintf(fileID, 'x"%s",', hex_HP(i,:));
    elseif(i==length(hex_HP))
    fprintf(fileID, 'x"%s");', hex_HP(i,:));
    end
    if(mod(i,10)==0)
     fprintf(fileID,'\n'); 
    end
end

fprintf(fileID, '\n\n--BSF_coeff\n');
fprintf(fileID, '\n signal BSF_coeff : coeff_array :=\n');
for i = 1:length(hex_SF)
    if(i==1)
    fprintf(fileID, '(x"%s",', hex_SF(i,:));
    elseif(i~=length(hex_SF)&&i~=1)
    fprintf(fileID, 'x"%s",', hex_SF(i,:));
    elseif(i==length(hex_SF))
    fprintf(fileID, 'x"%s");', hex_SF(i,:));
    end
    if(mod(i,10)==0)
     fprintf(fileID,'\n'); 
    end
end

fprintf(fileID, '\n\n--BPF_coeff\n');
fprintf(fileID, '\n signal BPF_coeff : coeff_array :=\n');

%because of the convolution the length is twice bigger then the other filters zero pad
for i = 41:length(hex_PF)-40               
    if(i==41)
    fprintf(fileID, '(x"%s",', hex_PF(i,:));
    elseif((i~=length(hex_PF)-40)&&i~=1)
    fprintf(fileID, 'x"%s",', hex_PF(i,:));
    elseif(i==length(hex_PF)-40)
    fprintf(fileID, 'x"%s");', hex_PF(i,:));
    end
    if(mod(i,10)==0)
     fprintf(fileID,'\n'); 
    end
end

fprintf(fileID, '\n\n--SIG_coeff\n\ntype coeff_array is array (0 to %d) of std_logic_vector(15 downto 0);',N);
fprintf(fileID, '\n signal sin : coeff_array :=\n');
for i = 1:length(hex_sig)
    if(i==1)
    fprintf(fileID, '(x"%s",', hex_sig(i,:));
    elseif(i~=length(hex_sig)&&i~=1)
    fprintf(fileID, 'x"%s",', hex_sig(i,:));
    elseif(i==length(hex_sig))
    fprintf(fileID, 'x"%s");', hex_sig(i,:));
    end
    if(mod(i,10)==0)
     fprintf(fileID,'\n'); 
    end
end

%%filters Gain[db] freq domain
figure(1)
tiledlayout(4,1)
nexttile
plot(fline,20*log10(abs(hpL)));
grid;
xlabel('f [Hz]');
ylabel('|HpL| [db]');
xlim([0 fs/2]);
title('Low pass filter');

nexttile
plot(fline,20*log10(abs(hpH)));
grid;
xlabel('f [Hz]');
ylabel('|HpH| [db]');
xlim([0 fs/2]);
title('High pass filter');

nexttile
plot(fline,20*log10(abs(hpS)));
grid;
xlabel('f [Hz]');
ylabel('|HpS| [db]');
xlim([0 fs/2]);
title('Band stop filter');

nexttile
plot(fline,20*log10(abs(hpP)));
grid;
xlabel('f [Hz]');
ylabel('|HpP| [db]');
xlim([0 fs/2]);
title('Band pass filter');

%% filters in time domain
figure(2)
tiledlayout(4,1)
% nexttile
% plot(n,sig);
% grid;
% xlabel('n [index]');
% ylabel('sig');
% title('signal before filter');

nexttile
plot(n,hnL);
grid;
xlabel('n [index]');
ylabel('hnL');
title('Low pass filter');

nexttile
plot(n,hnH);
grid;
xlabel('n [index]');
ylabel('hnH');
title('High pass filter');

nexttile
plot(n,hnS);
grid;
xlabel('n [index]');
ylabel('hnS');
title('Stop filter');

nexttile
plot(0:length(hnP)-1,hnP);
grid;
xlabel('n [index]');
ylabel('hnP');
title('Pass filter');
xlim([41 length(hnP)-40]);

%% signal before and after the filters - freq domain
figure(3)
tiledlayout(5,1)
nexttile
plot(fline,abs(sigP));
grid;
xlabel('n [index]');
ylabel('sigP');
xlim([0 fs/2]);
title('signal before filter');

nexttile
plot(fline,abs(yLP));
grid;
xlabel('n [index]');
ylabel('yP');
title('signal after L.filter');
% ylim([-60 0]);
xlim([0 fs/2]);

nexttile
plot(fline,abs(yHP));
grid;
xlabel('n [index]');
ylabel('yP');
title('signal after H.filter');
% ylim([-60 0]);
xlim([0 fs/2]);

nexttile
plot(fline,abs(ySP));
grid;
xlabel('n [index]');
ylabel('yP');
title('signal after S.filter');
% ylim([-60 0]);
xlim([0 fs/2]);

nexttile
plot(fline,abs(yPP));
grid;
xlabel('n [index]');
ylabel('yP');
title('signal after P.filter');
% ylim([-60 0]);
xlim([0 fs/2]);

%% signal before and after the filters - time domain
figure(4)
nline=0:length(yL)-1;
tiledlayout(5,1)
nexttile
plot(n,sig);
grid;
xlabel('n [index]');
ylabel('sig');
title('signal before filter');

nexttile
plot(nline,yL);
grid;
xlabel('n [index]');
ylabel('yL');
title('signal after L.filter');

nexttile
plot(nline,yH);
grid;
xlabel('n [index]');
ylabel('yH');
title('signal after H.filter');

nexttile
plot(nline,yS);
grid;
xlabel('n [index]');
ylabel('yS');
title('signal after S.filter');

nexttile
plot(0:length(yP)-1,yP);
grid;
xlabel('n [index]');
ylabel('yP');
title('signal after P.filter');
xlim([41 length(yP)-40]);

sound(sig)
pause(2)
sound(yL)
pause(2)
sound(yH)
pause(2)
sound(yS)
pause(2)
sound(yP)