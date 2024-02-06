function [dist,idx]=find_nearest_pos(lon,lat,lons,lats)
% function idx=find_nearest_pos(lon,lat,lons,lats)
%  
% Purpose:ort the data points in order of increasing distance from lon,lat
% Author: AMM
% Date: 10/13/10
% Inputs: lon,lat - reference position 
%          lons,lats - positions to compare to lon,lat
% Outputs: idx - index to lons & lats in order of increasing distance
%                   from lon,lat
%          dist - distance in km between lons,lats and lon,lat
% ---------------------------------------------------------------------
if(nargin < 4)
    help find_nearest_pos
    error('Please include 4 arguments')
end
if(length(lon) > 1 || length(lat) > 1)
    error('Only one reference position can be checked at a time')
end

lons=lons(:);lats=lats(:); 
n=length(lons);
lo=ones(n*2,1)*NaN;la=lo;

lo(1:2:end)=lon;
la(1:2:end)=lat;

lo(2:2:end)=lons;
la(2:2:end)=lats;

dist=sw_dist(la,lo,'km');
dist=dist(1:2:end); % we only want distance between the reference point
                    % and every other point once

[dist,idx]=sort(dist);
