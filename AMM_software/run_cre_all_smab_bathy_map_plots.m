% script    run_cre_all_smab_bathy_map_plots
% A. Macdonald 8/21/22
% PURPOSE:
% Hardwired script to plot all the SMAB maps - note if it has been a
% while since this has been run, you ought to check that the id numbers have
% not changed by running
% region_numbers=define_plot_bathy_region_numbers;
% % Currently:
%                           SMAB: 5
%                      SMAB_MOOR: 6
%              SMAB_SHALLOW_WEST: 7
%         SMAB_ZOOM_SHALLOW_WEST: 8
%              SMAB_SHALLOW_EAST: 9
%                     SMAB_NORTH: 10
%                     SMAB_SOUTH: 11
%                   SMAB_CENTRAL: 12
%                 SMAB_OFFSHOREN: 13   % new 11/27/23 35.8514N   74.8482W
%                 SMAB_OFFSHORES: 14   % new 11/27/23 36.0536N   74.7776W
%
% Bathymetry choices (see run_plot_bathy.m) are:
SRTM15=1;
GEBCO=2;
CRM=3;
%%
CREATE_COMPARISON=false;
CREATE_MOORING_WITH_PEACH=true;
CREATE_ALL_MOORING_PLOTS=false;
CREATE_INDIV_MOORING_PLOTS=false;

INDIR=fullfile(filesep,'Users','alison','PROJECTS','Site_Characterization/','PEACH','ADCP',filesep);
PEACH_MOORINGS={'a1' 'a2' 'a3' 'b1'};
SYM='+x^vo><+x^vo><';
COL='kkkkkkkbbbbbbb';
%% Create comparison transects using the different bathymetry estimates
% fignum, bathy#, region#, wesn, plot_section, printit
% run_plot_bathy([1 2 2 1],SRTM15,sdx,[],true)
% run_plot_bathy([1 2 2 2],GEBCO,sdx,[],true)
% run_plot_bathy([1 2 2 3],CRM,sdx,[],true,true)

%% Create all comparison map using the different bathymetry estimates
% for sdx=[5 6 7:13]     % Remember legend must still be moved by hand
%                  % Line up the red dash with the bottom of bathy name
%    close(1)
%    run_plot_bathy([1 2 2 1],SRTM15,sdx,[],false)
%    run_plot_bathy([0 2 2 2],GEBCO,sdx,[],false)
%    run_plot_bathy([0 2 2 3],CRM,sdx,[],false,true)
% 
% end
%% Create just the comparison mooring box plot for Chapter 2

if(CREATE_COMPARISON)
%     close(1)
    % run_plot_bathy(fignum,bathytype,region_id,wesn,plot_transect,printit,...
    %                crop_lrbt,find_depth,radius_km)
    run_plot_bathy([1 2 2 1],SRTM15,6,[],false)
    run_plot_bathy([0 2 2 2],GEBCO,6,[],false)
    run_plot_bathy([0 2 2 3],CRM,6,[],false,true)
    subplot(2,2,1)
    title('a) SRTM15')
    subplot(2,2,2)
    title('b) GEBCO 2022')
    subplot(2,2,3)
    title('c) CRM 2022')
    print -dpdf SMAB_MOOR.pdf
    print -djpeg SMAB_MOOR.jpg
    print -djpeg -r500 SMAB_MOOR_hres500.jpg
end
%% Create just the MOORING BOX Map with the PEACH Mooring
if(CREATE_MOORING_WITH_PEACH)
   nmoorings=length(PEACH_MOORINGS);

   run_plot_bathy(1,CRM,6,[],false,true);
   title('Mooring Box')
     box=define_smab_boxes;
     for mdx=1:length(box.names)
        th=m_text(box.pos(mdx,2),box.pos(mdx,1)-.02,box.names{mdx});
        mkrs=box.(box.fields{mdx});mkr=mkrs(end);
        sym=box.marker{mkr};
        th.Color=sym(end);
        th.FontSize=14;
        th.FontWeight='Bold';
     end

      
     for mdx=1:nmoorings
        moorname=PEACH_MOORINGS{mdx};
        hourfile=fullfile(INDIR,['hourly-', moorname '.mat']);
        load(hourfile,'platform')

        m_plot(platform.lon,platform.lat,'Marker',SYM(mdx),'MarkerSize',14,...
               'Color',[0.6471    0.1647    0.1647],'LineWidth',2);
        th=m_text(platform.lon-.05,platform.lat,moorname);
        th.Color=[0.6471    0.1647    0.1647];
        th.FontSize=16;
        th.FontWeight='Bold';
    end
    print -djpeg -r500 PEACH_Mooring_Box
    print -dpdf PEACH_MOORING_Box
 end

%% Create all CRM maps
% fignum,bathytype,region_id,wesn,plot_transect,printit,crop_lrbt,find_depth,radius_km
if(CREATE_ALL_MOORING_PLOTS)  % 5 full field, 6 mooring box, 7:13 individual moorings
%     for sdx=[5 6 7:13]     % Remember legend must still be moved by hand
                         % Line up the red dash with the bottom of bathy name
    for sdx=[6 ]     % Remember legend must still be moved by hand
       run_plot_bathy(1,CRM,sdx,[],false,true);

    end
end

%% Create only the individual mooring CRM maps with rings
% fignum,bathytype,region_id,wesn,plot_transect,printit,crop_lrbt,find_depth,radius_km
if(CREATE_INDIV_MOORING_PLOTS)  % 5 full field, 6 mooring box, 7:13 individual moorings 
    for sdx=7:13    % 7:13     
       run_plot_bathy(1,CRM,sdx,[],false,true,[],[],1);
    end
end
