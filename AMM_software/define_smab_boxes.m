function BOX=define_smab_boxes(get_bathy)
% function BOX=define_smab_boxes()
% PURPOSE: create a structure containing the currently defintion of the
% southern Mid Atlantic Bight OOI boxes and mooring locations
% This is a Hardwired function
% AUTHOR: A. Macdonald
% DATE: 12/19/21
% INPUTS: get_bathy - logical if true get bathymetry estimates for the
%           positions, default is false;
% 
%% MAB Pioneer coordinates						
% 						
% Big Box (for bathymetry, regional maps)						
% point	lat (degN)	lat (minN)	lon (degW)	lon (minW)	(deg N)	(deg W)
% NW	38	0	77	0	38.0000	77.0000
% NE	38	0	73	0	38.0000	73.0000
% SE	34	50	73	0	34.8333	73.0000
% SW	34	50	77	0	34.8333	77.0000
% 						
% Glider box (encompasses the moored array)						
% NW	37	10	75	22	37.1667	75.3667
% NE	37	10	74	20	37.1667	74.3333
% SE	35	30	74	20	35.5000	74.3333
% SW	35	30	75	22	35.5000	75.3667
% 						
% Mooring Box						
% NW	36	15	75	22	36.2500	75.3667
% NE	36	15	74	40	36.2500	74.6667
% SE	35	38	74	40	35.6333	74.6667
% SW	35	38	75	22	35.6333	75.3667
% 						
% Original Mooring sites (nominal as of Dec 2021)						
% Shallow W	35	56.58	75	20.94	35.9430	75.3490
% Shallow E	35	56.58	75	7.5	35.9430	75.1250
% North	36	9.75	74	50.35	36.1625	74.8392
% Central	35	56.59	74	53.46	35.9432	74.8910
% South	35	42.86	74	52.26	35.7143	74.8710
% Offshore N	36	3.17	74	44.99	36.0528	74.7498
% Offshore S	35	49.72	74	49.53	35.8287	74.8255
% Became
% BOX.pos=[35.9430	-75.3490     % 2 km = 0.018 in latitude, .0225 in longitude
%         35.9430	-75.1250
%         36.1625	-74.8392
%         35.9432	-74.8910
%         35.7143	-74.8710
%         36.0528	-74.7498
%         35.8287	-74.8255];
%
% As of 10/3/22 Mooring sites became  Western,Eastern & Central on the same latitude
% WE Western site: 35 57.00 N, 75 20.00 W   -> 35.9500 75.3333
% CN Central site: 35 57.00 N, 75 07.50 W   -> 35.9500 75.1250
% EA Eastern site: 35 57.00 N, 100 m depth  -> 35.9500
% NO Northern site: 36 10.50 N, 100 m depth -> 36.1750
% SO Southern site: 35 43.50 N, 100 m depth -> 35.7250
% NE Northeast site: 36 03.8 N, 600 m depth -> 36.0633
% SE Southeast site: 35 50.2 N, 600 m depth -> 35.8367
%
% As of 11/27/23 Mooring sites Northeast and Southeast were moved
% inshore and renamed
% WE Western site: 35 57.00 N, 75 20.00 W   -> 35.9500 75.3333
% CN Central site: 35 57.00 N, 75 07.50 W   -> 35.9500 75.1250
% EA Eastern site: 35 57.00 N, 100 m depth  -> 35.9500
% NO Northern site: 36 10.50 N, 100 m depth -> 36.1750
% SO Southern site: 35 43.50 N, 100 m depth -> 35.7250
% ON Offshore North site: 36 03.217 N, 75 46.658 W 300 m depth -> 36.0536N 74.7776W
% OS Offshore South site: 35 51.083 N, 74 50.893 W 300 m depth -> 35.8514N 74.8482W

%%
if(nargin < 1 || isempty(get_bathy))
    get_bathy=false;
end

%% If need be - by hand, because a bathy file will be created automatically
% if it doesn't exist, but it is not necessarily larger enough for all
% applications
% BATHYMETRY_FILE ='/Users/alison/DATA/Bathymetry/SRTM15_V2.3.nc';
% bathy=bathymetry_extract(BATHYMETRY_FILE,[33 39 -78 -72]);
% glat=bathy.lat';glon=bathy.lon';
% gtopo = -1*bathy.z';   % flip signs so positive = depth, negative = height
% save region_15ss_topo gtopo glat glon

BOX.big=[34.8333 38 -77 -73];   % s-n w-e      % the full field
BOX.glider=[35.5 37.1667 -75.3667 -74.3333];     % the glider box
BOX.moor=[35.6333 36.2500 -75.3667 -74.6667];  % the mooring box
% WE Western site: 35 57.00 N, 75 20.00 W   -> 35.9500 75.3333
% EA Eastern site: 35 57.00 N, 100 m depth  -> 35.9500
% CN Central site: 35 57.00 N, 75 07.50 W   -> 35.9500 75.1250
% NO Northern site: 36 10.50 N, 100 m depth -> 36.1750
% SO Southern site: 35 43.50 N, 100 m depth -> 35.7250
% ON Offshore North site: 36 03.22 N, 300 m depth -> 36.0536
% OS Offshore South site: 35 51.08 N, 300 m depth -> 35.8514 
% ORIGINAL NE Northeast site: 36 03.8 N, 600 m depth -> 36.0633 Oct 2022 no longer used
% ORIGINAL SE Southeast site: 35 50.2 N, 600 m depth -> 35.8367 Oct 2022 no longer used
         %   included extra SE digit to remove round off error when converting
         %   back to degrees minutes

% BOX.names={'WE' 'EA' 'NO' 'CN' 'SO' 'NE' 'SE'};
% BOX.fields={'west' 'east' 'north' 'central' 'south' 'northeast' 'southeast'};
BOX.names={'WE' 'EA' 'NO' 'CN' 'SO' 'NE' 'SE'};
BOX.fields={'western' 'eastern' 'northern' 'central' 'southern' 'northeast' 'southeast'};
BOX.types={'shallow' 'surface' 'profiler' };
BOX.marker={'sr' 'og' '^b'}; % 2 km = 0.018 in latitude, .0225 in longitude
BOX.markersize=[16 12 14];
BOX.pos=[35.9500 -75.3333     % WE Exact  
         35.9500 -74.8457     % EA linear interp sbathy longitude 100m 
         36.175  -74.8267     % NO interp sbathy longitude 100m  
         35.9500 -75.1250     % CN Exact   
         35.7250 -74.8530     % SO interp sbathy longitude 100m 
         36.0536 -74.7776     % NE chosen after multibean survey ~300m VERSION 2
         35.8514 -74.8482];   % SE chosen after multibean survey ~300m VERSION 2
% position, marker/type
BOX.western=[1 1];      % WE shallow
BOX.eastern=[2 3];      % EA profiler
BOX.northern=[3 2 3];   % NO surface and profiler
BOX.central=[4 1 2];    % CN shallow and surface
BOX.southern=[5 2 3];   % SO surface and profiler
BOX.northeast=[6 3];    % NE profiler
BOX.southeast=[7 3];    % SE profiler

BOX.lon_2km=0.0225;
BOX.lat_2km=0.018;
%                               VERSION 2
%                                   NO
%                                   Surf, Profiler
%                                                  NE
% WE               CN               EA             Profiler
% Shallow          Shallow          Profiler
%                  Surf
%                                                  SE
%                                   SO             Profiler 
%                                   Surf, Profiler



%                               VERSION 1
%                                   NO
%                                   Surf, Profiler
%                                                              NE
% WE               CN               EA                         Profiler
% Shallow          Shallow          Profiler
%                  Surf
%                                                              SE
%                                   SO                         Profiler 
%                                   Surf, Profiler

if(get_bathy)
    if(exist('box_bathy.mat','file'))
        load('box_bathy.mat','bathy','b')
    else
        la=[BOX.big(1);BOX.big(1);BOX.big(2);BOX.big(2); ...
            BOX.glider(1);BOX.glider(1);BOX.glider(2);BOX.glider(2);...
            BOX.moor(1); BOX.moor(1); BOX.moor(2); BOX.moor(2); BOX.pos(:,1)];   % sw se ne nw

        lo=[BOX.big(3);BOX.big(4);BOX.big(4);BOX.big(3); ...
            BOX.glider(3);BOX.glider(4);BOX.glider(4);BOX.glider(3);...
            BOX.moor(3); BOX.moor(4); BOX.moor(4); BOX.moor(3); BOX.pos(:,2)];
        b=get_pos_bathy(la, lo); %  (b.pos(:,1),b.pos(:,2));
        bathy.big=b.srtm(1:4);  % sw se ne nw
        bathy.glider=b.srtm(5:8); % sw se ne nw
        bathy.moor=b.srtm(9:12); % sw se ne nw
        bathy.moorings=b.srtm(13:end);
        save box_bathy.mat bathy b
    end
    BOX.bathy=bathy;
    BOX.allbathy=b;
end
