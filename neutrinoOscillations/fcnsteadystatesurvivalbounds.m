function [ output_args ] = fcnsteadystatesurvivalbounds( input_args )

n=10000;
flags.status.aprioribackground = 1;
[op, s] = fcnrandosc(n, [], flags);


parfor i = 1:n
    fprintf('%g\n',i)
    f1 = fcnspec1f(linspace(30000,40000,1E6)', linspace(4,4,1),op(i,:)); 
    x(i) = mean(f1(:));
end

fig; fcnhist(x,50); xyzlabel('Survival Probability','','','Steady State Survival MC')
[su, sl] = fcnstd(x(:));
legend(sprintf('%.3f+%.3f-%.3f',mean3(x),su,sl))

end

