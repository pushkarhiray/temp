%% Neural Network

net=newff(minmax(training_dataset),[10,1],{'tansig','purelin'},'trainlm','trainlm','mse');
net.trainparam.epochs= 20000;
net.trainparam.goal= 1e-4;
net.trainparam.lr= 0.05;
net.divideFcn='divideind';
net.divideParam.trainInd=1:3000;
%net.divideParam.valInd=2001:3000;
net.divideParam.testInd=3001:3812;
net=train(net,training_dataset,training_labels);
output=net(training_dataset);

W1=net.IW{1};
W2=net.LW{2};


b1=net.b{1};
b2=net.b{2};
%%
figure;
plot(training_labels,'b');
hold on;
plot(output,'r');

error=training_labels-output;
figure;
plot(error);

%% Testing

%Test=sim(net,test_data);