function  AMM_Site_Characterization_Software
%   AMM_Site_Characterization_Software
%   The software toolboxes used by the site characterization software
%   include:
%   smab_mfiles/ collection of interdependent upper and lower level routines
%                in particular:
%                   >> run_cre_all_smab_bathy_map_plots  - to create maps
%                   >> run_cre_all_smab_bathy_sect_plots - to create transects
%                both of which call
%                   run_plot_bathy.m
%                which is dependent on
%                   define_smab_boxes.n                - defines regions and locations
%                   get_hardwired_plot_map_details.m   - very hardwired
%                   define_plot_bathy_region_numbers.m - used at run time to specify region of interest
%                and makes use of:
%                   addpath nctoolbox-1.1.3/    
%                   addpath ocean_data_tools-master/ocean_data_tools/
%                  >> setup_nctoolbox
%                for
%                   bathymetry_extract.m
%                   extract_ngdc_crm_3arcsec_bathy.m
%
% Other toolboxes which have been included in the path are: 
% jlab
% seawater_ver3_3.1
% teos10
% cmocean
% eos80_legacy_gamma_n
% sands_1min
% m_map (*B)
% *B indicates that it is know that it is needed for the bathymetry plotting

