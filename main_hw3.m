clear all; clc; close all;
%% Section (A) - Adding new utils
% We have implemented new utils using blocks from previous homeworks.
% Here the diagram blocks and examples:
fontSize = 20;
N = 4096;

figure;
imshow(imread('blocks3\DigitalRandom.png'));
title("DigitalRandom block diagram", 'FontSize', fontSize);

figure;
[x] = DigitalRandom(N);
plot(x, '--*');
title('Example for DigitalRandom block');
xlabel('Time domain [samples]');
ylabel('Amplitude');

figure;
imshow(imread('blocks3\NaturalRandom.png'));
title("NaturalRandom block diagram", 'FontSize', fontSize);

[y, y_15] = NaturalRandom(N);
figure; 
nexttile;
sgtitle('Example for NaturalRandom block');

plot(y_15.', '--*');
xlabel('Time domain [samples]');
ylabel('Amplitude');
legend(compose('Signal #%d', 1:size(y_15, 1)));
title('Signals');

nexttile;
plot(y, '--*');
xlabel('Time domain [samples]');
ylabel('Amplitude');
title('Sum of signals');

figure;
imshow(imread('blocks3\MuxRandom.png'));
title("MuxRandom block diagram", 'FontSize', fontSize);

figure;
[z,b] = MuxRandom(x,y);
nexttile;
sgtitle('Example for MuxRandom block');

plot(x, '--*');
title('X signal');
xlabel('Time domain [samples]');
ylabel('Amplitude');

nexttile;
plot(y, '--*');
title('Y signal');
xlabel('Time domain [samples]');
ylabel('Amplitude');

nexttile;
plot(z, '--*');
title(compose('Z signal, b=%d', b));
xlabel('Time domain [samples]');
ylabel('Amplitude');

figure;
imshow(imread('blocks3\SignalRandom.png'));
title("SignalRandom block diagram", 'FontSize', fontSize);

figure;
[x,c] = SignalRandom(N);
nexttile;
sgtitle({'Example for SignalRandom block', compose("c=%d", c)});

plot(x, '--*');
xlabel('Time domain [samples]');
ylabel('Amplitude');

% As Example for GreaterThan block, we select 2 signals - Natural signal
% from Natural signal block and signal of zeros (Using Sine block with DC
% frequency). We expect that applying GreaterThan block will return only
% politive values, the negative one will be replaced with zeros.
figure;
imshow(imread('blocks3\GreaterThan.png'));
title("GreaterThan block diagram", 'FontSize', fontSize);

[zers, ~] = Sine(0, N, 0);
[z] = GreaterThan(y, zers.');
figure; nexttile;
plot(y, '--*');
title('Y signal');
xlabel('Time domain [samples]');
ylabel('Amplitude');

nexttile;
plot(z, '--*');
title('Z signal');
xlabel('Time domain [samples]');
ylabel('Amplitude');
%% Section (B)

%% Section (C)
N = 4096;

is_natural  = zers(30, 1);
predictions = zers(30, 1);
for i = 1:10
    [x, is_natural(i)] = SignalRandom(N);
    n1 = WGN(N, 0, 0.1);
    x_noised = Add(x, n1);
    predictions(i) = BinaryClassifier(x_noised);
end

for i = 11:20
    [x, is_natural(i)] = SignalRandom(N);
    n2 = WGN(N, 0, 0.5);
    x_noised = Add(x, n2);
    predictions(i) = BinaryClassifier(x_noised);
end

for i = 21:30
    [x, is_natural(i)] = SignalRandom(N);
    predictions(i) = BinaryClassifier(x);
end
%%
figure;
plot(x, '--*');