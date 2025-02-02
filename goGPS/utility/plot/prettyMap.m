% prettyMap 2.0
%--------------------------------------------------------------------------
%
% plot with projection an area of the world
%
% POSSIBLE SINTAXES:
%   prettyMap(map);
%
%   prettyMap(map, shape);
%   prettyMap(map, projection);
%   prettyMap(map, lineCol);
%
%   prettyMap(map, phiGrid, lambdaGrid);
%   prettyMap(map, shape, projection);
%   prettyMap(map, shape, lineCol);
%   prettyMap(map, projection, shape);
%   prettyMap(map, projection, lineCol);
%
%   prettyMap(map, phiGrid, lambdaGrid, shape);
%   prettyMap(map, phiGrid, lambdaGrid, projection);
%   prettyMap(map, phiGrid, lambdaGrid, lineCol);
%
%   prettyMap(map, phiMin, phiMax, lambdaMin, lambdaMax)
%   prettyMap(map, phiMin, phiMax, shape, projection);
%   prettyMap(map, phiMin, phiMax, shape, lineCol);
%   prettyMap(map, phiMin, phiMax, projection, shape);
%   prettyMap(map, phiMin, phiMax, projection, lineCol);
%
%   prettyMap(map, phiMin, phiMax, lambdaMin, lambdaMax, shepe);
%   prettyMap(map, phiMin, phiMax, lambdaMin, lambdaMax, projection);
%   prettyMap(map, phiMin, phiMax, lambdaMin, lambdaMax, lineCol);
%
%   prettyMap(map, phiGrid, lambdaGrid, phiMin, phiMax, lambdaMin, lambdaMax)
%   prettyMap(map, phiMin, phiMax, lambdaMin, lambdaMax, shape, projection);
%   prettyMap(map, phiMin, phiMax, lambdaMin, lambdaMax, shape, lineCol);
%   prettyMap(map, phiMin, phiMax, lambdaMin, lambdaMax, projection, shape);
%   prettyMap(map, phiMin, phiMax, lambdaMin, lambdaMax, projection, lineCol);
%
%   prettyMap(map, phiGrid, lambdaGrid, phiMin, phiMax, lambdaMin, lambdaMax, shepe);
%   prettyMap(map, phiGrid, lambdaGrid, phiMin, phiMax, lambdaMin, lambdaMax, projection);
%   prettyMap(map, phiGrid, lambdaGrid, phiMin, phiMax, lambdaMin, lambdaMax, lineCol);
%
%   prettyMap(map, phiGrid, lambdaGrid, phiMin, phiMax, lambdaMin, lambdaMax, shape, projection);
%   prettyMap(map, phiGrid, lambdaGrid, phiMin, phiMax, lambdaMin, lambdaMax, shape, lineCol);
%   prettyMap(map, phiGrid, lambdaGrid, phiMin, phiMax, lambdaMin, lambdaMax, projection, shape);
%   prettyMap(map, phiGrid, lambdaGrid, phiMin, phiMax, lambdaMin, lambdaMax, projection, lineCol);
%
%   prettyMap(map, phiGrid, lambdaGrid, phiMin, phiMax, lambdaMin, lambdaMax, projection, shape, lineCol);
%   prettyMap(map, phiGrid, lambdaGrid, phiMin, phiMax, lambdaMin, lambdaMax, shape, projection, lineCol);
%
% EXAMPLE:
%   prettyMap(map, phiMin, phiMax, lambdaMin, lambdaMax, 'Miller Cylindrical');
%
% INPUT:
%   map             matrix containing data of the whole world to be shown
%   phiGrid         array [degree]
%   lambdaGrid      array [degree]
%   phiMin          minimum latitude    [degree]
%   phiMax          maximum latitude    [degree]
%   lambdaMin       minimum longitude   [degree]
%   lambdaMax       maximum longitude   [degree]
%   projection      type of projection to be used "standard" is the default
%   shape           shapefile to load as coast (or country) contour
%                       - fill          fill coasts coarse
%                       - coast         only coasts coarse
%                       - 50m           1:50000000 scale country contours
%                       - 30m           1:30000000 scale country contours
%                       - 10m           1:10000000 scale country contours
%   lineCol         [1 1 1] array of RGB component to draw the contour lines
%
% DEFAULT VALUES:
%    projection = 'Lambert'
%
% AVAILABLE PROJECTION:
%    * Lambert
%      Stereographic
%      Orthographic
%      Azimuthal Equal-area
%      Azimuthal Equidistant
%      Gnomonic
%      Satellite
%      Albers Equal-Area Conic
%      Lambert Conformal Conic
%      Mercator
%    * Miller Cylindrical
%    * Equidistant Cylindrical (world map)
%      Oblique Mercator
%      Transverse Mercator
%      Sinusoidal
%      Gall-Peters
%      Hammer-Aitoff
%      Mollweide
%      Robinson
%    * UTM
%
% SEE ALSO:
%   mapPlot, mapPlot3D, quiver
%
% REQUIREMENTS:
%   M_Map: http://www.eos.ubc.ca/~rich/map.html
%   shape files with contours
%
% VERSION: 2.1
%
% CREDITS:
%   http://www.eos.ubc.ca/~rich/map.html
%
%   Andrea Gatti
%   DIIAR - Politecnico di Milano
%   2013-12-19
%
function prettyMap(map, phiGrid, lambdaGrid, phiMin, phiMax, lambdaMin, lambdaMax, projection, shape, lineCol)

%shape = 'coast';
%shape = 'fill';
%shape = '10m';
%shape = '30m';
%shape = '50m';

% lineCol = [0 0 0];
limitsOk = false;

% Manage opening a new figure;
tohold = false;
if length(findall(0,'Type','figure'))>=1
    if ishold
        clf;
        tohold = true;
    else
        figure;
    end
end

switch (nargin)
    case 1                                                                % prettyMap(map);
        shape = 'coast';
        lineCol = [0 0 0];
        projection = 'Miller Cylindrical';
        phiMin = 90;
        phiMax = -90;
        lambdaMin = -180;
        lambdaMax = 180;
        
        deltaPhi = (phiMax-phiMin)/size(map,1);
        deltaLambda = (lambdaMax-lambdaMin)/size(map,2);
        
        phiGrid    = (phiMin + deltaPhi/2 : deltaPhi : phiMax - deltaPhi/2)';
        lambdaGrid = (lambdaMin + deltaLambda/2 :  deltaLambda :  lambdaMax  - deltaLambda/2)';
    case 2
        shape = 'coast';
        lineCol = [0 0 0];
        projection = 'Miller Cylindrical';
        if (ischar(phiGrid))
            if (sum(strcmp(phiGrid,[{'none'},{'coast'},{'fill'},{'10m'},{'30m'},{'50m'}]))) % prettyMap(map, shape);
                shape = phiGrid;
            else                                                          % prettyMap(map, projection);
                projection = phiGrid;
            end
        elseif (length(phiGrid) == 3)                                     % prettyMap(map, lineCol);
            lineCol = phiGrid;
        end
        
        phiMin = 90;
        phiMax = -90;
        lambdaMin = -180;
        lambdaMax = 180;
        
        deltaPhi = (phiMax-phiMin)/size(map,1);
        deltaLambda = (lambdaMax-lambdaMin)/size(map,2);
        
        phiGrid    = (phiMin + deltaPhi/2 : deltaPhi : phiMax - deltaPhi/2)';
        lambdaGrid = (lambdaMin + deltaLambda/2 :  deltaLambda :  lambdaMax  - deltaLambda/2)';
    case 3
        shape = 'coast';
        lineCol = [0 0 0];
        if (ischar(phiGrid))
            projection = 'Miller Cylindrical';
            if (sum(strcmp(phiGrid,[{'none'},{'coast'},{'fill'},{'10m'},{'30m'},{'50m'}])))
                shape = phiGrid;
                if (ischar(lambdaGrid))
                    projection = lambdaGrid;                              % prettyMap(map, shape, projection);
                else
                    lineCol = lambdaGrid;                                 % prettyMap(map, shape, lineCol);
                end
            else
                projection = phiGrid;
                if (ischar(lambdaGrid))
                    shape = lambdaGrid;                                   % prettyMap(map, projection, shape);
                else
                    lineCol = lambdaGrid;                                 % prettyMap(map, projection, lineCol);
                end
            end
            phiMin = 90;
            phiMax = -90;
            lambdaMin = -180;
            lambdaMax = 180;

            deltaPhi = (phiMax-phiMin)/size(map,1);
            deltaLambda = (lambdaMax-lambdaMin)/size(map,2);
            
            phiGrid    = (phiMin + deltaPhi/2 : deltaPhi : phiMax - deltaPhi/2)';
            lambdaGrid = (lambdaMin + deltaLambda/2 :  deltaLambda :  lambdaMax  - deltaLambda/2)';
        else                                                              % prettyMap(map, phiGrid, lambdaGrid);
            projection = 'Miller Cylindrical';
            phiMin = max(phiGrid);
            phiMax = min(phiGrid);
            lambdaMin = min(lambdaGrid);
            lambdaMax = max(lambdaGrid);
        end
    case 4
        shape = 'coast';
        lineCol = [0 0 0];
        projection = 'Miller Cylindrical';
        if (ischar(phiMin))
            if (sum(strcmp(phiMin,[{'none'},{'coast'},{'fill'},{'10m'},{'30m'},{'50m'}])))  % prettyMap(map, phiGrid, lambdaGrid, shape);
                shape = phiMin;
            else                                                          % prettyMap(map, phiGrid, lambdaGrid, projection);
                projection = phiMin;
            end
        elseif (length(phiMin) == 3)                                      % prettyMap(map, phiGrid, lambdaGrid, lineCol);
            lineCol = phiMin;
        end
        
        phiMin = max(phiGrid);
        phiMax = min(phiGrid);
        lambdaMin = min(lambdaGrid);
        lambdaMax = max(lambdaGrid);
    case 5
        shape = 'coast';
        lineCol = [0 0 0];
        projection = 'Miller Cylindrical';
        if (ischar(phiMin))
            if (sum(strcmp(phiMin,[{'none'},{'coast'},{'fill'},{'10m'},{'30m'},{'50m'}])))
                shape = phiMin;
                if (ischar(phiMax))
                    projection = phiMax;                                  % prettyMap(map, phiMin, phiMax, shape, projection);
                else
                    lineCol = phiMax;                                     % prettyMap(map, phiMin, phiMax, shape, lineCol);
                end
            else
                projection = phiMin;
                if (ischar(phiMax))
                    shape = phiMax;                                       % prettyMap(map, phiMin, phiMax, projection, shape);
                else
                    lineCol = phiMax;                                     % prettyMap(map, phiMin, phiMax, projection, lineCol);
                end
            end
            phiMin = max(phiGrid);
            phiMax = min(phiGrid);
            lambdaMin = min(lambdaGrid);
            lambdaMax = max(lambdaGrid);
        else                                                             %  prettyMap(map, phiMin, phiMax, lambdaMin, lambdaMax);
            limitsOk = true;
            lambdaMin = phiMin;
            lambdaMax = phiMax;
            phiMin = phiGrid;
            phiMax = lambdaGrid;
            
            if (phiMin < phiMax)
                tmp = phiMin;
                phiMin = phiMax;
                phiMax = tmp;
            end
                        
            deltaPhi = (phiMax-phiMin)/size(map,1);
            deltaLambda = (lambdaMax-lambdaMin)/size(map,2);
            
            phiGrid    = (phiMin + deltaPhi/2 : deltaPhi : phiMax - deltaPhi/2)';
            lambdaGrid = (lambdaMin + deltaLambda/2 :  deltaLambda :  lambdaMax  - deltaLambda/2)';
         end
    case 6
        shape = 'coast';
        lineCol = [0 0 0];
        limitsOk = true;
        projection = 'Lambert';
        if (ischar(lambdaMin))
            if (sum(strcmp(lambdaMin,[{'none'},{'coast'},{'fill'},{'10m'},{'30m'},{'50m'}])))
                shape = lambdaMin;                                        % prettyMap(map, phiMin, phiMax, lambdaMin, lambdaMax, shape);
            else
                projection = lambdaMin;                                   % prettyMap(map, phiMin, phiMax, lambdaMin, lambdaMax, projection);
            end
        elseif (length(lambdaMin) == 3)
            lineCol = lambdaMin;                                          % prettyMap(map, phiMin, phiMax, lambdaMin, lambdaMax, lineCol);
        end

        lambdaMax = phiMax;
        lambdaMin = phiMin;
        phiMin = phiGrid;
        phiMax = lambdaGrid;
        
        if (phiMin < phiMax)
            tmp = phiMin;
            phiMin = phiMax;
            phiMax = tmp;
        end
                
        deltaPhi = (phiMax-phiMin)/size(map,1);
        deltaLambda = (lambdaMax-lambdaMin)/size(map,2);
        
        phiGrid    = (phiMin + deltaPhi/2 : deltaPhi : phiMax - deltaPhi/2)';
        lambdaGrid = (lambdaMin + deltaLambda/2 :  deltaLambda :  lambdaMax  - deltaLambda/2)';
    case 7
        shape = 'coast';
        lineCol = [0 0 0];
        limitsOk = true;
        projection = 'Lambert';
        if (ischar(lambdaMin))
            if (sum(strcmp(lambdaMin,[{'none'},{'coast'},{'fill'},{'10m'},{'30m'},{'50m'}])))
                shape = lambdaMin;
                if (ischar(lambdaMax))
                    projection = lambdaMax;                               % prettyMap(map, phiMin, phiMax, lambdaMin, lambdaMax, shape, projection);
                else
                    lineCol = lambdaMax;                                  % prettyMap(map, phiMin, phiMax, lambdaMin, lambdaMax, shape, lineCol);
                end
            else
                projection = lambdaMin;
                if (ischar(lambdaMax))
                    shape = lambdaMax;                                    % prettyMap(map, phiMin, phiMax, lambdaMin, lambdaMax, projection, shape);
                else
                    lineCol = lambdaMax;                                  % prettyMap(map, phiMin, phiMax, lambdaMin, lambdaMax, projection, lineCol);
                end
            end
            
            lambdaMin = phiMin;
            lambdaMax = phiMax;
            phiMin = phiGrid;
            phiMax = lambdaGrid;
            
            if (phiMin < phiMax)
                tmp = phiMin;
                phiMin = phiMax;
                phiMax = tmp;
            end
                        
            deltaPhi = (phiMax-phiMin)/size(map,1);
            deltaLambda = (lambdaMax-lambdaMin)/size(map,2);
            
            phiGrid    = (phiMin + deltaPhi/2 : deltaPhi : phiMax - deltaPhi/2)';
            lambdaGrid = (lambdaMin + deltaLambda/2 :  deltaLambda :  lambdaMax  - deltaLambda/2)';
        else
            projection = 'lambert';                                       % prettyMap(map, phiGrid, lambdaGrid, phiMin, phiMax, lambdaMin, lambdaMax);
        end
    case 8
        shape = 'coast';
        lineCol = [0 0 0];
        limitsOk = true;
        if (ischar(projection))
            if (sum(strcmp(projection,[{'none'},{'coast'},{'fill'},{'10m'},{'30m'},{'50m'}])))
                shape = projection;                                       % prettyMap(map, phiGrid, lambdaGrid, phiMin, phiMax, lambdaMin, lambdaMax, shape);
                projection = 'Lambert';
            else
                                                                          % prettyMap(map, phiGrid, lambdaGrid, phiMin, phiMax, lambdaMin, lambdaMax, projection);
            end
        elseif (length(projection) == 3)
            lineCol = projection;                                         % prettyMap(map, phiGrid, lambdaGrid, phiMin, phiMax, lambdaMin, lambdaMax, lineCol);
            projection = 'Lambert';
        end
    case 9
        lineCol = [0 0 0];
        limitsOk = true;
        if (ischar(projection))
            if (sum(strcmp(projection,[{'none'},{'coast'},{'fill'},{'10m'},{'30m'},{'50m'}])))
                tmp = shape;
                shape = projection;
                if (ischar(tmp))
                    projection = tmp;                                     % prettyMap(map, phiGrid, lambdaGrid, phiMin, phiMax, lambdaMin, lambdaMax, shape, projection);
                else
                    lineCol = tmp;                                        % prettyMap(map, phiGrid, lambdaGrid, phiMin, phiMax, lambdaMin, lambdaMax, shape, lineCol);
                    projection = 'UTM';
                end
            else
                if (ischar(shape))
                                                                          % prettyMap(map, phiGrid, lambdaGrid, phiMin, phiMax, lambdaMin, lambdaMax, projection, shape);
                else
                    lineCol = shape;                                      % prettyMap(map, phiGrid, lambdaGrid, phiMin, phiMax, lambdaMin, lambdaMax, projection, lineCol);
                    shape = 'coast';
                end
            end
        end
    case 10                                                               % prettyMap(map, phiGrid, lambdaGrid, phiMin, phiMax, lambdaMin, lambdaMax, projection, shape, lineCol)
        limitsOk = true;
       if (sum(strcmp(projection,[{'none'},{'coast'},{'fill'},{'10m'},{'30m'},{'50m'}])))   % prettyMap(map, phiGrid, lambdaGrid, phiMin, phiMax, lambdaMin, lambdaMax, shape, projection, lineCol)
            tmp = shape;
            shape = projection;
            projection = tmp;
       end
end

if (phiMin < phiMax)
    tmp = phiMin;
    phiMin = phiMax;
    phiMax = tmp;
end

lambdaGrid = sort(lambdaGrid);

[val idMax] = max(diff(lambdaGrid));
if sum(diff(lambdaGrid) == val) == 1
    lambdaGrid(1:idMax) = lambdaGrid(1:idMax)+360;
    if ~limitsOk
        lambdaMax = lambdaGrid(idMax);
        lambdaMin = lambdaGrid(idMax+1);
    end
end
lambdaGrid = sort(lambdaGrid);

if(lambdaMax<lambdaMin)
    lambdaMax = lambdaMax+360;
end

% setup the projection
if (strcmpi(projection,[{'lambert'}]) && abs(phiMax==-phiMin))
    projection='Miller Cylindrical';
end

if (sum(strcmpi(projection,[{'lambert'},{'UTM'},{'Sinusoidal'},{'Transverse Mercator'},{'Mollweid'},{'Oblique Mercator'},{'Miller Cylindrical'}])))
    m_proj(projection,'long',[lambdaMin lambdaMax],'lat',[phiMax phiMin]);
else
    m_proj(projection);
end

% Printing projection
fprintf('Using projection: %s\n', projection);

if sum(diff(lambdaGrid)<-200)
    lambdaGrid(lambdaGrid<0)=lambdaGrid(lambdaGrid<0)+360;
end
% plot the map
m_pcolor(lambdaGrid,phiGrid, map);

% set the light
shading flat;

% read shapefile
if (~strcmp(shape,'none'))
	if (~strcmp(shape,'coast')) && (~strcmp(shape,'fill'))
    	if (strcmp(shape,'10m'))
        	M=m_shaperead('countries_10m');
	    elseif (strcmp(shape,'30m'))
    	    M=m_shaperead('countries_30m');
	    else
    	    M=m_shaperead('countries_50m');
	    end
    	[xMin,yMin] = m_ll2xy(lambdaMin,phiMin);
	    [xMax,yMax] = m_ll2xy(lambdaMax,phiMax);
    	for k=1:length(M.ncst)
        	lamC = M.ncst{k}(:,1);
	        ids = lamC < lambdaMin;
   	    	lamC(ids) = lamC(ids) + 360;
        	phiC = M.ncst{k}(:,2);
        	[x,y] = m_ll2xy(lamC,phiC);
        	if sum(~isnan(x))>1
            	x(find(abs(diff(x))>=abs(xMax-xMin)*0.90)+1) = nan; % Romove lines that occupy more than th 90% of the plot
	            line(x,y,'color', lineCol);
    	    end
        end
    else
        if (strcmp(shape,'coast'))
        	m_coast('line','color', lineCol);
        else
            m_coast('patch',lineCol);
        end
	end
end

m_grid('box','fancy','tickdir','in');
colorbar;

if tohold
    hold on;
end
