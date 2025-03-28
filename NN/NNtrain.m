% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function [netb, perf, sigma] = NNtrain(inputs,targets,hiddenLayers,iterations,weights,sizemethod,sizegain)
x = inputs';  nx=size(inputs,2);
t = targets'; nt=size(targets,2);
if nargin<4; iterations=1; end
if nargin<6; sizemethod='exp1'; end
if nargin<7; sizegain=1; end

nl = numel(hiddenLayers); %i.e. [512 152 45 13 4], [256 84 28 9 3], [1024 180 32 6 1], [1024 217 45 10 2], [1024 256 64 16 4]
if all(hiddenLayers==0) % SPECIFY BY EXP, i.e. [512-[152 45 13]-4] for 512 inputs and 4 outputs
    F = fit([0 nl+1]', [nx nt]', sizemethod);  %'poly1' or 'exp1' or 'rat01'
    hiddenLayers = fcnrow(round(F(1:nl)*sizegain));
end
hiddenLayers=hiddenLayers(hiddenLayers>0); if isempty(hiddenLayers); hiddenLayers=1; end

% Create a Fitting Network
%net = cascadeforwardnet(hiddenLayers,'trainscg'); %trainlm, trainbr, trainscg
%hiddenLayers = [20];  nl=numel(hiddenLayers);
net = fitnet(hiddenLayers,'trainlm'); %trainlm, trainbr, trainscg
%net = patternnet(hiddenLayers,'trainscg'); %trainlm, trainbr, trainscg

net.trainParam.epochs=2E4;
net.trainParam.time=60*60*4; %max seconds to train
net.trainParam.max_fail = 10; %validation checks
% 
% % Setup Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

net.performFcn = 'mse'; %'mse','mae','crossentropy'
net.PerformParam.normalization = 'standard';
net.PerformParam.regularization = 0.0;


net.input.processFcns = {'removeconstantrows','mapstd'};
net.output.processFcns = {'removeconstantrows','mapstd'};

% ERROR WEIGHTS
if nargin<5 || isempty(weights)
    weights = ones(size(t));
    % a=1./sqrt(t(3,:)); a=a/mean(a);
    % weights(3,:) = a;
end

ew=weights;
% if numel(ew)~=numel(t)
%      ew = repmat(ew',[size(targets,2) 1]);
% end


%TRAIN
perf=inf; %performance
sigma=0;
%net.name = 'Function Fitting CNN';
fprintf(['Training %g copies of a %g-' repmat('%g-',[1 nl]) '%g %s...\n'],iterations,nx,hiddenLayers,nt,net.name);
for i=1:iterations
    switch net.name
        case 'Pattern Recognition Neural Network'
            net.performFcn = 'crossentropy';
            [neta,tr] = train(net,x,t);
        case 'Pattern Recognition CNN'
            %DEEP NEURAL NETWORK EXAMPLE
            %[x,t] = wine_dataset; %use wine example
            %x=x'; t=t'; %load jocher data
            %Train an autoencoder with a hidden layer of size 10 and a linear transfer function for the decoder. Set the L2 weight regularizer to 0.001, sparsity regularizer to 4 and sparsity proportion to 0.05.
            autoenc1 = trainAutoencoder(x,10); %Extract the features in the hidden layer. 10 neurons
            features1 = encode(autoenc1,x); %Train a second autoencoder using the features from the first autoencoder. Do not scale the data.
            autoenc2 = trainAutoencoder(features1,10);%,'L2WeightRegularization',0.001,'SparsityRegularization',4,'SparsityProportion',0.05,'DecoderTransferFunction','purelin','ScaleData',false); %Extract the features in the hidden layer.
            features2 = encode(autoenc2,features1); %Train a softmax layer for classification using the features, features2, from the second autoencoder, autoenc2.
            softnet = trainSoftmaxLayer(features2,t,'LossFunction','crossentropy'); %Stack the encoders and the softmax layer to form a deep network.
            dnet = stack(autoenc1,autoenc2,softnet); %Deep Network
            dnet.trainParam.epochs=19000;  dnet.trainParam.time=60*60*4;  dnet.trainParam.max_fail = 400;
            dnet.divideFcn='dividerand';  dnet.divideParam.trainRatio = .7;  dnet.divideParam.valRatio = .15;  dnet.divideParam.testRatio = .15;
            [dnet, tr]=train(dnet,x,t);  neta=dnet;  %fig; plotconfusion(t,dnet(x));
        case 'Function Fitting CNN'
            %DEEP NEURAL NETWORK EXAMPLE
            autoenc1 = trainAutoencoder(x,30);%,'L2WeightRegularization',0.004,'SparsityRegularization',4,'SparsityProportion',0.15,'ScaleData',false); %Extract the features in the hidden layer. 10 neurons
            features1 = encode(autoenc1,x); %Train a second autoencoder using the features from the first autoencoder. Do not scale the data.
            %autoenc2 = trainAutoencoder(features1,8);%,'L2WeightRegularization',0.002,'SparsityRegularization',4,'SparsityProportion',0.1,'ScaleData',false); %Extract the features in the hidden layer.
            %features2 = encode(autoenc2,features1); %Train a softmax layer for classification using the features, features2, from the second autoencoder, autoenc2.
            fnet = train(net,features1,t); %Fitting Network
            dnet = stack(autoenc1,fnet); %Deep Network
            dnet.trainParam.epochs=19000;  dnet.trainParam.time=60*60*4;  dnet.trainParam.max_fail = 1000;
            dnet.divideFcn='dividerand';  dnet.divideParam.trainRatio = .7;  dnet.divideParam.valRatio = .15;  dnet.divideParam.testRatio = .15;
            [dnet, tr]=train(dnet,x,t);  neta=dnet;
        otherwise %function fitting
            [neta,tra] = train(net,x,t,[],[],ew,'UseParallel','yes');  tr=tra;
            
            %neta.trainParam.max_fail=7;  for j=1:3;  [neta,tr]=train(neta,x,t,[],[],ew); end; 
    end
    isigma=std(neta(x)'-t');
    s=sprintf('%.3f, ',isigma);  fprintf(['Network %g: [' s(1:end-2) '] sigma, %.5g perf in %.0fs\n'],i,tr.best_perf,tra.time(end));
    if tr.best_perf<perf; perf=tr.best_perf; netb=neta; sigma=isigma; end
end
fprintf('\n')

%Test the Network
%e = gsubtract(t,neta(x));
%disp(perform(neta,t,neta(x)));
%view(net)

%Plots
%plotNN(netb)
% figure, plotperform(tr)
% figure, plottrainstate(tr)
% figure, ploterrhist(e)
% figure, plotregression(t,y)
% figure, plotfit(net,x,t)




