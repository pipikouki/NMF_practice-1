clc;clear;

addpath("github_repo");
addpath("songKitamura/GPO/melody1");
addpath("function");

%wndowshift     一回の計算で配列いくつずらすか
%windowlength   配列何個分計算するか。一回のSTFTする時間の長さ
%fftnum         知らんから消した。
%window name    窓関数の名前、いろいろある

F = DGTtool('windowShift',500,'windowLength',1500,'windowName','Hann');
[data,fs] = audioread("gpo_hr.wav");

%--------------スぺ区トログラムを得る-------------------
spe = F(data);
amp_spe = abs(spe);     %振幅スペクトログラム
theta_spe = angle(spe); %位相スペクトログラム
%rank(amp_spe); K_constはランクの値に近い方がいい

%---------------振幅スペクトログラムを分解-------------------
K_const = 30;
rep = 100;
[tate,yoko] = size(amp_spe);
W = rand(tate,K_const); %初期値W,0があるとまずい
H = rand(K_const,yoko); %初期値H,0があるとまずい
[W,H,~] = NMF_KL(amp_spe,W,H,rep);


%---------分解したデータからもとのデータを復元-----------
spe_rebuilded = (W*H).*exp(1i * theta_spe);


%---------------逆STFTしてファイル出力------------------
data_rebuilded = F.pinv(spe_rebuilded);
audiowrite("rebuild.wav",data_rebuilded,fs);