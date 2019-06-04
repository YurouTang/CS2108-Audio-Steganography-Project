% close all;
% clear;

% --- prompt user for message to be encoded
prompt = 'Input message: ';
message = input(prompt, 's');
Freq = double(message);

for i = 1 : length(Freq)
    Freq(i) = Freq(i) - 32;
end

% --- generate encoded signal in terms of sine waves
Fs = 44100; % sampling frequency
Ts = 1/Fs; % timestep
message_segment_duration = 3; % how long is one segment
message_segment_parts = 10; % how many segments are there
time_in_between = 0.6; % time between segments

t = (0: Ts : message_segment_duration-Ts); % Each segment is 4s - Ts.

% We are working in a range from base freq to 15000Hz, any higher will not
% be detected by Mac Computers.
basefreq = 3000; % Increase or decrease by 3000
multiplier = 7; % For positional index of frequency, lest they intersect.
gap = 95 * multiplier; % give the positional index of characters gaps for accuracy measure

first_index_offset = 1100; % Round up to nearest hundreds (155*multiplier)

% Length occupies 3000 to 4100 (Assuming length is always <= 155 in length)
x = zeros(1, Fs * message_segment_duration);
x = x + sin(2*pi*((basefreq + multiplier * length(Freq))*t));
all_x = [];
max_char_in_segment = 16;
for i = 1 : length(Freq) 
   % With 155 characters, this makes it go up to 4100Hz to ~15000Hz
   % Starts from 4100Hz - 4765Hz (first char)
   % Concatanate entire spectrum of sine waves at different frequency
   % for different time periods.
   if i <= max_char_in_segment*1
    x = x + sin(2*pi*((basefreq+first_index_offset) + (i-1) * gap + multiplier * Freq(i))*t);
    if i == max_char_in_segment*1
        y = zeros(1, Fs * time_in_between);
        all_x = [x y];
        x = zeros(1, Fs * message_segment_duration);
    end
   elseif i <= max_char_in_segment*2
           x = x + sin(2*pi*((basefreq+first_index_offset) + (i-1-max_char_in_segment*1) * gap + multiplier * Freq(i))*t);
    if i == max_char_in_segment*2
        all_x = [all_x x];
        x = zeros(1, Fs * message_segment_duration);
        y = zeros(1, Fs * time_in_between);
        all_x = [all_x y];

    end
   elseif i <= max_char_in_segment*3
    x = x + sin(2*pi*((basefreq+first_index_offset) + (i-1-max_char_in_segment*2) * gap + multiplier * Freq(i))*t);
    if i == max_char_in_segment*3
        all_x = [all_x x];
        x = zeros(1, Fs * message_segment_duration);
        y = zeros(1, Fs * time_in_between);
        all_x = [all_x y];
    end
   elseif i <= max_char_in_segment*4
    x = x + sin(2*pi*((basefreq+first_index_offset) + (i-1-max_char_in_segment*3) * gap + multiplier * Freq(i))*t);
    if i == max_char_in_segment*4
        all_x = [all_x x];
        x = zeros(1, Fs * message_segment_duration);
        y = zeros(1, Fs * time_in_between);
        all_x = [all_x y];
    end
      elseif i <= max_char_in_segment*5
    x = x + sin(2*pi*((basefreq+first_index_offset) + (i-1-max_char_in_segment*4) * gap + multiplier * Freq(i))*t);
    if i == max_char_in_segment*5
        all_x = [all_x x];
        x = zeros(1, Fs * message_segment_duration);
        y = zeros(1, Fs * time_in_between);
        all_x = [all_x y];
    end
         elseif i <= max_char_in_segment*6
    x = x + sin(2*pi*((basefreq+first_index_offset) + (i-1-max_char_in_segment*5) * gap + multiplier * Freq(i))*t);
    if i == max_char_in_segment*6
        all_x = [all_x x];
        x = zeros(1, Fs * message_segment_duration);
        y = zeros(1, Fs * time_in_between);
        all_x = [all_x y];
    end
         elseif i <= max_char_in_segment*7
    x = x + sin(2*pi*((basefreq+first_index_offset) + (i-1-max_char_in_segment*6) * gap + multiplier * Freq(i))*t);
    if i == max_char_in_segment*7
        all_x = [all_x x];
        x = zeros(1, Fs * message_segment_duration);
        y = zeros(1, Fs * time_in_between);
        all_x = [all_x y];
    end
         elseif i <= max_char_in_segment*8
    x = x + sin(2*pi*((basefreq+first_index_offset) + (i-1-max_char_in_segment*7) * gap + multiplier * Freq(i))*t);
    if i == max_char_in_segment*8
        all_x = [all_x x];
        x = zeros(1, Fs * message_segment_duration);
        y = zeros(1, Fs * time_in_between);
        all_x = [all_x y];
    end
         elseif i <= max_char_in_segment*9
    x = x + sin(2*pi*((basefreq+first_index_offset) + (i-1-max_char_in_segment*8) * gap + multiplier * Freq(i))*t);
    if i == max_char_in_segment*9
        all_x = [all_x x];
        x = zeros(1, Fs * message_segment_duration);
        y = zeros(1, Fs * time_in_between);
        all_x = [all_x y];
    end
        
   elseif i <= max_char_in_segment*10
    x = x + sin(2*pi*((basefreq+first_index_offset) + (i-1-max_char_in_segment*9) * gap + multiplier * Freq(i))*t);
    if i == length(Freq)
        all_x = [all_x x];
        x = zeros(1, Fs * 36);
    end
   end
end

r = mod(length(Freq), max_char_in_segment);

if length(Freq) < max_char_in_segment
        y = zeros(1, Fs * time_in_between);
        all_x = [x y];
        x = zeros(1, Fs * 36);
elseif r~=0 && length(Freq) < max_char_in_segment*9
   all_x = [all_x x];
   x = zeros(1, Fs * message_segment_duration);
   y = zeros(1, Fs * time_in_between);
   all_x = [all_x y];
   x = zeros(1, Fs*36);
end

if (size(all_x)~= (Fs*36))
    all_x = [all_x zeros(1,36*Fs - length(all_x))];
end

% Softest + accurate (tested 0.001, 0.005, 0.01, 0.15, 0.18)
% Lowering the amplitude.
all_x = 0.05*(all_x / max(abs(all_x)));

% --- read audiofile Edelweiss.mp3
[y,Fs] = audioread('Edelweiss.mp3'); % y is 5527920 x 2, Fs is 44100
y = y(:,1); % We only take 1 channel as we only need 1.
% lowpass filter the music using fir
Y = fftshift(fft(y));
win   = fir1(1028, (basefreq/(Fs/2))); % Remove everything above 3000Hz.
win = win.';
figure
freqz(win, length(y));
Win = fftshift(fft(win, length(Y)));
YW = Y .* Win;
y = ifft(fftshift(YW));

y = y';

% keep the first 36 seconds of the music
truncated_music = y(1:36 * Fs);
% audiowrite('edelweiss_36seconds.mp4', truncated_music', Fs);


% --- generate encoded music to be played
encoded_music = truncated_music + all_x;
player = audioplayer(encoded_music', Fs);
% play(player);
y = encoded_music;


audiowrite('encoded_message.mp4', encoded_music', Fs);