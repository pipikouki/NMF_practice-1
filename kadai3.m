clc;clear;

addpath("github_repo");
data_filename = "./input/piano+trumpet.wav";
teacher1_filename = "./scaleData/gpo_pf_scale.wav";
teacher2_filename = "./scaleData/gpo_tp_scale.wav";

windowshift = 5;
windowlength = 1500;
windowname = "Hann";
%F = DGTtool('windowShift',windowshift,'windowLength',windowlength,'windowName',windowname);
F = DGTtool('windowName',windowname);

data_vec = audioread(data_filename);
[teacher1_vec,fs] = audioread(teacher1_filename);
[teacher2_vec, ~] = audioread(teacher2_filename);

data_amp_spec = abs(F(data_vec));
data_theta_spec = angle(F(data_vec));

F.plot(teacher1_vec,fs);

spec1 = F(teacher1_vec);

teacher1_spec = [spec1(:,1),];


teach1_amp_spec = abs(F(teacher1_vec));
teach2_amp_spec = abs(F(teacher2_vec));

rep = 30;
K_const = 5;

%なんか知らんけど教師は絶対値とってみた
%[output1,output2,distance] = main(amplitude_spec,teach1_spec,teach2_spec,rep);

%audiowrite(output1,fs);
%audiowrite(output2,fs);

function [output1,output2,distance] = main(data,teacher1,teacher2,rep)

[tate,yoko] = size(data);
[~,K_const] = size(teacher1);
D = data;

W1 = teacher1;
W2 = teacher2;

G1 = rand(K_const,yoko);
G2 = rand(K_const,yoko);

distance = zeros(rep,1);

for i = 1:rep
    G1 = (G1) .* ((W1')*(D)) ./ ((W1') * (W1*G1 + W2*G2));
    G2 = (G2) .* ((W2')*(D)) ./ ((W2') * (W1*G1 + W2*G2));

    distance(rep) = sum((D-W1*G1-W2*G2).^2,"all");
end

output1 = W1*G1;
output2 = W2*G2;

end