function plot_bathy(fignum,startmap,wesn,fsize,shaded,bathfile,cv,projection)
% plot_bathy([fignum],[startmap],[wesn],[fsize],[shaded],[bathfile],[cv],[pprojection])
% Purpose: To create a  basic map of with bathymetry
% Author: AMM 7/28/22 
% Inputs: All argument are optional
%         fignum - figure #. If 0, current figure is used (Default = 1)
%         startmap - logical, true - set projection & plot bathymetry
%                             false - plot the grid
%                     (Default - true)
%         wesn - geographic range for the plots (Default - [-98 -80 18 30]
%         fsize - fontsize for labels (Default is FSIZE)
%         shaded - logical true - use shading rather than contours (Default false)
%         bathy or bathfile - the bathy structure created use extract_bathymetry or
%                    The name of the .mat file containing this bathymetry
%                    assumed to containing the bathy (.z negative down,.lons, .lats)
%                    contain: lons and bath with ocean depths positive
%                    or glons, glats and gtopo with ocean depths positive                                         
%         cv - contour intervals (Default - [5000 3500 2500 1500 500])
%         projection - map projection (Default - mercator)
% Outputs: grid - command to replot the map grid in case later plotting
%         overwrites it
% HISTORY:
% 
%% Hardwired Variables for defaults
PROJECTION = 'mercator';   % 'mercator' 'lambert'

FSIZE=14;            % FontSize for text and labels
CV=[5000 3500 2500 1500 500];
SHADED_CV=[5000 3500 2500 1500 500 50];
BATHY_COLOR=[0.5 0.5 0.1]; % CAMO GREEN
BATHY_LW=0.5;    % linewidth
%LAND_COLOR=[0.6275 0.3216 0.1765]*1.1; % Light SIENNA
LAND_COLOR=[1 1 1]*.7;
EDGE_LAND_COLOR=[ 1 1 1]*0;
TICK=6;
TICK_LEN=0.01;
GRID_LW=0.5;
GRID_COLOR=[1 1 1]*0;

%%   Check input arguments
if(nargin < 1 || isempty(fignum))
    fignum=1;
end
lfig=length(fignum);
if(lfig > 1)
    subnum=fignum(2:4);
    fignum=fignum(1);
end

if(nargin < 2 || isempty(startmap))
    startmap=true;
end

if(nargin < 3 || isempty(wesn))
    fprintf('Will use the entire available bathymetry\n')
    get_wesn=true;
else
    get_wesn=false;
end

if(nargin < 4 || isempty(fsize))
    fsize=FSIZE;
end

if(nargin < 5 || isempty(shaded))
    shaded=false;
end

load_topo=true;
if(nargin < 6 || isempty(bathfile))
    if(startmap)
       error('Please create the bathymetry for this region - see run_plot_bathy.m\n')
    end
else
    if(isstruct(bathfile))
        load_topo=false;
        bathy=bathfile;clear bathfile
    else
        if(~exist(bathfile,'file'))
           error('%s does not exist\n',bathfile)
        end 
    end
end

if(nargin < 7 || isempty(cv))
    cv=CV;
    shaded_cv=SHADED_CV;
else
    shaded_cv=cv;
end

if(nargin < 8 || isempty(projection))
    projection=PROJECTION;
end

%%   Get the bathymetry information


if(startmap)
    if(fignum ~= 0)    % create the figure if requested
        figure(fignum);clf;orient landscape
        if(lfig > 1)
            subplot(subnum(1),subnum(2),subnum(3))
        end
    else
        if(lfig > 1)
            subplot(subnum(1),subnum(2),subnum(3))
        end
    end

    if(load_topo)
           warning('off','MATLAB:load:variableNotFound')
           load(bathfile,'bathy')
           if(~exist('bathy','var'))
               load(bathfile,'gtopo','glon','glat')
               if(~exist('gtopo','var'))
                     load(bathfile,'lons','lats','bath')
                     if(exist('lons','var'))
                         fprintf('Loaded bath lons lats')    % rotated negative down
                     else
                         error('%s exists, but do not recognize the variable names',bathfile)
                     end
               else
                     fprintf('Loaded gtopo glons glat - renaminng')    % rotated positive down
                     bath=-1*gtopo;lons=glon;lats=glat;
               end                       
            else
                bath=bathy.z';lons=bathy.lon;lats=bathy.lat; % unrotated negative down
           end
    else
        bath=bathy.z';lons=bathy.lon;lats=bathy.lat;
    end
    lons = reset_longit(lons,180);
    bath = -1*bath;   % flip signs so positive = depth, negative = height
 
    % Make sure we have the geographical range and don't keep any more of
    % the bathymetry than we need
    if(get_wesn)
        wesn = [min(lons) max(lons) min(lats) max(lats)];
    else
        londx = lons >=wesn(1)-.1 & lons <= wesn(2)+.1;
        latdx = lats >=wesn(3)-.1 & lats <= wesn(4)+.1;
        lons = lons(londx); lats=lats(latdx); bath=bath(latdx,londx);
        clear londx latdx
    end

    m_proj(projection,'longitudes',wesn(1:2),'latitudes',wesn(3:4));
    fprintf('m_proj(%s,longitudes %7.3f %7.3f latitudes %7.3f %7.3f\n',...
            projection,wesn(1:2),wesn(3:4));
    hold on

    %  Plot the bathymetry
    if(shaded)
        [~,mh] = m_contourf(lons,lats,bath,shaded_cv);
        hold on
        set(mh,'color','none')
        cmap=topo_colormap;colormap(cmap)
        if(isfield(bathy,'name'))
            cbstr=[fixscore(lower(bathy.name)) ' depth (m)'];
        else
            cbstr='depth (m)';
        end
        set_colorbar(cbstr,'v',fsize);
    else
        if(length(cv) > 15)
            fprintf('%d is alot of contours - do you really want to do this?\n',length(cv))
            keyboard
        end
        m_contour(lons,lats,bath,cv,'linewidth',BATHY_LW,'color',BATHY_COLOR);
        hold on
        if(any(cv==1500))
           m_contour(lons,lats,bath,[1500 1500],'linewidth',BATH_LW+.5,'color',BATH_COLOR);
        end
    end
else
    m_gshhs_h('patch',LAND_COLOR);    % plot the land
    m_grid('xtick',TICK,'ytick',TICK,'ticklen',TICK_LEN,'color',GRID_COLOR,...
        'fontname','Helvetica','fontsize',fsize,'lineweight',GRID_LW,...
        'tickdir','in','box','fancy','linestyle','none',...
        'XaxisLocation','bottom','YaxisLocation','left');
    set(gcf,'renderer','opengl')   % set(gcf, 'renderer', 'painters')
end

