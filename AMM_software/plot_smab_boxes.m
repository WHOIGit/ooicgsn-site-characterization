function plot_smab_boxes(boxstruct,plot_glider_box,plot_mooring_box,plot_mooring_pos,ismmap,isimg,wesn,radius_km)
% function plot_smab_boxes(boxstruct,plot_glider_box,plot_mooring_box,plot_mooring_pos,isimg,wesn,radius_km)
% PURPOSE: to plot the glider & mooring boxstructers and mooring locations defined
%         in boxstruct on the current figure
% AUTHOR: A. Macdonald
% DATE 12/19/2021
% INPUTS: boxstruct - structure defining the boxstructes
%         plot_glider_box  - logical true/false plot glider boxstruct (green), Optional default is true        
%         plot_mooring_box - logical true/false plot mooring boxstruct (red), Optional default is true
%         plot_mooring_pos - logical true/false plot mooring locations, Optional default is true
%         ismmap - logical false=rectangular coords, true=m_map projection, Optional default is false
%         isimg -  logical true figure is an image file and boxstruct contains image coordinates
%                   - Optional,default is to not use,  and isimg is set to false         
%         wesn - range of the map [west east north south] so it only
%                attempts to  plot symbols within these bounds
%         radius_km - only used for the individual mooring maps, plot a circle 
%                with radius = radius_km around the mooring position
%                (Optional only used if provided, if empty, 0 or negative
%                it is not used.)
%                  
%     plotting an individual mooring might be plot_mooring_pos and ismap=true
%     -> plot_smab_boxes(d.BOX,false,false,true,true,false,wesn)
% OUPUTS: none
%%   Check input arguments
if(nargin < 1 || isempty(boxstruct))
    help plot_smab_boxstruct
end

if(nargin < 2 || isempty(plot_glider_box))
    plot_glider_box=true;
end

if(nargin < 3 || isempty(plot_mooring_box))
    plot_mooring_box=true;
end

if(nargin < 4 || isempty(plot_mooring_pos))
    plot_mooring_pos=true;
end

if(nargin < 5 || isempty(ismmap))
    ismmap=true;   % assume we have a map
end

if(nargin < 6 || isempty(isimg))
    isimg=false;
end


if(nargin < 7 || isempty(wesn))
    have_wesn=false;
else
    have_wesn=true;
end

if(nargin < 8 || isempty(radius_km) || radius_km <=0)
    incl_circle=false;
else
    incl_circle=true;
end

if(isimg && (~isfield(boxstruct,'image_coords') || ~boxstruct.image_coords))
    error(['Please supply a box structure in image coordinates - ', ...
           'use get_smab_image_overlay_coords.m to create'])
end

DEFAULT_SYMSIZE=16;
%%   Plot the desired boxes and locations
if(plot_glider_box)
    if(ismmap)
        m_plot(boxstruct.glider([3 3 4 4 3]),boxstruct.glider([1 2 2 1 1]),'g-','LineWidth', 2)
    else
        plot(boxstruct.glider([3 3 4 4 3]),boxstruct.glider([1 2 2 1 1]),'g-','LineWidth', 2)
    end
    symsize=DEFAULT_SYMSIZE-4;  % For full map which requires smaller symbols
else
    symsize=DEFAULT_SYMSIZE;   
end

if(plot_mooring_box)
    if(ismmap)
        m_plot(boxstruct.moor([3 3 4 4 3]),boxstruct.moor([1 2 2 1 1]),'r-','LineWidth', 2)
    else
        plot(boxstruct.moor([3 3 4 4 3]),boxstruct.moor([1 2 2 1 1]),'r-','LineWidth', 2)
    end
end

fprintf('Default symsize: %d\n',symsize)
if(plot_mooring_pos)
    npos=length(boxstruct.pos);
    if(have_wesn)   % see which positions are in the plot
        inplot=boxstruct.pos(:,2) >= wesn(1) & boxstruct.pos(:,2) <= wesn(2) ...
            & boxstruct.pos(:,1) >= wesn(3) & boxstruct.pos(:,1) <= wesn(4);
    else
        inplot=true(npos,1);
    end
    % Symbols are the default size unless they are a second symbol
    % overlaying a first or the atr a triangle, in which case they are
    % smaller
    if(ismmap)
        for pdx=1:npos
            if(inplot(pdx))
                cfield=boxstruct.(boxstruct.fields{pdx});
                p=cfield(1);
                pnums=cfield(2:end);
                if(length(pnums) > 1)
                   m_plot(boxstruct.pos(p,2),boxstruct.pos(p,1),boxstruct.marker{pnums(1)},...
                     'MarkerSize',symsize,'MarkerFaceColor',boxstruct.marker{pnums(1)}(2),...
                     'MarkerEdgeColor','w','Linewidth',1.5)
                   m_plot(boxstruct.pos(p,2),boxstruct.pos(p,1),boxstruct.marker{pnums(2)},...
                      'MarkerSize',symsize-3,'MarkerFaceColor',boxstruct.marker{pnums(2)}(2),...
                      'MarkerEdgeColor','w','Linewidth',1.5)                     
                    fprintf('%3d %3s symsize: %d  %d\n',pdx,boxstruct.marker{pnums(1)},symsize,symsize-3)
                else
                   if(contains(boxstruct.marker{pnums(1)},'^'))
                       m_plot(boxstruct.pos(p,2),boxstruct.pos(p,1),boxstruct.marker{pnums(1)},...
                          'MarkerSize',symsize-3,'MarkerFaceColor',boxstruct.marker{pnums(1)}(2),...
                          'MarkerEdgeColor','w','Linewidth',1.5)
                      fprintf('%3d %3s symsize: %d\n',pdx,boxstruct.marker{pnums(1)},symsize-3) 
                   else
                       m_plot(boxstruct.pos(p,2),boxstruct.pos(p,1),boxstruct.marker{pnums(1)},...
                          'MarkerSize',symsize,'MarkerFaceColor',boxstruct.marker{pnums(1)}(2),...
                          'MarkerEdgeColor','w','Linewidth',1.5)
                      fprintf('%3d %3s symsize: %d\n',pdx,boxstruct.marker{pnums(1)},symsize)
                   end
                end
                if(incl_circle)
                    m_range_ring(boxstruct.pos(p,2),boxstruct.pos(p,1),radius_km,'color','r','linewidth',2);
                end
            end
        end
    else
        for pdx=1:npos
            if(inplot(pdx))
                cfield=boxstruct.(boxstruct.fields{pdx});
                p=cfield(1);
                pnums=cfield(2:end);
                plot(boxstruct.pos(p,2),boxstruct.pos(p,1),boxstruct.marker{pnums(1)},'MarkerSize',16,...
                  'MarkerFaceColor',boxstruct.marker{pnums(1)}(2),'MarkerEdgeColor','w',...
                  'Linewidth',1.5)
                if(length(pnums) > 1)
                    plot(boxstruct.pos(p,2),boxstruct.pos(p,1),boxstruct.marker{pnums(2)},'MarkerSize',13,...
                      'MarkerFaceColor',boxstruct.marker{pnums(2)}(2),'MarkerEdgeColor','w',...
                      'Linewidth',1.5)
                end
            end
        end
    end
end
