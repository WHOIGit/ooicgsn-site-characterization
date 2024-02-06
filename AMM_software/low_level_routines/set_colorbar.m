function h=set_colorbar(colorbarlabel,locat,fontsize,cmap,cax,use_cbtitle)
% function h=set_colorbar(colorbarlabel,[locat],[fontsize],[cmap],[cax],[use_cbtitle])
% Author: AMM 12/31/13
% Purpose: place a colorbar with a label on the current plot
% Inputs: colorbarlabel - label to place on the colorbar
%         locat - string 'v' - vertical, 'h' - horizontal
%         fontsize - Optional label font size (default 10)
%         cmap - Optional color map (default - whatever is current)
%         cax - Optional color axis limits (default are the default)
%         use_cbtitle - logical - true = use a title instead of label
%               (default is false)
% History
% AMM 1/21/21 updated with cmap and cax, and allowed all other location options
%%

if(nargin < 1)
    help set_colorbar
    return
end

if(nargin < 2 || isempty(locat))
    locat='v';
end

switch lower(locat)
   case {'h' 'horizontal'}
        lstr='SouthOutside';
        whichlab='xlabel';
        isvert=false;
   case {'v' 'vertical'} 
        lstr='EastOutside';
        whichlab='ylabel';
        isvert=true;
   otherwise
        lstr=locat;
        if(contains(lower(locat),'east') || contains(lower(locat),'west'))
            whichlab='ylabel';
        else
            whichlab='xlabel';
        end
end
        
if(nargin < 3 || isempty(fontsize))
    fontsize=10;
end

if(nargin >= 4 && ~isempty(cmap))
    colormap(cmap)
end

if(nargin >= 5 && ~isempty(cax))
    caxis(cax);
end

if(nargin < 6 || isempty(use_cbtitle))
    use_cbtitle=false;
end

%%
h=colorbar;
set(h,'location',lstr)

if(use_cbtitle)   % Put a title on the colorbar rather than a label
    if(isvert)
        title(h,colorbarlabel,'fontsize',fontsize);
        hx=get(h,'Position');  % [left, bottom, width, height]
        hx(1)=hx(1)*1.11;   % move it right a bit to compensate
        hx(3)=hx(3)/2;      % make the colorbar narrower
        hx(4)=hx(4)*.85;    % make it shorter
        set(h,'Position',hx)
    else    % we only apply titles when the colorbar is vertical
        xlabel(h,colorbarlabel,'fontsize',fontsize);
    end
else
    hh=get(h,whichlab);
    set(hh,'string',colorbarlabel,'fontsize',fontsize)
end

