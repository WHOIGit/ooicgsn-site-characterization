function region_number=define_plot_bathy_region_numbers(get_number,plot_transect)
% function region_number=define_plot_bathy_region_numbers(get_number,plot_transect)
% Hardwired script defining the region numbers for run_plot_bathy.m
% 
% INPUTS:    get_number logical = true return the specifc region number
%                               = false return all definitions for regions (r)
%                     Optional (default false)
%            plot_transect = true when plotting a transect, false = plotting a map
%                     Optional (default false)
% OUTPUTS:   region_number - depending in inputs is either all available
%                               definitions for numbers as structures (r) 
%                               or the user requested region number
%
%%
if(nargin < 1 || isempty(get_number))
    get_number=false;
end

if(nargin < 2 || isempty(plot_transect))
    plot_transect=false;
end

%%   DEFINE NUMBERS FOR EACH REGION
% The specific numbers don't matter, but the values must agree with the
% order of menu requests in the run routine (run_plot_bathy.m)
%
n=1;
r.A095=n;n=n+1;               % 1 -28 to -20 region for A095 bathymetry
r.A095_MAR=n;n=n+1;           % 2 26S to 22S, 15W 5W MAR region for A095 bathymetry
r.A095_MAR_NARROW=n;n=n+1;    % 3 26S to 22S, 15W 5W MAR region for A095 bathymetry
r.CCB=n;n=n+1;                % 4 region for Cape Cod Bay

r.SMAB=n;n=n+1;               % 5 region for Southern Mid-Atlantic-Bight
r.SMAB_MOOR=n;n=n+1;          % 6 just big enough for the SMAB mooring box
r.SMAB_WE=n;n=n+1;          % 7 WE
r.SMAB_CN=n;n=n+1;       % 8 CN 
r.SMAB_EA=n;n=n+1;          % 9 EA
r.SMAB_NO=n;n=n+1;         % 10 NO
r.SMAB_SO=n;n=n+1;         % 11 SO
r.SMAB_NE=n;n=n+1;     % 12 NE
r.SMAB_SE=n;n=n+1;     % 13 SE

r.GOM=n;n=n+1;                % 14 region for Gulf of Mexico
r.OLEANDER=n;n=n+1;           % 15 region of Oleander Line
r.SE_SPACIFIC=n;n=n+1;        % 16 Deep Argo SE Pacific Sector of Southern Ocean

% WE Western site: 35 57.00 N, 75 20.00 W   -> 35.9500 75.3333  @~30 m
% EA Eastern site: 35 57.00 N, 100 m depth  -> 35.9500          @100m
% CN Central site: 35 57.00 N, 75 07.50 W   -> 35.9500 75.1250  @~30 m
% NO Northern site: 36 10.50 N, 100 m depth -> 36.1750          @100m
% SO Southern site: 35 43.50 N, 100 m depth -> 35.7250          @100m
% NE Offshore North site: 36 03.8 N, 600 m depth -> 36.0633     @~300m
% SE Offshore South site: 35 50.2 N, 600 m depth -> 35.8367     @~300m

% NE Northeast site: 36 03.8 N, 600 m depth -> 36.0633          @600m Version 1 no longer used
% SE Southeast site: 35 50.2 N, 600 m depth -> 35.8367          @600m Version 1 no longer used

TRANSECT_OFFSET=n-1;  

r.SMAB_SHAL_CENTRAL_TRANSECT=n;n=n+1;  % 17  no longer used - likely won't work
r.SMAB_DEEP_NORTH_TRANSECT=n;n=n+1;    % 18  no longer used - likely won't work
r.SMAB_DEEP_CENTRAL_TRANSECT=n;n=n+1;  % 19  no longer used - likely won't work
r.SMAB_DEEP_SOUTH_TRANSECT=n;n=n+1;    % 20  no longer used - likely won't work

r.SMAB_WE_EA_CN_TRANSECT=n;n=n+1;      % 21 on 35.95 for WE, EA & CN
r.SMAB_NO_TRANSECT=n;n=n+1;            % 22 on 36.175
r.SMAB_SO_TRANSECT=n;n=n+1;            % 23 on 35.725
r.SMAB_NE_TRANSECT=n;n=n+1;            % 24 on 36.0633
r.SMAB_SE_TRANSECT=n;n=n+1;            % 25 on 35.8367
% r.SMAB_NORTHEAST_TRANSECT=n;n=n+1;          % 28 on 36.0633 Version 1 no longer used
% r.SMAB_SOUTHEAST_TRANSECT=n;n=n+1;          % 29 on 35.8367 Version 1 no longer used

r.A095_LINE=n;n=n+1;                % 26
r.XAYMACA_LINE=n;n=n+1;             % 27
r.OLEANDER_LINE=n;n=n+1;            % 28
r.SE_SPACIFIC_LINES=n;n=n+1;        % 29

%%  GET THE NUMBER FOR THE REGION THE USER ASKS FOR
if(get_number)
   if(plot_transect)
       region_number=menu('Transect Name','A095',...
          'SMAB Shallow Central Transect','SMAB Deep North Transect',...
          'SMAB Deep Central Transect','SMAB Deep South Transect',...
          'SMAB WE-EA-CN Transect','SMAB NO Transect','SMAB SO Transect',...
          'SMAB NE Transect','SMAB SE Transect',...
          'Xaymaca','Oleander Line','SE SOUTH PACIFIC')+TRANSECT_OFFSET;
   else 
       region_number=menu('Region Name','A095','A095 MAR','A095 MAR Narrow',...
          'Cape Cod Bay',...
          'Southern Mid-Atlantic Bight','SMAB Mooring Box',...
          'SMAB Shallow Western','SMAB Zoom Shallow West',...
          'SMAB Shallow Eastern','SMAB Northern','SMAB Southern','SMAB Central',...
          'SMAB Northeastern','SMAB Southeastern',...
          'Gulf of Mexico','Oleander Line','SE SOUTH PACIFIC LINES');
   end
else
    region_number=r;
end
