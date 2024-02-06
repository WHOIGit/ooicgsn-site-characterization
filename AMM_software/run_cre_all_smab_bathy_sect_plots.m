% script    run_cre_all_smab_sect_plots
% A. Macdonald 8/20/22
% PURPOSE:
% Hardwired script to plot all the SMAB transects - note if it has been a
% while since this has been run, you ought to check that the id numbers have
% not changed by running
% region_numbers=define_plot_bathy_region_numbers;
% As of Dec 2023
%           SMAB_WE_EA_CN_TRANSECT: 21
%                 SMAB_NO_TRANSECT: 22
%                 SMAB_SO_TRANSECT: 23
%                 SMAB_NE_TRANSECT: 24
%                 SMAB_SE_TRANSECT: 25
%%   To create a comparison of transects
% Note this section has not been tested with the update transect positions
% Bathymetry choices (see run_plot_bathy.m) are:
SRTM15=1;
GEBCO=2;
CRM=3;

USE_BATHY=CRM;    % Hardwired

% fignum, bathy#, region#, wesn, plot_section, printit
% run_plot_bathy([1 2 2 1],SRTM15,sdx,[],true)
% run_plot_bathy([1 2 2 2],GEBCO,sdx,[],true)
% run_plot_bathy([1 2 2 3],CRM,sdx,[],true,true)

% crop_lrbt=[-74.89 0 0 0];
% for sdx=19:19     % Note can be run as 19:21, but legend must be moved
%                   % Line up the red dash with the bottom of bathy name
%    run_plot_bathy([1 3 2 1],SRTM15,sdx,[],true)
%    run_plot_bathy([1 3 2 3],GEBCO,sdx,[],true)
%    run_plot_bathy([1 3 2 5],CRM,sdx,[],true)
% 
%    run_plot_bathy([1 3 2 2],SRTM15,sdx,[],true,false,crop_lrbt)
%    run_plot_bathy([1 3 2 4],GEBCO,sdx,[],true,false,crop_lrbt)
%    run_plot_bathy([1 3 2 6],CRM,sdx,[],true,true,crop_lrbt)
% 
% end
% 
% 
%%      TO CREATE TRANSECT PLOTS
% When legend must be moved, Line up the red dash with the bottom of bathy name

CROP_WEST=false;
% run_plot_bathy(fignum,bathytype,region_id,wesn,plot_transect,printit,crop_lrbt,find_depth)
if(CROP_WEST)
    crop_lrbt=[0 0 0 200;
               -75.2 -74.75 0 200;
               -75.2 -74.75 0 200;
               -74.95 0 0 0;
               -74.95 0 0 0];
else
    crop_lrbt=[0 0 0 200;
               0 -74.75 0 200;
               0 -74.75 0 200;
               0 0 0 0;
               0 0 0 0];
end
names={'WE CN EA','NO','SO','NE','SE'};
FIND_DEPTH=false;   % find the longitude of the depth

% To interpolate to specific depths use FIND_DEPTH=value 
if(FIND_DEPTH)
    run_plot_bathy(1,USE_BATHY,21,[],true,true,crop_lrbt(1,:),100)  % find_depth = 100 for EA -74.8457
    run_plot_bathy(1,USE_BATHY,22,[],true,true,crop_lrbt(2,:),100)  % find_depth = 100 for NO -74.8268
    run_plot_bathy(1,USE_BATHY,23,[],true,true,crop_lrbt(3,:),100)  % find_depth = 100 for SO -74.8530
    run_plot_bathy(1,USE_BATHY,24,[],true,true,crop_lrbt(4,:),300)  % find_depth = 300 for NE -74.7768
    run_plot_bathy(1,USE_BATHY,25,[],true,true,crop_lrbt(5,:),300)  % find_depth = 300 for SE -74.8468
else
    idx=0;
    for sdx=21:25
       idx = idx +1;
       fprintf('%s\n',names{idx});
       run_plot_bathy(1,USE_BATHY,sdx,[],true,true,crop_lrbt(idx,:))
    end
end


