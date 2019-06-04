close all;
clear;

Fs = 44100;  % sampling frequency

recObj = audiorecorder(Fs, 16, 1); % 16-bit, 1 channel

disp('Start recording...');
recordblocking(recObj, 38);
disp('End of Recording.');

y = getaudiodata(recObj);

% Break recorded messages into segments (defined in Encoder)
y1 = y(Fs: Fs*2);
y2 = y(202860: 246960);
y3 = y(361620: 405720);
y4 = y(520380: 564480);
y5 = y(679140:723240);
y6 = y(837900:882000);
y7 = y(996660: 1040760);
y8 = y(1155420: 1199520);
y9 = y(1314180: 1358280);
y10 = y(1472940:1517040);

Y1 = abs(fft(y1, 2^nextpow2(length(y1))));
Y2 = abs(fft(y2, 2^nextpow2(length(y2))));
Y3 = abs(fft(y3, 2^nextpow2(length(y3))));
Y4 = abs(fft(y4, 2^nextpow2(length(y4))));
Y5 = abs(fft(y5, 2^nextpow2(length(y5))));
Y6 = abs(fft(y6, 2^nextpow2(length(y6))));
Y7 = abs(fft(y7, 2^nextpow2(length(y7))));
Y8 = abs(fft(y8, 2^nextpow2(length(y8))));
Y9 = abs(fft(y9, 2^nextpow2(length(y9))));
Y10 = abs(fft(y10, 2^nextpow2(length(y10))));

N = length(Y1);
f_res = Fs/N;
multiplier = 7;
gap = floor((95 * multiplier)/f_res);

base_freq = 3000;
max_char_in_segment = 16;
peaks = [];

x_start_idx = floor(base_freq / f_res);

first_index_offset = 1100;

% Obtain message length from the first position "frequency" in audiofile.
% Message length is only within the first segment of the audiofile.
x = Y1(x_start_idx : x_start_idx+floor(first_index_offset/f_res));
max_x = max(x);
idx = find(x==max_x);
msg_length = floor((idx(1).*f_res)/multiplier);
msg_segments = zeros(1,10);
for i = 1:length(msg_segments)
    if msg_length > max_char_in_segment
        msg_segments(i) = 16;
        msg_length = msg_length - 16;
    else
        msg_segments(i) = msg_length;
        msg_length = 0;
    end
end
x_start_idx = x_start_idx + floor(first_index_offset/f_res);
 for i = x_start_idx : gap : x_start_idx + (msg_segments(1)-1)*gap
    x = Y1(i+1: i+gap); 
    max_x = max(x);
    idx = find(x==max_x);
    peaks = [peaks idx(1)];
 end
 
 for i = x_start_idx : gap : x_start_idx + (msg_segments(2)-1)*gap
    x = Y2(i+1: i+gap); 
    max_x = max(x);
    idx = find(x==max_x);
    peaks = [peaks idx(1)];
end

for i = x_start_idx : gap : x_start_idx +(msg_segments(3)-1)*gap
    x = Y3(i+1: i+gap); 
    max_x = max(x);
    idx = find(x==max_x);
    peaks = [peaks idx(1)];
end

for i = x_start_idx : gap : x_start_idx + (msg_segments(4)-1)*gap
    x = Y4(i+1: i+gap); 
    max_x = max(x);
    idx = find(x==max_x);
    peaks = [peaks idx(1)];
end

for i = x_start_idx : gap : x_start_idx + (msg_segments(5)-1)*gap
    x = Y5(i+1: i+gap); 
    max_x = max(x);
    idx = find(x==max_x);
    peaks = [peaks idx(1)];
end

for i = x_start_idx : gap : x_start_idx + (msg_segments(6)-1)*gap
    x = Y6(i+1: i+gap); 
    max_x = max(x);
    idx = find(x==max_x);
    peaks = [peaks idx(1)];
end

for i = x_start_idx : gap : x_start_idx + (msg_segments(7)-1)*gap
    x = Y7(i+1: i+gap); 
    max_x = max(x);
    idx = find(x==max_x);
    peaks = [peaks idx(1)];
end

for i = x_start_idx : gap : x_start_idx + (msg_segments(8)-1)*gap
    x = Y8(i+1: i+gap); 
    max_x = max(x);
    idx = find(x==max_x);
    peaks = [peaks idx(1)];
end

for i = x_start_idx : gap : x_start_idx + (msg_segments(9)-1)*gap
    x = Y9(i+1: i+gap); 
    max_x = max(x);
    idx = find(x==max_x);
    peaks = [peaks idx(1)];
end

for i = x_start_idx : gap : x_start_idx + (msg_segments(10)-1)*gap
    x = Y10(i+1: i+gap); 
    max_x = max(x);
    idx = find(x==max_x);
    peaks = [peaks idx(1)];
end

peaks = peaks.*f_res;
peaks = peaks/multiplier;
for i = 1 : length(peaks)
   peaks(i) = floor(peaks(i)) + 32;
end

message = char(peaks);
disp(message);