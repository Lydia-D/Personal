% test fn_phi and dphi

alphatest = 0:0.01:1;
for i = 1:1:length(alphatest)
    phi(i) = fn_phi(alphatest(i));
    dphi(i) = fn_phid(alphatest(i));
end
hold on
plot(alphatest,phi,'b')
figure;

hold on
plot(alphatest,dphi,'b')