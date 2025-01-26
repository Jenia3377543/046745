function [c] = BinaryClassifier(x)
arguments
    x 
end
N_samples = length(x);
DC_energy = Filter(1, ones(1, N_samples)/N_samples, x); 
c = Add(0.95, Scalar(-1, DC_energy)); 
end