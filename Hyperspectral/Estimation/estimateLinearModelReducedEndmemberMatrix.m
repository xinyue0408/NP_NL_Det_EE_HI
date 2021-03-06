function [yest_reduced, aest_reduced] = estimateLinearModelReducedEndmemberMatrix( y, M, respectConstrains )
%function [yest, aest] = linearEstimationReducedEndmemberMatrix( y, M,
%respectConstrains )
%
%   Return estimated reduced pixel "yest_reduced" and reduced abundances "aest_reduced" using
%   Least-Squares, where y_reduced = y - m_R
%
%   Inputs:
%           y: Lx1 target pixel
%           M: LxR mixing matrix
%           respectConstraints: {true or false}
%   

mR = M(:,end);
K = M(:,1:end-1);
K = bsxfun(@minus,K,mR);
yr = y-mR;


if (respectConstrains == true)
    % Check Cedric/ ohter papers;  
    error('Error: Constrained Mode not implemented yet!')
    
else
    aest_reduced = unconstrainedLeastSquaresEstimation(yr,K); 
end


yest_reduced = K*aest_reduced;


end

