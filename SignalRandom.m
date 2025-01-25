function [x,c] = SignalRandom(N)
arguments
    N 
end
[natural_signal, ~] = NaturalRandom(N);
[digital_signal] = DigitalRandom(N);

[x,c] = MuxRandom(natural_signal,digital_signal);
end