function [c] = BinaryClassifier(x)
arguments
    x 
end
N_samples = length(x);
[haar_mean, ~] = Rect(0,N_samples,N_samples);
DC_energy = Filter(1, haar_mean, x); 
c = Add(0.95, Scalar(-1, DC_energy)); 
end