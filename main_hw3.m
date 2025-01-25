clear all; clc; close all;
%% Section (A) - Adding new utils
% We have implemented new utils using blocks from previous homeworks.
fontSize = 20;

figure;
imshow(imread('blocks3\DigitalRandom.png'));
title("DigitalRandom block diagram", 'FontSize', fontSize);

figure;
imshow(imread('blocks3\NaturalRandom.png'));
title("NaturalRandom block diagram", 'FontSize', fontSize);

figure;
imshow(imread('blocks3\MuxRandom.png'));
title("MuxRandom block diagram", 'FontSize', fontSize);

figure;
imshow(imread('blocks3\SignalRandom.png'));
title("SignalRandom block diagram", 'FontSize', fontSize);

figure;
imshow(imread('blocks3\GreaterThan.png'));
title("GreaterThan block diagram", 'FontSize', fontSize);
%% Section (B) - 

%% Section (C)
N = 4096;

is_natural  = zeros(30, 1);
predictions = zeros(30, 1);
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