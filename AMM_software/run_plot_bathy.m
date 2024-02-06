function run_plot_bathy(fignum,bathytype,region_id,wesn,plot_transect,printit,crop_lrbt,find_depth,radius_km)
% function run_plot__bathy(fignum,bathytype,region_id,wesn,plot_transect,printit,crop_lrbt,find_depth,radius_km)
% PURPOSE: to plot bathymetry in a region, it sets up parameters
% specific to the bathymetry and region - at a minimum the geographic range 
% and once the  extraction of the specific bathymetry is done, 
% this routine calls a  subroutine to do the plotting
% AUTHOR: A. Macdonald
%
% All arguments are optional - but some will be be requested if not provided
% Inputs: fignum - figure number to use, can include a 3 digit subplot
%                  e.g. [1 3 2 1] -> Figure 1, subplot(3,2,1)
%                  Optional - default is 1 with no subplit
%         bathytype - 1 = SRTM15  
%                     2 = 2022 GEBCO
%                     3 = CRM ngdc coastal relief model
%                     4 = noaa ship soundings (presently on works for SMAB)
%               (optional - default = 1)
%         region_id - can be 
%                   1. a region name (see below), or
%                   2. number (also see below) or 
%                   3. WESN range  or 
%                   4. a structure containing extracted bathy or
%                   5. the name of a file containing the extracted bathymetry structure
%                   If this is either of these last two, then the entire region is plotted
%         wesn - a region name, number or bathy file if supplied as the
%                first argument, a [West East South North] second argument
%                can also be provided to plot a subregion
%         plot_transect - logical, true = instead of plotting a map, plot a transect
%                 if not provided it is assumed to be false
%         printit - logical, print the resulting figure. 
%                     Optional - default if thereare not subpanels is true
%                     otherwise it is false
%         crop_lrbt - if you want a version cropped at any of [left, right, bottom, top]
%                   must include 4 values, but as many as 3 can be 0.
%                   Optional: default is all zero, i.e. not used
%         find_depth - value, depth to find the longitude of a specific depth
%                   on a zonal section. If positive/negative use find first instance 
%                   of bathymetry greater/less than find_depth. When used
%                   the code ends after finding the longitude requested. 
%                   Note, this argument may one day need to be smarter
%                   (optional - default empty = do not use)
%         radius_km - only used for the individual mooring maps, plot a circle 
%                with radius = radius_km around the mooring position
%                (Optional only used if provided, if empty, 0 or negative
%                it is not used.)
%      % 
%% Hardwired Variables and check input arguments
SRTM15=1;
GEBCO=2;
CRM=3;
SOUNDINGS=4;

set_fignum=false;
if(nargin < 1 || isempty(fignum))
    fignum=1;
    set_fignum=true;
end
lfig=length(fignum);

if(nargin < 2 || isempty(bathytype))
    bathytype=1;
end

switch bathytype
    case SRTM15
        fprintf('Using SRTM15_V2.3 bathymetry\n')
        GLOBAL_BATHDIR='/Users/alison/DATA/Bathymetry/';
        BATHNAME ='SRTM15_V2.3';
        CBARNAME='SRTM15';
        GLOBAL_BATHFILE=[GLOBAL_BATHDIR BATHNAME '.nc'];
    case GEBCO  
        fprintf('Using GEBCO 2022 bathymetry\n')
        GLOBAL_BATHDIR='/Users/alison/DATA/Bathymetry/gebco_2022_sub_ice_topo/';
        BATHNAME ='GEBCO_2022_sub_ice_topo';
        CBARNAME='GEBCO_2022';
        GLOBAL_BATHFILE=[GLOBAL_BATHDIR BATHNAME '.nc'];
    case CRM       
        fprintf('Using CRM Coastal Relief bathymetry\n')       
        GLOBAL_BATHDIR='/Users/alison/DATA/Bathymetry/';
        BATHNAME ='crm_vol2';
        CBARNAME='CRM_2022';
        GLOBAL_BATHFILE=[GLOBAL_BATHDIR BATHNAME '.nc'];
  case SOUNDINGS
        fprintf('Using NOAA Sounding bathymetry\n')       
        error('Not yet working')
    otherwise
        error('Do not recognize bathytype %d',bathytype)
end
LEGLOC='NorthOutside';
LEGBOX='off';
KM2=0.018;  % in degrees = ~2 km in latitude at 36N

if(exist('near','file')~=2)
    addpath /Users/alison/matlab/DOWNLOADS/nctoolbox-1.1.3/    % AMM 11/22/21
    addpath ~/matlab/ocean_data_tools-master/ocean_data_tools/
    setup_nctoolbox
end

fsize=14;

%% Check  input arguments 3-7
have_bathfile=false;
have_rnumber=false;
have_wesn=false;

if(nargin < 9)
    radius_km=[];
end

if(nargin < 8 || isempty(find_depth))
    get_depth=false;
else
    get_depth=true;
end

if(nargin >= 7 && ~isempty(crop_lrbt))
    cropit=true;
else
    cropit=false;
end

if(nargin < 6 || isempty(printit))
    if(length(fignum)==1 && set_fignum)
        printit=true;
    else
        printit=false;
    end
end

if(nargin < 5 || isempty(plot_transect))
    plot_transect=menu('Plot Type','Map','Section')-1;
end

if(nargin < 3 || isempty(region_id) )
    id=menu('Specify region by ','name','number','geographic range','bathymetry filename');
    switch id
        case 1
          region_number=define_plot_bathy_region_numbers(true,plot_transect);
          have_rnumber=true;
        case 2
           region_number=input('Region Number: ');
           have_rnumber=true;
        case 3
           wesn=input('Specify [W E S N] range: ');
           have_wesn=true;
        case 4
           bathfile=input('Bathymetry Filename ');
    end
else
    if(isnumeric(region_id))
        nval=length(region_id);
        if(nval==1)
            region_number=region_id;
            have_rnumber=true;
        elseif(nval==4)
            wesn=region_id;
            have_wesn=true;
        else
            disp(region_id)
            error('Do not recognize numeric first argument')
        end
        
    elseif(isstruct(region_id))
        bathy=region_id;
       
    elseif(ischar(region_id))
        if(exist(region_id,'file'))
            bathfile=region_id;
            have_bathfile=true;
        elseif(exist([GLOBAL_BATHDIR region_id],'file'))
            bathfile=[GLOBAL_BATHDIR region_id];
            have_bathfile=true;
        else
            have_rnumber=true;
            eval(['region_number = ' region_id ';']);
        end
    end
    
    if(~have_rnumber)
        region_number=define_plot_bathy_region_numbers(true,plot_transect);
        have_rnumber=true;
    end
end


if(nargin >= 4 && ~isempty(wesn))
    have_wesn=true;
end

%% Get the hardwired details necessary to make the plot
    
have_WESN=false;
if(have_rnumber)
    have_WESN=true;
end

d=get_hardwired_plot_map_details(region_number,BATHNAME);  
if(isfield(d,'LEGLOC') && ~isempty(d.LEGLOC))
    LEGLOC=d.LEGLOC;
end
if(isfield(d,'LEGBOX') && ~isempty(d.LEGLOC))
    LEGBOX=d.LEGBOX;
end
%%   To prevent warning messages about reading the wrong type of bathyfile
% lastwarn % produces  'Variable 'bath' not found.'
% w = warning('query','last')
% w = 
% 
%   struct with fields:
% 
%     identifier: 'MATLAB:load:variableNotFound'
%          state: 'on'
% id = w.identifier;
warning('off','MATLAB:load:variableNotFound')

%%   If we don't have it yet - get the bathymetry
% If it doesn't exist - get the regional data from the SRTM15 and save it
% in format provided by 
% ~/matlab/ocean_data_tools-master/ocean_data_tools/bathymetry_extract.m
% Then convert it for use with plot_any_track as gtopo and save it that way
% too


if(~exist('bathy', 'var'))
    if(have_bathfile)
        d.BATHFILE=bathfile;    % if provided on the command line, then use it
    end
    if(~exist(d.BATHFILE,'file'))
        if(have_wesn)     % if we specified a subregion, use it
            snwe= [wesn(3:4) wesn(1:2)];
        else              % use the pre-defineed region             
            snwe= [d.WESN(3:4) d.WESN(1:2)];
        end
        fprintf('Creating bathymetry file %s\n',d.TNAME) 
        if(bathytype==CRM)
            bathy = extract_crm_3arcsec_bathy(GLOBAL_BATHFILE,snwe([3 4 1 2]));
        else
            bathy = bathymetry_extract(GLOBAL_BATHFILE,snwe);
        end
        bathy.name=CBARNAME;    % the name that will be used on the colorbar
        fprintf('Saving bathy in %s\n',d.BATHFILE);save(d.BATHFILE,'bathy')
        glat=bathy.lat(:);glon=bathy.lon(:);gtopo=-1*bathy.z';
        fprintf('Saving gtopo version in %s\n',d.GTOPOFILE);save(d.GTOPOFILE,'gtopo','glat','glon')           
    else
        fprintf('Loading bathymetry from %s\n',d.BATHFILE);
        load(d.BATHFILE,'bathy') 
        fprintf('Load complete\n') 
    end
else
    fprintf('Using existing bathy structure\n')
end

if(~have_wesn)     % if not specified, then use the whole available region
    if(have_WESN)
        wesn=d.WESN;
    else
        wesn= [min(bathy.lon) max(bathy.lon) min(bathy.lat) max(bathy.lat) ];
    end
end


%%  Now plot the requested bathymetry
r=define_plot_bathy_region_numbers;    % get hardwired region number definitions

if(plot_transect)       % create a section plot
    sbathy=retrieve_sect_bathy(bathy,wesn);
    
   if(get_depth) % at present this only works on zonal transects
       % To get longitude at a particular depth along a line of latitude
       if(find_depth < 0 )   % find the last instance less than depth
           Y=abs(find_depth);
           x1=find(sbathy.bathy < Y, 1,'last'); % for North when searching for 100 m
       else                  % find the first instance greater than depth
           Y=find_depth;
           x1=find(sbathy.bathy > Y, 1,'first');
       end
       x=[x1-1 x1 x1+1];
       new_lon=interp1(sbathy.bathy(x),sbathy.lon(x),Y);
       fprintf('Update define_smab_boxes.m with this longitude: %8.4f\n',new_lon)
       return
    end
    plot_sect_bathy(fignum,sbathy,d.BOX);
    
    sbathy_N1=retrieve_sect_bathy(bathy,wesn+[0 0 KM2 KM2]);
    h1=plot_sect_bathy(fignum,sbathy_N1,[],1);
    sbathy_N2=retrieve_sect_bathy(bathy,wesn+[0 0 2*KM2 2*KM2]);
    h2=plot_sect_bathy(fignum,sbathy_N2,[],2);
    sbathy_N3=retrieve_sect_bathy(bathy,wesn+[0 0 3*KM2 3*KM2]);
    h3=plot_sect_bathy(fignum,sbathy_N3,[],3);
    sbathy_N4=retrieve_sect_bathy(bathy,wesn+[0 0 -KM2 -KM2]);
    h4=plot_sect_bathy(fignum,sbathy_N4,[],-1);
    sbathy_N5=retrieve_sect_bathy(bathy,wesn+[0 0 -2*KM2 -2*KM2]);
    h5=plot_sect_bathy(fignum,sbathy_N5,[],-2);
    sbathy_N6=retrieve_sect_bathy(bathy,wesn+[0 0 -3*KM2 -3*KM2]);
    h6=plot_sect_bathy(fignum,sbathy_N6,[],-3);
        
    if(length(fignum)==1)
        sectfile=[bathy.name '_' d.MAPNAME];
        legend([h1 h2 h3 h4 h5 h6],'2 km north','4 km north','6 km north',...
            '2 km south','4 km south','6 km south','location','SouthWest',...
            'FontSize',13)
    else    % presumably we are making subpanels of different bathymetry databases
        sectfile=d.MAPNAME;
        if(printit)
            legend([h1 h2 h3 h4 h5 h6],'2 km north','4 km north','6 km north',...
            '2 km south','4 km south','6 km south','location','Best',...
            'FontSize',10)
            disp('Move Legend, hit any key to continue');pause
        end
    end

    tstr=[fixscore(bathy.name) ' ' d.TITLE];
    if(region_number == r.SMAB_DEEP_NORTH_TRANSECT || ...
       region_number == r.SMAB_DEEP_CENTRAL_TRANSECT || ...
       region_number == r.SMAB_DEEP_SOUTH_TRANSECT)
   
       ax=axis;ax(2)=-74.72;ax(4)=700;axis(ax);
       llx=ax(1)+(ax(2)-ax(1))*.05;lly=ax(4)*.65;
       text(llx,lly,tstr,'HorizontalAlignment','left','FontSize',14,'color','b')
       if(~cropit && printit)
            print('-dpdf',sectfile)
       end
       
       if(cropit)
           adx=crop_lrbt~=0;
           ax(adx)=crop_lrbt(adx);axis(ax)
           llx=ax(1)+(ax(2)-ax(1))*.05;lly=ax(4)*.65;
           text(llx,lly,tstr,'HorizontalAlignment','left','FontSize',14,'color','b')
           if(printit)
              print('-dpdf',[sectfile '_cropped'])
           end
       end
    else
       ax=axis;
             
       if(cropit)
           adx=crop_lrbt~=0;
           ax(adx)=crop_lrbt(adx);axis(ax)
       end
       
       llx=ax(1)+(ax(2)-ax(1))*.05;lly=ax(4)*.65;
       if(length(fignum)==1)
           FF=16;
       else
           FF=14;
       end
       text(llx,lly,tstr,'HorizontalAlignment','left','FontSize',FF,'color','b')
       if(printit)
           print('-dpdf','-bestfit',sectfile)
       end
    end
 
else                    % Create the map
    
    if(lfig==1 || (lfig ==4 && fignum(4)==1))    % if we are starting from scratch
        fignumh=figure(fignum(1));orient tall 
%         fignumh=figure; 
        set(fignumh,'defaultLegendAutoUpdate','off');    % Don't want automatic updates to the legend
    end
    if(lfig>1)
        subplot(fignum(2),fignum(3),fignum(4))
    end

    % plot_bathy(fignumnum,startmap,wesn,fontsize,shaded_tf,bathfile_or_bathy,cv,projection)
    % orange [ 1.0 0.4 0.2]
    plot_bathy(fignum,true,wesn,fsize,d.SHADED,bathy,d.CV,d.PROJECTION)

        lodx=bathy.lon >= wesn(1)-.1 & bathy.lon <= wesn(2)+.1;lo=bathy.lon(lodx);
        ladx=bathy.lat >= wesn(3)-.1 & bathy.lat <= wesn(4)+.1;la=bathy.lat(ladx);
        z=-1*bathy.z(lodx,ladx)';
        have_ch=false;
        if(isfield(d, 'CV1'))
            [cs,h1] = m_contour(lo,la,z,d.CV1);
            h1.EdgeColor=[0.7 0.7 0.7];h1.LineWidth=0.5; % gray
    %         clabel(cs,h1,[19.1 19.14],'Color',[0.7 0.7 0.7],'FontWeight','bold');
            clabel(cs,h1,d.CV1(1:3:end),'Color',[0.7 0.7 0.7],'FontWeight','bold');
            ch=h1;have_ch=true;
        end
        if(isfield(d,'CV2'))
            [cs,h2] = m_contour(lo,la,z,d.CV2);
            h2.EdgeColor=[ 0.2 0.5 0.5];h2.LineWidth=1; % green
            clabel(cs,h2,d.CV2(1:3:end),'Color',[0.2 0.5 0.5],'FontWeight','bold');
            if(have_ch)
                ch=[ch h2];
            else
                ch=h2;have_ch=true;
            end
        end
        if(isfield(d,'CV3'))
            [cs,h3] = m_contour(lo,la,z,d.CV3);
            h3.EdgeColor=[0.2 0.2 0.7];h3.LineWidth=0.75; % royal blue
            clabel(cs,h3,d.CV3(1:3:end),'Color',[0.2 0.2 0.7],'FontWeight','bold');
            if(have_ch)
                ch=[ch h3];
            else
                ch=h3;have_ch=true;
            end
        end
        if(isfield(d,'CV4'))
            [cs,h4] = m_contour(lo,la,z,d.CV4);
            h4.EdgeColor=[ 0  0 0];h4.LineWidth=0.75; % black
            clabel(cs,h4,d.CV4(1:3:end),'Color',[0 0 0],'FontWeight','bold');
            if(have_ch)
                ch=[ch h4];
            else
                ch=h4;have_ch=true;
            end
        end
        if(isfield(d,'CV5'))
            [cs,h5] = m_contour(lo,la,z,d.CV5);
            h5.EdgeColor=[.6 .2 1];h5.LineWidth=0.75; % purple
            clabel(cs,h5,d.CV5(1:3:end),'Color',[.6 .2 1],'FontWeight','bold');
            if(have_ch)
                ch=[ch h5];
            else
                ch=h5;
            end
        end

        % m_text(-70.45,41.95,'Subtropical South Atlantic','FontSize',16)
        % If plot A095
        switch region_number
            case {r.A095 r.A095_MAR r.A095_MAR_NARROW}
                for bdx=2:length(d.BDIV)-1     % put in A095 basin divisions
                   if(d.BDIV(bdx) >= wesn(1) && d.BDIV(bdx) <= wesn(2))  % but onlt where they exist
                       m_plot([d.BDIV(bdx) d.BDIV(bdx)],wesn(3:4),'k-','Linewidth',1);
                   end
                end
                for bdx=1:length(d.BDIV)-1     % put in A095 basin labels            
                   % now label the regions shown in the plot
                   tlo1=max([wesn(1) d.BDIV(bdx)]);tlo2=min([wesn(2) d.BDIV(bdx+1)]);
                   tlo=mean([tlo1 tlo2]);
                   tla=wesn(3)+.15*abs(diff(wesn(3:4)));
                   if(tlo >= wesn(1) && tlo <= wesn(2))
                       th=m_text(tlo,tla,d.BDIVNAME{bdx},'FontSize',14);
                       th.HorizontalAlignment ='center';
                   end
                end
            case r.CCB
            case {r.SMAB}               % plot the SMAB boxes
                plot_smab_boxes(d.BOX,true,true,true,true,false,wesn);
            case r.SMAB_MOOR   % plot all moorings in the mooring box
                plot_smab_boxes(d.BOX,false,false,true,true,false,wesn);           
            case {r.SMAB_WE  r.SMAB_EA ...
                    r.SMAB_NO r.SMAB_SO r.SMAB_CN r.SMAB_NE r.SMAB_SE}  % only plot moorings      
                plot_smab_boxes(d.BOX,false,false,true,true,false,wesn,radius_km);  % plot individual mooring
            otherwise
        end

        legstr=d.LEGSTR;
        if(~isempty(d.SECTIONS))
            syms={'ro' 'bx'};
            for idx=1:length(d.SECTIONS)
                eval(['s=d.' d.SECTIONS{idx} ';'])
                ldx=s.longit >= wesn(1) & s.longit <= wesn(2) & ...
                     s.latitu >= wesn(3) & s.latitu <= wesn(4);
                h=m_plot(s.longit(ldx),s.latitu(ldx),syms{idx});
                if(region_number == A095_MAR_NARROW)
                    h.MarkerSize=8;h.LineWidth=1;
                else
                    h.MarkerSize=4;
                end

                ch=[ch h];
                legstr=[legstr d.SECTIONS{idx}];
            end
        end

        if(lfig==1)
    %       legend(ch,legstr,'location',LEGLOC,'fontsize',12,'Box','off','Orientation','Horizontal')
            legend(ch,legstr,'location',LEGLOC,'fontsize',12,'Box',LEGBOX);
            if(lfig > 1)
               disp('Move Legend, hit any key to continue');pause
            end
        end      
        title(fixscore(d.MAPNAME(6:end)),'FontSize', 14)
        
    plot_bathy(fignum,false,wesn)    % finish off with land and grid

    if(lfig == 1 && printit)    
        mapname=[bathy.name '_' d.MAPNAME];
        hres_mapname=[ mapname '_hres500'];
        print('-djpeg','-r500',hres_mapname);
           fprintf('Saved as %s.jpg\n',hres_mapname)
        print('-djpeg',mapname)
        print('-dpdf',mapname)
        savefig(mapname)  
           fprintf('Saved as %s.fig, jpg and .pdf \n',mapname);
    elseif(printit)
        mapname=d.MAPNAME;
        hres_mapname=[ mapname '_hres500'];
        print('-djpeg','-r500',hres_mapname);
           fprintf('Saved as %s.jpg\n',hres_mapname)
        print('-djpeg',mapname)
        print('-dpdf',mapname)
           fprintf('Saved as %s.jpg and .pdf \n',mapname);
    end

    %% Allow the warning again
    warning('on','MATLAB:load:variableNotFound')
end
