%==========================================================================
% Quartic Overhauser (QOVR) Surface Framework
% Supplementary Material for Shape and Surface Modeling Research
%==========================================================================

% Reading Excel file from Desktop
desktop_path = fullfile(getenv('USERPROFILE'), 'Desktop');
filename = fullfile(desktop_path, 'QOVR_S_Ctrl_Pts_v0_all_intl_param_knots_05.xlsx'); 
sheetnum = 1;

% Reading Numeric Data Matrix from a Specific Range: Surface Data (101x101 = 10201 Row)
sur_x = xlsread(filename, sheetnum, 'AB5: AB10205'); 	% x Coordinates 
sur_y = xlsread(filename, sheetnum, ' AC5: AC10205'); 	% y Coordinates
sur_z = xlsread(filename, sheetnum, 'AD5:AD10205');	% z Coordinates

% Control Points (5x5 = 25 Row)
points_x = xlsread(filename, sheetnum, 'E5:E29'); 
points_y = xlsread(filename, sheetnum, ' F5:F29'); 
points_z = xlsread(filename, sheetnum, ' G5:G29'); 

% ============================ Error Detection ============================
if isempty(sur_x) || isempty(points_x)
    error(' Surface data or control points could not be read from Excel! Please check the ranges.');
end

% Locking Data Dimensions to 101x101 (Square Matrix Transformation)
N = 101;
X = reshape(sur_x, N, N);
Y = reshape(sur_y, N, N);
Z = reshape(sur_z, N, N);

% ========================  3D Surface Visualization ========================
figure('Color', 'w'); 
surf(X, Y, Z); 
shading faceted;


% =====================  Customizing Colorbar Properties =====================
try
   colormap('jet');
catch
    colormap('turbo');
end

grid on;
ax = gca; 	% Get Current Axes

ax.GridAlpha = 0.75;


% =========================== Plots control points =========================== 
hold on; 	% Enabling “hold” to overlay content on the current surface

% Reads the 25x3 matrix containing the control points
scatter3(points_x, points_y, points_z, 50, 'blue', 'filled', 'MarkerEdgeColor', 'w', 'LineWidth', 1);
% Labeling Points (5x5 Grid Layout with Pi,j Indices. A small offset has been added to the Z coordinate)
k = 1; 
for i = 0:4      
    for j = 0:4           
          label_text = [' P ' num2str(i) ',' num2str(j)];        
          text(points_x(k), points_y(k), points_z(k) + 0.005, label_text, ...
          'Color', 'black', 'FontSize', 8, 'FontWeight', 'bold');            
           k = k + 1; 
    end
end

hold off; 

% ========================== Grid ==========================
ax.GridColor = [0.7 0.7 0.7]; 
ax.GridLineStyle = '-';
ax.SortMethod = 'childorder'; 	% Ensures the control points remain visible on top of the surface layout.






% ===================== Adjusting the 3D Viewing Angle =====================
set(gca, 'XDir', 'normal');
view(0, 90);		% Try for heatmap view
%view(36, 64);

axis tight; 

% ========================== Labels ==========================
t = title('QOVR Surface and Control Points', 'FontSize', 11, 'FontWeight', 'bold');
current_pos = t.Position; 
t.Position = [current_pos(1), current_pos(2), current_pos(3) * 1.02];

xlabel(' X-Axis', 'FontSize', 10);
ylabel(' Y-Axis ', 'FontSize', 10);
zlabel(' Z-Axis ', 'FontSize', 10);

cb = colorbar;
ylabel(cb, ' Z-Axis Value', 'FontSize', 10, 'FontWeight', 'bold');

% ============================= Save Figure =============================
fig = gcf; 
set(fig, 'WindowState', 'maximized');  
pause(0.5);     % Wait for 0.5s to let the window maximize and stabilize figure dimensions

path = fullfile(getenv('USERPROFILE'), 'Desktop');  % Set destination path to Desktop

% Save as SVG vector format
saveas(fig, fullfile(path, 'QOVR_Surface_Analysis_Vector_v0_all_intl_param_knots_05_HEAT'), 'svg');

% Save as 300 DPI fullscreen PNG graphics
print(fig, fullfile(path, 'QOVR_Surface_Analysis_300DPI_v0_all_intl_param_knots_05_HEAT'), '-dpng', '-r300', '-loose');

disp('Graphics successfully exported to Desktop!');
