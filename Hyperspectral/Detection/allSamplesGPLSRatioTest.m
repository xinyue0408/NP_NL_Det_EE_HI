function [ statistic, modelPar, gpErrorSqrNorm, lsErrorSqrNorm, tt ] = allSamplesGPLSRatioTest( y, M, covfunc, nparCovFunc, inferenceMethod)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

if nargin < 5
    inferenceMethod = {@infExact};
    if nargin < 4
        covfunc = {@covSEiso};
        if nargin < 3
            nparCovFunc = 2;
        end
    end
end


%% Using GPML Optimization
% estimate parameters using GPML
hyp = estimateGPMUsingGPML( y, M, covfunc, nparCovFunc, inferenceMethod);

if length(hyp.cov) ==2,
    ell = exp(hyp.cov(1));                                 % characteristic length scale
    sf2 = exp(2*hyp.cov(2));                                           % signal variance
    np = exp(hyp.lik);
    modelPar= [sf2^2;ell^2;np^2];

elseif length(hyp.cov) ==1,
    ell = exp(hyp.cov(1));                                 % characteristic length scale    
    np = exp(hyp.lik);
    modelPar= [ell^2;np^2];
else
    error('incorrect number of paramenters!')
end

 
likfunc = @likGauss;
%[predMean] = gp(hyp, @infExact, @meanZero, covfunc, likfunc, M, y, M);
[predMean] = gp(hyp, inferenceMethod, @meanZero, covfunc, likfunc, M, y, M);

%% Using My/Matlab Optimization
% modelPar = estimateGaussianProcessModel( y, M');
% [predMean] = makeGPPrediction(y,M',M',modelPar);
% %plotGPPredictionAndErrorBars(predMean,predVars);

%% Computing erros and statistics


e_gp  = y-predMean;
e_ls = y - estimateLinearModel(y,M);
statistic = 2*(e_gp'*e_gp)/(e_gp'*e_gp + e_ls'*e_ls);

% if length(modelPar)==2
%     K=computeKernelMatrix(M,sqrt(modelPar(1)));
%     H = eye(size(K)) - K'*inv(K+modelPar(2)*eye(size(K)));
% else
%     K=computeKernelMatrix(M,sqrt(modelPar(2)));
%     H = eye(size(K)) - modelPar(1)*K'*inv(modelPar(1)*K+modelPar(3)*eye(size(K)));
% end
% e_gp = H*y;
% tt=e_gp;
% tt = e_gp./sqrt(diag(H'*H));
% e_gp=tt;

%tt = tt./sqrt(modelPar(3));

% e_ls = y - estimateLinearModel(y,M);


% statistic = 2*(tt'*tt)/(tt'*tt + e_ls'*e_ls);

gpErrorSqrNorm = e_gp'*e_gp;
lsErrorSqrNorm = e_ls'*e_ls;
% norm_e_ls = robustTestForNonlinearMixtureDetection(y,M);
% statistic = 2*(e_gp'*e_gp)/(e_gp'*e_gp + norm_e_ls);
end

