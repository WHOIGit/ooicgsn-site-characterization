% define_colors 
% defines 21 colors that can to be used for plotting as individual
% variables and as a list, COLS and as names CNAMES
% 
% Note - NAVY is not included in the lists because it is difficult to
% distinguish from BLUE.
%
% set PLOT_COLS=1 if you want to see a plot of the colors

SHADE_A=[1 1 1]*.8;
SHADE_B=[1 1 1]*.6;
SHADE_C=[1 1 1]*.4;

YELLOW=[1 1 .1];
MAGENTA=[1 0 1];
CYAN=[0 1 1];
SKY=[.2 .7 1];
RED=[1 0 0];
GREEN=[0 1 0];
BLUE=[0 0 1];
BLACK=[0 0 0];
PINK=[1 .4 .6];
SKIN=[1 .6 .5];
ORANGE=[1 .4 .2];
CAMO=[.5 .5 .1];
VIOLET=[.5 .5 1];
AQUA=[.1 .5 .5];
PLUM=[.5 .1 .5];
LIME=[.5 1 .5];
AVACADO=[.8 1 .4];
DULLBLUE=[.3 .4 .9];
GRASS=[.2 .7 .2];
GARNET=[.7 .2 .2];
NAVY=[.1 .1 .7];
SADDLEBROWN=[139 69 19]/255;
SIENNA=[160 82 45]/255;     % very close to garnet
BROWN=[165 42 42]/255;
MAROON=[128 0 0]/255;
DUSKYROSE=[255 153 204]/255;
DUSKYPURPLE=[204 153 255]/255;
DUSKYBLUE=[153 153 255]/255;
PURPLE=[153 51 255]/255;
TAN=[255 204 153]/255;

WHITE=[1 1 1];

COLS=[BLACK;MAGENTA;PINK;SKIN;ORANGE;GARNET;RED;PLUM;CAMO;AQUA;GREEN;...
    GRASS;AVACADO;LIME;CYAN;SKY;VIOLET;DULLBLUE;BLUE;...
    SADDLEBROWN;SIENNA;BROWN;MAROON;DUSKYROSE;DUSKYPURPLE;DUSKYBLUE;...
    PURPLE;TAN;YELLOW;WHITE];
CNAMES={'BLACK','MAGENTA','PINK','SKIN','ORANGE','GARNET','RED','PLUM',...
        'CAMO','AQUA','GREEN','GRASS','AVACADO','LIME','CYAN','SKY','VIOLET',...
        'DULLBLUE','BLUE','SADDLEBROWN','SIENNA','BROWN','MAROON',....
        'DUSKYROSE','DUSKYPURPLE','DUSKYBLUE','PURPLE','TAN','YELLOW','WHITE'};

if(exist('PLOT_COLS','var') && PLOT_COLS)
   figure
   for idx=1:size(COLS,1)
      %plot(1:10,[1:10]+idx,'linewidth',6,'color',COLS(idx,:));
      h=plot(1:10,(1:10)-idx,'^','markersize',6,'color',COLS(idx,:));
      set(h,'markerfacecolor',COLS(idx,:))
      hold on
   end
   legend(CNAMES,'location','bestoutside');
   hold off
end