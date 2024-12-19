function PlotWGN(y_n, legend_str, mu, sigma, time_domain)
arguments
    y_n
    legend_str
    mu
    sigma
    time_domain = (0:length(y_n)-1)/length(y_n)
end
figure;
nexttile;
plot(time_domain, y_n, 'DisplayName', legend_str);
xlabel('Time domain [samples]');
ylabel('Amplitude');
legend;

edges = min(y_n):0.5:max(y_n);
nexttile; hold all;
histogram(y_n, edges, 'DisplayName', legend_str, 'Normalization', 'pdf');
xlabel('Values');
ylabel('Count');

pd = makedist('Normal','mu',mu,'sigma',sigma);
pdf_normal = pdf(pd,edges);
plot(edges, pdf_normal, 'DisplayName', 'Actual Distribution');
legend;
sgtitle(compose("WGN example %s", legend_str));


end

