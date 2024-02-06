function [smean,svar]=amm_weighted_mean_1var(values,weights)
% function amm_weighted_mean_1var(values,weights)
%
% PURPOSE: to compute a weighted mean and variance
%    smean = sum(values./weights)/sum(weights^-1)
%    svar = 1/sum(weights^-1)
% AUTHOR: AMM
% DATE: 11/23/10
% INPUTS: values - the values to be averaged
%         weights - (optional, default all ones)
%                   the weights to use on the values. These could be 
%                   distances, or uncertainties in which case they should 
%                   be variances so that svar=1/sum(1/sigma_i^2)
% OUTPUTS: smean - sample weighted mean
%          svar - sample weighted variance
%
% Notes: If the weights are all ones then:
%        smean = 1/N * sum(values) = mean(values)
%        svar = 1(N-1) * sum (values -smean)^2
%        which is the same as var(values) which is std(values)^2
%
%        The uncertainties are assumed to be uncorrelated
% SAME as amm_weighted_mean except that if there is only one value going to
%        the weight is returned as the variance
%%
if(nargin < 1)
    help amm_weighted_mean
    return
end


if(nargin < 2)
    disp('No weights being used')
    smean=mean(values);
    svar=sum((values-smean).^2)/(length(values)-1);
else
   isaval=~isnan(values) & ~isnan(weights);
   values=values(isaval);
   weights=weights(isaval);
   if(length(unique(weights)) == 1)   % if only 1 weight
      %disp('Weights are all the same')
      smean=mean(values);
      svar=sum((values-smean).^2)/(length(values)-1);
   else
     svar=1/sum(weights.^-1);
     smean = sum(values./weights)*svar; 
   end
end

% if only one value is provided the uncertainty returned is the weight
nx=~isnan(values);
if(sum(nx) == 1)
   svar = weights(nx);
end

