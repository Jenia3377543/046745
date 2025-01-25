clear all; clc; close all;
%% Adding new utils
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
