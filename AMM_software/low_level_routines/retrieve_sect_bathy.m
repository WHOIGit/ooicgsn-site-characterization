function [sbathy, bathy]=retrieve_sect_bathy(bathy,wesn)
% function sbathy_retrieve_sect_bathy(bathy,wesn)
% Author: A. Macdonald
% Date: 8/8/22
% Purpose: To retrieve SRTM15 bathymetry for a transect defined between two
%          points or along a line. Can use plot_sect_bathy.m to plot these data
% Inputs: bathy - an SRTM15 bathymetry sctructure retrieved using extract_bathymetry.m
%                 OR the name of a file containing this bathymetry strucure
%                 Optional - If not provided, data will be retrieved from the 
%                 full database and returned as I/O. Note, this can take
%                 significantly longer than when either a smaller file or
%                 structure are provided
%         wesn - [West East North South] positions defining the transect
%                 If West == East, it is assume to be a meridional line
%                 If South == North, it is assume to be a zonal line
%                 If 4 values are provided they are assumed to be the
%                   [lon1 lon2 lat1 lat2] corners of a diagonal line
%                 If more than 4 values are provided, it must be a Nx2
%                 values, assumed to be [lon lat] pairs defining the transect
%                 If not provided it will be requested.
%
%%   Get hardwired variables and check input arguments
% bathyfile='/Users/alison/matlab/mapping/sands_1min/topo_23.1.nc';
% GLOBAL_BATHFILE ='/Users/alison/DATA/Bathymetry/SRTM15_V2.3.nc';
GLOBAL_BATHFILE ='/Users/alison/DATA/Bathymetry/gebco_2022_sub_ice_topo/GEBCO_2022_sub_ice_topo';
F=1/60/4;    % use F to make sure we capture the full line, in some cases
             % will be more than we need. But if the resolution is less
             % than 15 arc-sec, we should probably change it.
             
if(exist('near','file')~=2)
    addpath /Users/alison/matlab/DOWNLOADS/nctoolbox-1.1.3/   
    addpath ~/matlab/ocean_data_tools-master/ocean_data_tools/
    setup_nctoolbox
end


if(nargin < 1 || isempty(bathy))
    have_bathy=false;
elseif(isstruct(bathy))
    have_bathy=true;
elseif(ischar(bathy))
    bathyfile=bathy;clear bathy
    if(exist(bathyfile,'file'))
        load(bathyfile,'bathy')
        have_bathy=true;
    end
end

if(nargin < 2 || isempty(wesn))
    wesn=input('Please specify [W E N S] or [lon(:); lat(:)] '); 
end


%%   Extract Bathymetry from the database if require

[n,m]=size(wesn);
if(n==4 && m==1)    % assume, wesn was just rotated
    wesn=wesn';
    [n,m]=size(wesn);
end
if(n==1 && m==4)   % we have WESN
    lo=wesn(1:2);la=wesn(3:4);
else               % we have [lons lats]
    lo=wesn(:,1);la=wesn(:,2);
end

latends=[min(la) max(la)];
lonends=[min(lo) max(lo)];
snwe=[latends(1)-F latends(2)+F lonends(1)-F lonends(2)+F];

if(diff(lonends)==0)
    if(diff(latends)==0)
        error('Cannot create a transect out of a single position')
    else
        fprintf('We have a meridional transect at %7.3f between %7.3f and %7.3f\n',...
              lonends(1),latends)
    end
else
    if(diff(latends)==0)
        fprintf('We have a zonal transect at %7.3f between %7.3f and %7.3f\n',...
              latends(1),lonends)
    else    % have at least two lats and two lons 
        fprintf('We have a diagonal transect from %7.3f,%7.3f to %7.3f,%7.3f\n',...
              latends(1),lonends(1),latends(2),lonends(2))     % lat1,lon1 to lat2,lon2  
    end
end

if(~have_bathy)
    % Extract bathymetry from global database
    fprintf('Extracting bathymetry from %s\n',GLOBAL_BATHFILE)
    bathy=bathymetry_extract(GLOBAL_BATHFILE,snwe);
end

res=unique(diff(bathy.lon));res=res(1);
%%  % We want an estimate of the bathymetry at every point along the line

[dlat,dlon]=interpm(la,lo,res);   % high resolution along-line track
n=length(dlat);
dep=NaN(n,1);

for ndx=1:n
    dy=near(bathy.lat,dlat(ndx),2);
    dx=near(bathy.lon,dlon(ndx),2);
    [xs,ys]=meshgrid(bathy.lon(dx),bathy.lat(dy));
    dist=find_nearest_pos(dlon(ndx),dlat(ndx),xs(:),ys(:));
    z=-1*bathy.z(dx,dy);
    dep(ndx)=amm_weighted_mean_1var(double(z(:)),dist);

%         [dep,depvar]=amm_weighted_mean_1var(z(:),dist);
%         fprintf('depths (m): %6.2f %6.2f %6.2f %6.2f\n',z)
%         fprintf('dists (nm): %6.3f %6.3f %6.3f %6.3f\n',dist)
%         fprintf('depth  (m): %6.2f +/- %6.2f\n',dep,sqrt(depvar))
end
sbathy.bathy=dep;
sbathy.lat=dlat;
sbathy.lon=dlon;
% sbathy.wesn=snwe([3 4 1 2]);
sbathy.wesn=wesn;


         

