% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function [n, epdf] = fcnexplosion(input, table, d1)

%d1 = d(1);
%d1.range = 50;
%input.reactor.power = 1000; %kilotons explosion
[x, epdf] = fcnNuke(table.mev.ne, min(table.mev.e), max(table.mev.e), input.detectorMass, d1.range, input.reactor.power, 0, 10);

%figure; plot(x,epdf);
n = sum(epdf);
end

