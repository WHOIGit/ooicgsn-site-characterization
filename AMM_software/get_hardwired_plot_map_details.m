function details=get_hardwired_plot_map_details(region_number,bathname)
%function details=get_hardwired_plot_map_details
% Purpose: to setup the necessary details for the request map
% Warning - this routine is completely hardwired

% Inputs: region_number - specified region number whose definitions are 
%                         provided in define_plot_bathy_region_numbers.m
%         bathname - name defining the type of bathymetry (Optional -
%         default is 'SRTM15_V2.3'
% Outputs: details - structure containing the details for the requested
%                    region including any section data (i.e.
%                    .latitu,.longit data)  to be plotted
%
%% Check the inputs before setting the details for the requested region
q='''';

if(nargin < 1)
    error('Please supply a region number as defined in define_plot_bathy_region_numbers.m')
end

if(nargin < 2 || isempty(bathname))
    bathname='SRTM15_V2.3';
    fprintf('Using default bathymetry type for names %s\n',bathname)
end

r=define_plot_bathy_region_numbers;    % get hardwired region number definitions

switch region_number
    case r.A095    % region for A095 bathymetry
        details.WESN=[-50 20 -35 -20];
        details.BDIV=[-42 -27 -14 -10.65 6 14];   % Basin divisions
        details.BDIVNAME={'WBB' 'EBB' 'WAB' 'EAB' 'NCB'};
        details.TNAME='satl_35S_20S_50W_20E';
        details.BATHDIR='/Users/alison/DATA/Bathymetry/';
        details.BATHFILE=[details.BATHDIR details.TNAME '_' bathname '.mat'];
        details.GTOPOFILE=[details.BATHDIR details.TNAME '_gtopo_' bathname '.mat'];
        details.CV1 = [0 100 1000];
        details.CV2 = [2000 2000];
        details.CV3 = [3000 3000];
        details.CV4 = [4000 4000];
        details.CV5 = [5000 5000];
        details.CV=[0 100 1000:1000:6000];
        details.LEGSTR={'100 & 1000 m' '2000 m' '3000 m' '4000 m' '5000 m'};
        details.TITLE='';
        details.PROJECTION='mercator';
        details.SHADED=true;
        details.MAPNAME='A095';
        get_a095_section_data
        details.SECTIONS={'sect18' 'sect09'};
     case r.A095_MAR    % region for A095 bathymetry
        details.WESN=[-20 -5 -28 -20];
        details.BDIV=[-42 -27 -14 -10.65 6 14];   % Basin divisions
        details.BDIVNAME={'WBB' 'EBB' 'WAB' 'EAB' 'NCB'};
        details.TNAME='satl_35S_20S_50W_20E';
        details.BATHDIR='/Users/alison/DATA/Bathymetry/';
        details.BATHFILE=[details.BATHDIR details.TNAME '_' bathname '.mat'];
        details.GTOPOFILE=[details.BATHDIR details.TNAME '_gtopo_' bathname '.mat'];
        details.CV1 = [1500 1500];
        details.CV2 = [2500 2500];
        details.CV3 = [3500 3500];
        details.CV4 = [4500 4500];
        details.CV4 = [5500 5500];
        details.CV=[details.CV1 details.CV2(1) details.CV3(1) details.CV4(1)];
        details.LEGSTR={'1500 m' '2500 m' '3500 m' '4500 m' '5500 m'};
        details.LEGLOC='Southwest';
        details.TITLE='';
        details.PROJECTION='mercator';
        details.SHADED=true;
        details.MAPNAME='A095_MAR';
        details.get_a095_section_data
        details.SECTIONS={'sect18' 'sect09'};
     case r.A095_MAR_NARROW    
        details.WESN=[-18 -9 -24 -21.75];    % does not need to match bathymetry
        details.BDIV=[-42 -27 -14 -10.65 6 14];   % Basin divisions
        details.BDIVNAME={'WBB' 'EBB' 'WAB' 'EAB' 'NCB'};
        details.TNAME='satl_35S_20S_50W_20E';   %  using A095 bathymetry
        details.BATHDIR='/Users/alison/DATA/Bathymetry/';
        details.BATHFILE=[details.BATHDIR details.TNAME '_' bathname '.mat'];
        details.GTOPOFILE=[details.BATHDIR details.TNAME '_gtopo_' bathname '.mat'];
        details.CV1 = [1500 1500];
        details.CV2 = [2500 2500];
        details.CV3 = [3500 3500];
        details.CV4 = [4500 4500];
        details.CV5 = [5500 5500];
        details.CV=[0 500 1000:1000:6000];
        details.LEGSTR={'1500 m' '2500 m' '3500 m' '4500 m' '5500 m'};
        details.LEGLOC='Southwest';
        details.TITLE='';
        details.PROJECTION='mercator';
        details.SHADED=true;
        details.MAPNAME='A095_MAR_NARROW';
        get_a095_section_data
        details.SECTIONS={'sect18' 'sect09'};       
   case r.CCB     % region for Cape Cod Bay
        details.WESN=[-70.8 -69.9 41.65 42.5];
        details.BATHFILE=['ccb_' bathname '.mat'];
        details.GTOPOFILE=['ccb_gtopo' bathname '.mat'];
        details.CV1 = 0:2:10;
        details.CV2 = 15:5:50;
        details.CV3 = 60:10:100;
        details.CV4 = 120:20:220;
        details.CV=[0:2:10 20:40:300];
        details.TITLE='';
        details.LEGSTR={'2 m 5 m' '10 m' '20 m'};
        details.PROJECTION='lambert';
        details.SHADED=true;
        details.MAPNAME='CCB';
    case r.SMAB    % entire region for Southern Mid-Atlantic-Bight (Figure 2.1.1)
        details.WESN=[-76.5 -74.5 35 37.5];   % to create first cut [-78 -72 33 39]
        details.BDIV=[];   % Basin divisions
        details.BDIVNAME={};
        details.TNAME='satl_78W_72W_33N_39N';
        details.BATHDIR='/Users/alison/DATA/Bathymetry/';
        details.BATHFILE=[details.BATHDIR details.TNAME '_' bathname '.mat'];
        details.GTOPOFILE=[details.BATHDIR details.TNAME '_gtopo_' bathname '.mat'];
        details.CV1 = 0:1:10;
        details.CV2 = 12:2:20;
        details.CV3 = 25:5:50;
        details.CV4 = 60:20:200;
        details.CV5 = 500:500:3000;
        details.CV=[0:5:20 30:20:300 1000 2000 3000];
        details.LEGSTR={'0:10 m' '12:2:20 m' '25:5:50 m' '60:20:200 m' '500:500:3000 m'};
        details.TITLE='';
        details.PROJECTION='mercator';
        details.SHADED=true;
        details.MAPNAME='SMAB';
        details.BOX=define_smab_boxes;
    case r.SMAB_MOOR    % region for Southern Mid-Atlantic-Bight all potential moorings
        details.WESN=[-75.366 -74.666 35.55 36.251];
        details.BDIV=[];   % Basin divisions
        details.BDIVNAME={};
        details.TNAME='satl_78W_72W_33N_39N';
        details.BATHDIR='/Users/alison/DATA/Bathymetry/';
        details.BATHFILE=[details.BATHDIR details.TNAME '_' bathname '.mat'];
        details.GTOPOFILE=[details.BATHDIR details.TNAME '_gtopo_' bathname '.mat'];
        details.CV1 = 20:2:30;
        details.CV2 = 35:5:50;
        details.CV3 = 60:10:100;
        details.CV4 = 150:50:400; 
        details.CV5 = 600:200:2000; 
        details.CV=[0:5:20 30:20:300 1000 2000];
        details.LEGSTR={'20:2:30 m' '35:5:50 m' '60:10:100 m' '150:50:400 m' '600:200:2000 m' };
        details.LEGLOC='NorthWest';
        details.LEGBOX='on';
        details.TITLE='';
        details.PROJECTION='mercator';
        details.SHADED=true;
        details.MAPNAME='SMAB_MOORING BOX';
        details.BOX=define_smab_boxes;
    case r.SMAB_WE_EA_CN_TRANSECT    % includes WE, EA and CN
        details.BOX=define_smab_boxes; 
          mlons=details.BOX.pos([1 2 4],2);mlats=details.BOX.pos([1 2 4],1);
          [mlons,ldx]=sort(mlons);mlats=mlats(ldx);
          dlo=details.BOX.lon_2km;
        details.WESN=[mlons(1)-dlo mlons(end)+2.5*dlo mlats(1) mlats(end)];
        details.BDIV=[];   % Basin divisions
        details.BDIVNAME={};
        details.TNAME='satl_78W_72W_33N_39N';
        details.BATHDIR='/Users/alison/DATA/Bathymetry/';
        details.BATHFILE=[details.BATHDIR details.TNAME '_' bathname '.mat'];
        details.GTOPOFILE=[details.BATHDIR details.TNAME '_gtopo_' bathname '.mat'];
        details.CV1 = 10:10:110;
        details.CV2 = 19:1:25;
        details.CV3 = 30:1:34;
        details.CV4 = 83:1:110;
        details.CV=0:110;
        details.LEGSTR={'10:10:110 m' '19:1:25 m' '30:1:34' '84:110 m'};
        slat=sprintf('%7.4f',mlats(1));
        details.TITLE=['Transect at latitude of WE, CN, and EA (' ...
            slat ' \circN)'];
        details.PROJECTION='mercator';
        details.SHADED=true;
        details.MAPNAME='SMAB_WE_EA_CN_transect';
        details.BOX=define_smab_boxes;  
    case r.SMAB_NO_TRANSECT  % includes longitudes of WE & NO at latitude of NO
        details.BOX=define_smab_boxes;    
          mlons=details.BOX.pos([1 3],2);mlats=details.BOX.pos([3 3],1);
          dlo=details.BOX.lon_2km;
          % factor of 4.5 is 4.5 x 2 km = 9 km beyond eastern end of the section
        details.WESN=[mlons(1)-dlo mlons(end)+4.5*dlo mlats(1) mlats(end)];
        details.BDIV=[];   % Basin divisions
        details.BDIVNAME={};
        details.TNAME='satl_78W_72W_33N_39N';
        details.BATHDIR='/Users/alison/DATA/Bathymetry/';
        details.BATHFILE=[details.BATHDIR details.TNAME '_' bathname '.mat'];
        details.GTOPOFILE=[details.BATHDIR details.TNAME '_gtopo_' bathname '.mat'];
        details.CV1 = 10:10:110;
        details.CV2 = 19:1:25;
        details.CV3 = 30:1:34;
        details.CV4 = 83:1:110;
        details.CV=0:110;
        details.LEGSTR={'10:10:110 m' '19:1:25 m' '30:1:34' '84:110 m'};
        details.TITLE=sprintf('%s (%7.4fN)','Transect at latitude of NO',mlats(1));
        details.PROJECTION='mercator';
        details.SHADED=true;
        details.MAPNAME='SMAB_NO_transect';
        details.BOX=define_smab_boxes;           
    case r.SMAB_SO_TRANSECT        
        details.BOX=define_smab_boxes; % includes longitudes of WE & SO at latitude of SO
          mlons=details.BOX.pos([1 5],2);mlats=details.BOX.pos([5 5],1);
          dlo=details.BOX.lon_2km;
          % factor of 4.5 is 4.5 x 2 km = 9 km beyond eastern end of the section
        details.WESN=[mlons(1)-dlo mlons(end)+4.5*dlo mlats(1) mlats(end)];
        details.BDIV=[];   % Basin divisions
        details.BDIVNAME={};
        details.TNAME='satl_78W_72W_33N_39N';
        details.BATHDIR='/Users/alison/DATA/Bathymetry/';
        details.BATHFILE=[details.BATHDIR details.TNAME '_' bathname '.mat'];
        details.GTOPOFILE=[details.BATHDIR details.TNAME '_gtopo_' bathname '.mat'];
        details.CV1 = 10:10:110;
        details.CV2 = 19:1:25;
        details.CV3 = 30:1:34;
        details.CV4 = 83:1:110;
        details.CV=0:110;
        details.LEGSTR={'10:10:110 m' '19:1:25 m' '30:1:34' '84:110 m'};
        details.TITLE=sprintf('%s (%7.4fN)','Transect at latitude of SO',mlats(1));
        details.PROJECTION='mercator';
        details.SHADED=true;
        details.MAPNAME='SMAB_SO_transect';
        details.BOX=define_smab_boxes;          
    case r.SMAB_NE_TRANSECT        % includes longitudes of CN & NE at latitude of NE
        details.BOX=define_smab_boxes;  
          mlons=details.BOX.pos([4 6],2);mlats=details.BOX.pos([6 6],1);
          dlo=details.BOX.lon_2km;
          % factor of 5 is 5 x 2 km = 10 km beyond eastern end of the section
        details.WESN=[mlons(1)+5*dlo mlons(end)+1*dlo mlats(1) mlats(end)];
        details.BDIV=[];   % Basin divisions
        details.BDIVNAME={};
        details.TNAME='satl_78W_72W_33N_39N';
        details.BATHDIR='/Users/alison/DATA/Bathymetry/';
        details.BATHFILE=[details.BATHDIR details.TNAME '_' bathname '.mat'];
        details.GTOPOFILE=[details.BATHDIR details.TNAME '_gtopo_' bathname '.mat'];
        details.CV1 = 10:10:110;
        details.CV2 = 19:1:25;
        details.CV3 = 30:1:34;
        details.CV4 = 83:1:110;
        details.CV=0:110;
        details.LEGSTR={'10:10:110 m' '19:1:25 m' '30:1:34' '84:110 m'};
        details.TITLE=sprintf('%s (%7.4fN)','Transect at latitude of NE',mlats(1));
        details.PROJECTION='mercator';
        details.SHADED=true;
        details.MAPNAME='SMAB_NE_transect';
        details.BOX=define_smab_boxes;          
    case r.SMAB_SE_TRANSECT  % includes longitudes of CN & SE at latitude of SE
         details.BOX=define_smab_boxes; 
          mlons=details.BOX.pos([4 7],2);mlats=details.BOX.pos([7 7],1);
          dlo=details.BOX.lon_2km;
          % factor of 5 is 5 x 2 km = 9 km beyond eastern end of the section
        details.WESN=[mlons(1)+5*dlo mlons(end)+dlo mlats(1) mlats(end)];
        details.BDIV=[];   % Basin divisions
        details.BDIVNAME={};
        details.TNAME='satl_78W_72W_33N_39N';
        details.BATHDIR='/Users/alison/DATA/Bathymetry/';
        details.BATHFILE=[details.BATHDIR details.TNAME '_' bathname '.mat'];
        details.GTOPOFILE=[details.BATHDIR details.TNAME '_gtopo_' bathname '.mat'];
        details.CV1 = 10:10:110;
        details.CV2 = 19:1:25;
        details.CV3 = 30:1:34;
        details.CV4 = 83:1:110;
        details.CV=0:110;
        details.LEGSTR={'10:10:110 m' '19:1:25 m' '30:1:34' '84:110 m'};
        details.TITLE=sprintf('%s (%7.4fN)','Transect at latitude of SE',mlats(1));
        details.PROJECTION='mercator';
        details.SHADED=true;
        details.MAPNAME='SMAB_SE_transect';
        details.BOX=define_smab_boxes;             
    case r.SMAB_WE      % region for Southern Mid-Atlantic-Bight WE mooring      
        details.BOX=define_smab_boxes;
          mlon=details.BOX.pos(1,2);mlat=details.BOX.pos(1,1);
          dlo=details.BOX.lon_2km;dla=details.BOX.lat_2km;
        details.WESN=[mlon-dlo mlon+dlo mlat-dla mlat+dla];
        details.BDIV=[];   % Basin divisions
        details.BDIVNAME={};
        details.TNAME='satl_78W_72W_33N_39N';
        details.BATHDIR='/Users/alison/DATA/Bathymetry/';
        details.BATHFILE=[details.BATHDIR details.TNAME '_' bathname '.mat'];
        details.GTOPOFILE=[details.BATHDIR details.TNAME '_gtopo_' bathname '.mat'];
        details.CV1 = 17:2:31;
        details.CV2 = 18:2:24;
        details.CV3 = 26:2:34;
        details.CV=16:35;
        details.LEGSTR={'17:2:31 m' '18:2:24 m' '26:2:34 m' };
        details.LEGLOC='NorthWest';
        details.LEGBOX='on';
        details.TITLE='';
        details.PROJECTION='mercator';
        details.SHADED=true;
        details.MAPNAME='SMAB_WE';
        details.BOX=define_smab_boxes;             
   case r.SMAB_CN    % region for Southern Mid-Atlantic-Bight CN Mooring 
        details.BOX=define_smab_boxes;
          mlon=details.BOX.pos(4,2);mlat=details.BOX.pos(4,1);
          dlo=details.BOX.lon_2km;dla=details.BOX.lat_2km;
        details.WESN=[mlon-dlo mlon+dlo mlat-dla mlat+dla];
        details.BDIV=[];   % Basin divisions
        details.BDIVNAME={};
        details.TNAME='satl_78W_72W_33N_39N';
        details.BATHDIR='/Users/alison/DATA/Bathymetry/';
        details.BATHFILE=[details.BATHDIR details.TNAME '_' bathname '.mat'];
        details.GTOPOFILE=[details.BATHDIR details.TNAME '_gtopo_' bathname '.mat'];
        details.CV1 = 29:30;
        details.CV2 = 31:32;
        details.CV3 = 33:35;
        details.CV=16:35;
        details.LEGSTR={'29:30 m' '31:32 m' '33:35 m'};
        details.LEGLOC='NorthWest';
        details.LEGBOX='on';
        details.TITLE='';
        details.PROJECTION='mercator';
        details.SHADED=true;
        details.MAPNAME='SMAB_CN';
        details.BOX=define_smab_boxes;              
    case r.SMAB_EA   % region for Southern Mid-Atlantic-Bight EA mooring
        % 35.9430	-75.1250
        details.BOX=define_smab_boxes;
          mlon=details.BOX.pos(2,2);mlat=details.BOX.pos(2,1);
          dlo=details.BOX.lon_2km;dla=details.BOX.lat_2km;
        details.WESN=[mlon-dlo mlon+dlo mlat-dla mlat+dla];
        details.BDIV=[];   % Basin divisions
        details.BDIVNAME={};
        details.TNAME='satl_78W_72W_33N_39N';
        details.BATHDIR='/Users/alison/DATA/Bathymetry/';
        details.BATHFILE=[details.BATHDIR details.TNAME '_' bathname '.mat'];
        details.GTOPOFILE=[details.BATHDIR details.TNAME '_gtopo_' bathname '.mat'];
        details.CV1 = 83:2:109;
        details.CV2 = 84:2:100;
        details.CV3 = 102:2:108;
        details.CV4 = 110:5:140;
        details.CV5 = 150:10:200;
        details.CV=80:200;
        details.LEGSTR={'83:2:109 m' '84:2:100 m' '102:2:108' '110:5:140 m' '150:10:200 m'};
        details.LEGLOC='NorthWest';
        details.LEGBOX='on';
        details.TITLE='';
        details.PROJECTION='mercator';
        details.SHADED=true;
        details.MAPNAME='SMAB_EA';
        details.BOX=define_smab_boxes;     
    case r.SMAB_NO   % region for Southern Mid-Atlantic-Bight NO Mooring 
        details.BOX=define_smab_boxes;
          mlon=details.BOX.pos(3,2);mlat=details.BOX.pos(3,1);
          dlo=details.BOX.lon_2km;dla=details.BOX.lat_2km;
        details.WESN=[mlon-dlo mlon+dlo mlat-dla mlat+dla];
        details.BDIV=[];   % Basin divisions
        details.BDIVNAME={};
        details.TNAME='satl_78W_72W_33N_39N';
        details.BATHDIR='/Users/alison/DATA/Bathymetry/';
        details.BATHFILE=[details.BATHDIR details.TNAME '_' bathname '.mat'];
        details.GTOPOFILE=[details.BATHDIR details.TNAME '_gtopo_' bathname '.mat'];
        details.CV1 = 83:2:119;
        details.CV2 = 84:2:100;
        details.CV3 = 102:2:120;
        details.CV=80:120;
        details.LEGSTR={'83:2:119 m' '84:2:100 m' '102:2:120 m'};
        details.LEGLOC='NorthWest';
        details.LEGBOX='on';
        details.TITLE='';
        details.PROJECTION='mercator';
        details.SHADED=true;
        details.MAPNAME='SMAB_NO';
        details.BOX=define_smab_boxes;   
    case r.SMAB_SO    % region for Southern Mid-Atlantic-Bight SO Mooring 
        details.BOX=define_smab_boxes;
          mlon=details.BOX.pos(5,2);mlat=details.BOX.pos(5,1);
          dlo=details.BOX.lon_2km;dla=details.BOX.lat_2km;
        details.WESN=[mlon-dlo mlon+dlo mlat-dla mlat+dla];
        details.BDIV=[];   % Basin divisions
        details.BDIVNAME={};
        details.TNAME='satl_78W_72W_33N_39N';
        details.BATHDIR='/Users/alison/DATA/Bathymetry/';
        details.BATHFILE=[details.BATHDIR details.TNAME '_' bathname '.mat'];
        details.GTOPOFILE=[details.BATHDIR details.TNAME '_gtopo_' bathname '.mat'];
        details.CV1 = 75:2:109;
        details.CV2 = 76:2:100;
        details.CV3 = 102:2:108;
        details.CV4 = 110:5:140;
        details.CV5 = 150:10:220;
        details.CV=75:220;
        details.LEGSTR={'75:2:109 m' '76:2:100 m' '102:2:108' '110:5:140 m' '150:10:220 m'};
        details.LEGLOC='NorthWest';
        details.LEGBOX='on';
         details.TITLE='';
        details.PROJECTION='mercator';
        details.SHADED=true;
        details.MAPNAME='SMAB_SO';
        details.BOX=define_smab_boxes;       
    case r.SMAB_NE    % region for Southern Mid-Atlantic-Bight NE Mooring 
        details.BOX=define_smab_boxes;
          mlon=details.BOX.pos(6,2);mlat=details.BOX.pos(6,1);
          dlo=details.BOX.lon_2km;dla=details.BOX.lat_2km;
        details.WESN=[mlon-dlo mlon+dlo mlat-dla mlat+dla];  % +/- 2 km
        details.BDIV=[];   % Basin divisions
        details.BDIVNAME={};
        details.TNAME='satl_78W_72W_33N_39N';
        details.BATHDIR='/Users/alison/DATA/Bathymetry/';
        details.BATHFILE=[details.BATHDIR details.TNAME '_' bathname '.mat'];
        details.GTOPOFILE=[details.BATHDIR details.TNAME '_gtopo_' bathname '.mat'];
        details.CV1 = 275:10:325;
        details.CV2 = 260:40:340;
        details.CV3 = 150:50:500;
        details.CV=100:50:600;
        details.LEGSTR={'275:10:325 m' '260:40:340 m' '150:50:500 m'};
        details.LEGLOC='NorthWest';
        details.LEGBOX='on';
         details.TITLE='';
        details.PROJECTION='mercator';
        details.SHADED=true;
        details.MAPNAME='SMAB_NE';
        details.BOX=define_smab_boxes;
    case r.SMAB_SE   % region for Southern Mid-Atlantic-Bight SE Mooring 
        details.BOX=define_smab_boxes;
          mlon=details.BOX.pos(7,2);mlat=details.BOX.pos(7,1);
          dlo=details.BOX.lon_2km;dla=details.BOX.lat_2km;
        details.WESN=[mlon-dlo mlon+dlo mlat-dla mlat+dla];
        details.BDIV=[];   % Basin divisions
        details.BDIVNAME={};
        details.TNAME='satl_78W_72W_33N_39N';
        details.BATHDIR='/Users/alison/DATA/Bathymetry/';
        details.BATHFILE=[details.BATHDIR details.TNAME '_' bathname '.mat'];
        details.GTOPOFILE=[details.BATHDIR details.TNAME '_gtopo_' bathname '.mat'];
        details.CV1 = 275:10:325;
        details.CV2 = 260:40:340;
        details.CV3 = 150:50:600;
        details.CV=100:50:600;
        details.LEGSTR={'275:10:325 m' '260:40:340 m' '150:50:600 m'};
        details.LEGLOC='NorthWest';
        details.LEGBOX='on';
        details.TITLE='';
        details.PROJECTION='mercator';
        details.SHADED=true;
        details.MAPNAME='SMAB_SE';
        details.BOX=define_smab_boxes;
    case r.SMAB_SHAL_CENTRAL_TRANSECT
        details.BOX=define_smab_boxes;
          % includes ShalW, ShalE and Central
          mlons=details.BOX.pos([1 2 4],2);mlats=details.BOX.pos([1 2 4],1);
          dlo=details.BOX.lon_2km;dla=details.BOX.lat_2km;
        details.WESN=[mlons(1)-dlo mlons(end)+dlo mlats(1)-dla mlats(end)+dla];
        details.BDIV=[];   % Basin divisions
        details.BDIVNAME={};
        details.TNAME='satl_78W_72W_33N_39N';
        details.BATHDIR='/Users/alison/DATA/Bathymetry/';
        details.BATHFILE=[details.BATHDIR details.TNAME '_' bathname '.mat'];
        details.GTOPOFILE=[details.BATHDIR details.TNAME '_gtopo_' bathname '.mat'];
        details.CV1 = 10:10:110;
        details.CV2 = 19:1:25;
        details.CV3 = 30:1:34;
        details.CV4 = 83:1:110;
        details.CV=0:110;
        details.LEGSTR={'10:10:110 m' '19:1:25 m' '30:1:34' '84:110 m'};
        details.PROJECTION='mercator';
        details.SHADED=true;
        details.MAPNAME='SMAB_shallow_central_transect';
        details.BOX=define_smab_boxes;  
    case r.SMAB_DEEP_NORTH_TRANSECT        
         details.BOX=define_smab_boxes;
          % includes longitudes of ShalW, ShalE and North /w latitude of North
          mlons=details.BOX.pos([1 2 3],2);mlats=details.BOX.pos([3 3 3],1);
          dlo=details.BOX.lon_2km;dla=details.BOX.lat_2km;
          % factor of 4.5 is 4.5 x 2 km = 9 km beyond eastern end of the section
        details.WESN=[mlons(1)-dlo mlons(end)+4.5*dlo mlats(1)-dla mlats(end)+dla];
        details.BDIV=[];   % Basin divisions
        details.BDIVNAME={};
        details.TNAME='satl_78W_72W_33N_39N';
        details.BATHDIR='/Users/alison/DATA/Bathymetry/';
        details.BATHFILE=[details.BATHDIR details.TNAME '_' bathname '.mat'];
        details.GTOPOFILE=[details.BATHDIR details.TNAME '_gtopo_' bathname '.mat'];
        details.CV1 = 10:10:110;
        details.CV2 = 19:1:25;
        details.CV3 = 30:1:34;
        details.CV4 = 83:1:110;
        details.CV=0:110;
        details.LEGSTR={'10:10:110 m' '19:1:25 m' '30:1:34' '84:110 m'};
        details.PROJECTION='mercator';
        details.SHADED=true;
        details.MAPNAME='SMAB_deep_north_transect';
        details.BOX=define_smab_boxes;                       
    case r.SMAB_DEEP_CENTRAL_TRANSECT
        details.BOX=define_smab_boxes;
          % includes ShalW, ShalE and Central
          mlons=details.BOX.pos([1 2 4],2);mlats=details.BOX.pos([1 2 4],1);
          dlo=details.BOX.lon_2km;dla=details.BOX.lat_2km;
        details.WESN=[mlons(1)-dlo mlons(end)+10*dlo mlats(1)-dla mlats(end)+dla];
        details.BDIV=[];   % Basin divisions
        details.BDIVNAME={};
        details.TNAME='satl_78W_72W_33N_39N';
        details.BATHDIR='/Users/alison/DATA/Bathymetry/';
        details.BATHFILE=[details.BATHDIR details.TNAME '_' bathname '.mat'];
        details.GTOPOFILE=[details.BATHDIR details.TNAME '_gtopo_' bathname '.mat'];
        details.CV1 = 10:10:110;
        details.CV2 = 19:1:25;
        details.CV3 = 30:1:34;
        details.CV4 = 83:1:110;
        details.CV=0:110;
        details.LEGSTR={'10:10:110 m' '19:1:25 m' '30:1:34' '84:110 m'};
        details.PROJECTION='mercator';
        details.SHADED=true;
        details.MAPNAME='SMAB_deep_central_transect';
        details.BOX=define_smab_boxes;         
    case r.SMAB_DEEP_SOUTH_TRANSECT        
         details.BOX=define_smab_boxes;
          % includes longitudes of ShalW, ShalE and South /w latitude of South
          mlons=details.BOX.pos([1 2 5],2);mlats=details.BOX.pos([5 5 5],1);
          dlo=details.BOX.lon_2km;dla=details.BOX.lat_2km;
          % factor of 4.5 is 4.5 x 2 km = 9 km beyond eastern end of the section
        details.WESN=[mlons(1)-dlo mlons(end)+4.5*dlo mlats(1)-dla mlats(end)+dla];
        details.BDIV=[];   % Basin divisions
        details.BDIVNAME={};
        details.TNAME='satl_78W_72W_33N_39N';
        details.BATHDIR='/Users/alison/DATA/Bathymetry/';
        details.BATHFILE=[details.BATHDIR details.TNAME '_' bathname '.mat'];
        details.GTOPOFILE=[details.BATHDIR details.TNAME '_gtopo_' bathname '.mat'];
        details.CV1 = 10:10:110;
        details.CV2 = 19:1:25;
        details.CV3 = 30:1:34;
        details.CV4 = 83:1:110;
        details.CV=0:110;
        details.LEGSTR={'10:10:110 m' '19:1:25 m' '30:1:34' '84:110 m'};
        details.PROJECTION='mercator';
        details.SHADED=true;
        details.MAPNAME='SMAB_deep_south_transect';
        details.BOX=define_smab_boxes;                       
    case r.GOM     % region for Gulf of Mexico Contents needs to be corrected     
        details.WESN=[-108  -102   -68   -65];
        details.BATHFILE=['gom_' bathname '.mat'];
        details.GTOPOFILE=['gom_gtopo' bathname '.mat'];
        details.TNAME='';
        details.CV1 = 3500:1000:5500;
        details.CV2 = 3000:1000:6000;
        details.CV3 = 3250:500:5750;
        details.CV=3500:500:6000;
        details.TITLE='';
        details.LEGSTR={'500 m' '1000 m' '250 m'};
        details.PROJECTION='mercator';
        details.SHADED=true;
        details.MAPNAME='SWPAC';
    case r.SE_SPACIFIC_LINES   % region for transects in Deep Argo SE Pacific 
        details.WESN=[-147   -79   -70   -59];
        details.BDIV=[];   % Basin divisions
        details.BDIVNAME={'SESPAC' };
        details.TNAME='sepac';  % sepac_GEBCO_2022_sub_ice_topo
        details.BATHDIR='/Users/alison/PROJECTS/STUDENT_PROJECTS/SSF_2023/AMM_WORK23/';
        details.BATHFILE=[details.BATHDIR details.TNAME '_' bathname '.mat'];
        details.GTOPOFILE=[details.BATHDIR details.TNAME '_gtopo_' bathname '.mat'];
        details.CV1 = [0 100 1000];
        details.CV2 = [2000 2000];
        details.CV3 = [3000 3000];
        details.CV4 = [4000 4000];
        details.CV5 = [5000 5000];
        details.CV=[0 100 1000:1000:6000];
        details.LEGSTR={'100 & 1000 m' '2000 m' '3000 m' '4000 m' '5000 m'};
        details.TITLE='';
        details.PROJECTION='mercator';
        details.SHADED=true;
        details.MAPNAME='SESPAC_SECTS';
        load('sepac_sect_data','sects')
        details.SECTIONS={'sects'};
    case r.SE_SPACIFIC    % region for SE Pacific Deep Argo region
        details.WESN=[-147   -79   -70   -59];
        details.BDIV=[];   % Basin divisions
        details.BDIVNAME={'SESPAC' };
        details.TNAME='sepac';  % sepac_GEBCO_2022_sub_ice_topo
%         details.BATHDIR='/Users/alison/DATA/Bathymetry/';
%         details.BATHFILE=[details.BATHDIR details.TNAME '_' bathname '.mat'];
%         details.GTOPOFILE=[details.BATHDIR details.TNAME '_gtopo_' bathname '.mat'];
        details.BATHDIR='/Users/alison/PROJECTS/STUDENT_PROJECTS/SSF_2023/AMM_WORK23/';
        details.BATHFILE=[details.BATHDIR details.TNAME '_' bathname '.mat'];
        details.GTOPOFILE=[details.BATHDIR details.TNAME '_gtopo_' bathname '.mat'];
        details.CV1 = [0 100 1000];
        details.CV2 = [2000 2000];
        details.CV3 = [3000 3000];
        details.CV4 = [4000 4000];
        details.CV5 = [5000 5000];
        details.CV=[0 100 1000:1000:6000];
        details.LEGSTR={'100 & 1000 m' '2000 m' '3000 m' '4000 m' '5000 m'};
        details.TITLE='';
        details.PROJECTION='mercator';
        details.SHADED=true;
        details.MAPNAME='SESPAC';
end

if(isfield(details,'SECTIONS') && ~isempty(details.SECTIONS))
    for sdx=1:length(details.SECTIONS)
        s=details.SECTIONS{sdx};
        eval(['details.(' q s q ')=' s ';'])
    end
else
    details.SECTIONS={};
end
        

