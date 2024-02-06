function nlon=reset_longit(lon,reset_type,debug_level)
  % function nlon=reset_longit(lon,reset_type,debug_level)
% Author AMM   4/26/06
% Purpose - to make sure that the longitudes are numerically contiguous
%   so that if we are in the Pacific and crossing the dateline, values 
% run from 0 to 360, but if we are in the Atlantic and crossing 0, the
% values run from -180 to 180; 
% Inputs - lon: a vetcor or matrix of longitudes
%          reset_type = 180 forces all values to be between -180 and 180
%                     = 360 forces all values to be between 0 and 360
%                     = anything else makes all longitudes contiguous - either
%                       between -180 and 180 or between 0 and 360, whatever
%                       works for the basin
%          debug_level: if > 1 will print out some explanation
% Ouputs - nlon: numerically contiguous longitudes

ZERO360=360;
MINUS180180=180;

if(nargin < 3 | isempty(debug_level))
  debug_level=0;
end

if(nargin < 2 | isempty(reset_type) | ...
   (reset_type~=ZERO360 & reset_type~=MINUS180180))
  reset_type = 0;
end

nlon=lon;

[nrows,ncols]=size(lon);
totlon=nrows*ncols;

% get all longitudes within a reasonable range
not_done=1;
biglon=find(nlon > 360);
while ~isempty(biglon)
  nlon(biglon)=nlon(biglon)-360;
  biglon=find(nlon > 360);
end


lon360=find(nlon >= 0);
lon180=find(nlon < 180);

eastlon=find(nlon > 180);
westlon=find(nlon < 0);



if(length(lon360)==totlon)
  if(debug_level > 1)
    disp('All longitudes run between 0 and 360.')
  end
  if(reset_type == MINUS180180)
    nlon(eastlon)=nlon(eastlon)-360;
    if(debug_level > 1)
      disp('Converting longitudes to run between -180 and 180.')
    end
  end
elseif(length(lon180)==totlon) 
  if(debug_level > 1)
    disp('All longitudes are between -180 and 180.')
  end
  if(reset_type == ZERO360)
    nlon(westlon)=nlon(westlon)+360;
    if(debug_level > 1)
      disp('Converting longitudes to run between 0 and 360.')
    end
  end
else
  if(debug_level > 1)
    disp('Some longitudes are less than 0 and others greater than 180.')
  end
  if(reset_type ~= ZERO360)
    nlon(eastlon)=nlon(eastlon)-360;
    if(debug_level > 1)
      disp('Converting longitudes to run between -180 and 180.')
    end
  else
    nlon(westlon)=nlon(westlon)+360;
    if(debug_level > 1)
      disp('Converting longitudes to run between 0 and 360.')
    end
  end



end
