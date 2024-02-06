function h1=plot_sect_bathy(fignum,sbathy,symbols,curve_type)
%function plot_sect_bathy(fignum,sbathy,symbols,curve_type)

%% Set Hardwired variables and chack input arguments
FONTSIZE=14;
define_colors
COLORS(1,:)=GARNET;
COLORS(2,:)=VIOLET;
COLORS(3,:)=AQUA;
COLORS(4,:)=TAN;

if(nargin < 4 || isempty(curve_type))
    curve_type=0;
end

if(nargin < 3 || isempty(symbols))
    have_details=false;
else
    have_details=true;
end

if(nargin < 2 || isempty(sbathy))
    error('Please run retrieve_sect_bathy to create sbathy')
end

subnum=0;
if(isempty(fignum))
    fignum=1;
else
    if(length(fignum)>1)
        subnum=fignum(2:end);
        fignum=fignum(1);
    end
end


%%
switch curve_type
    case 0    % Then make the base plot
        figure(fignum);
        if(subnum(1) == 0 || subnum(3)==1)   % then we're starting clean
            clf;orient landscape
        end
        if(subnum(1) ~= 0)
            subplot(subnum(1),subnum(2),subnum(3:end))
        end
        

          [xax,xstr]=determine_xax(sbathy.lat(:),sbathy.lon(:)); 
          txax=[xax(:); xax(end); xax(1); xax(1)];
          bot=1.02*max(sbathy.bathy);
          topo=[sbathy.bathy(:); bot; bot; sbathy.bathy(1)];
          h1=patch(txax,topo,[1 1 1]*.7);axis ij
          ax=axis;
          ax(1)=xax(1);ax(2)=xax(end);ax(3)=0;ax(4)=max(sbathy.bathy(:));axis(ax)
          xlabel(lower(xstr))
          set(gca,'FontSize',FONTSIZE)

          if(have_details)
               hold on
               wesn=sbathy.wesn;
               pos=symbols.pos;   
               npos=size(pos,1);
               for pdx=1:npos
                 lo=pos(pdx,2);la=pos(pdx,1);      % Assumed to be lat,lon
                 if(lo >= wesn(1) && lo <= wesn(2) && la >= wesn(3) && la <= wesn(4))
                   cfield=symbols.fields{pdx};     % eg. "shalw"
                   syms=symbols.(cfield)(:,2:end);

                   switch xstr
                        case 'Longitude'
                            mx=lo;
                        case 'Latitude'
                            mx=la;
                        otherwise
                            mx=sw_dist([ax(3) la],[ax(1) lo],'km');
                    end            
                    my=sbathy.bathy(near(mx,xax(:)));
                    plot([mx mx],[0 my],'k-','LineWidth',2) % draw a line from top of bathy to surface

                    for sdx=1:length(syms)   % draw the symbols for this mooring
                        cmarker=symbols.marker{syms(sdx)};
                        switch syms(sdx)
                            case 1
                                yplace=5;    % put the shallow symbol just below the surface
                            case 2
                                yplace= 0;   % put the surface symbol at the surface
                            otherwise
                                yplace=5; % put the profiler symbol mid-depth
                        end
                        if(isfield(symbols,'markersize'))
                            msize=symbols.markersize(syms(sdx));
                            fprintf('Marker %s markersize %d\n',cmarker,msize)
                        else
                            msize=10;
                        end
                        plot(mx,yplace,cmarker,'MarkerSize',msize,'LineWidth',2,...
                            'MarkerEdgeColor','k','MarkerFaceColor',cmarker(2))
                    end

                    text(mx,-4,symbols.names{pdx},'Rotation',45,'FontSize',FONTSIZE)
                 end
             end
          end
          grid
    otherwise
         col=COLORS(abs(curve_type),:);
         if(curve_type > 0)
             linetype='-';
         else
             linetype='--';
         end
         xax=determine_xax(sbathy.lat(:),sbathy.lon(:)); 
         h1=plot(xax,sbathy.bathy,linetype,'Color',col,'LineWidth',1.5);
end
