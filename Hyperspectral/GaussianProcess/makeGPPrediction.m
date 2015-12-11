function [ predMean ] = makeGPPrediction(ytr, Xtr, Xtst, modelPar, kernelType)
%function [ predMean ] = makeGPPrediction(ytr, Xtr, Xtst, modelPar, kernelType)
%   
%



if nargin < 5
    kernelType = [];
    if nargin <4
        error('Usage: makeGPPrediction(y, M, modelPar, kernelType)');
    end
end

if isempty(kernelType) 
    kernelType = 'sqrExponential';
end

trainLength = size(Xtr,2);
testLength = size(Xtst,2);


[~,K] = covFuncCalc(modelPar,Xtr,ytr,kernelType);
% k1Col = size(K,2);
% k1Lin = size(Xtr,2);


if strcmp(kernelType,'sqrExponential')    

    % calculate the
    %K1 = zeros(k1Lin,k1Col);
    K1 = zeros(testLength,trainLength);
    for i=1:testLength,
        for j=1:trainLength,
            K1(i,j) = modelPar(1) * exp(- 0.5* ((Xtst(:,i) - Xtr(:,j))'*(Xtst(:,i) - Xtr(:,j)))/(modelPar(2)));      
        end
    end
    
    %f_tst = K1*(K\y);

    Lc = chol(K, 'lower');
    Kinv_y = (Lc'\(Lc\ytr));
    
    predMean = K1*Kinv_y;
    
else 
    error('Kernel Type not implemented yet.')
end


end

