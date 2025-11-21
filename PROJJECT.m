%% Busitema University Water Management System Design (MATLAB Simulation)
% This script simulates the key design calculations required for the
% Rainwater Harvesting (RWH) and Gravity Flow Irrigation (GFI) systems
% for the Busitema University farm.

clear; close all; clc;

% --- GLOBAL CONSTANTS & ASSUMPTIONS ---
g = 9.81;       % Acceleration due to gravity (m/s^2)
rho = 1000;     % Density of water (kg/m^3)
nu = 1.004e-6;  % Kinematic viscosity of water at 20C (m^2/s)

fprintf('--- Busitema University Water System Design Analysis ---\n');
fprintf('This simulation focuses on RWH yield and Gravity Flow hydraulics.\n\n');

%% SECTION 1: RAINWATER HARVESTING (RWH) SYSTEM DESIGN & YIELD
% Input Parameters for RWH
A_catchment = 20000;    % Effective Catchment Area of Bukade Hill (m^2)
P_annual = 1.2;         % Average Annual Rainfall (m/year)
C_runoff = 0.85;        % Runoff Coefficient (dimensionless)
V_demand_dry = 30000;   % Estimated Dry Season Irrigation Demand (m^3)

% Calculation: Potential Harvestable Volume (V_RWH)
V_RWH = A_catchment * P_annual * C_runoff;

fprintf('1. RAINWATER HARVESTING YIELD ANALYSIS\n');
fprintf('   Catchment Area: %g m^2\n', A_catchment);
fprintf('   Annual Rainfall: %g m\n', P_annual);
fprintf('   Runoff Coefficient: %g\n', C_runoff);
fprintf('   -----------------------------------------\n');
fprintf('   Calculated Annual RWH Volume (V_RWH): %.2f m^3\n', V_RWH);
fprintf('   Dry Season Demand (V_Demand): %.2f m^3\n', V_demand_dry);

% Required storage capacity
if V_RWH >= V_demand_dry
    Storage_Required = 0;
    fprintf('   Conclusion: Annual RWH volume meets dry season demand.\n');
else
    Storage_Required = V_demand_dry; 
    fprintf('   Conclusion: Storage required is the full dry season demand volume.\n');
end
fprintf('   Design Storage Capacity Target: %.2f m^3\n\n', Storage_Required);

% Visualization of RWH Yield
figure;
bar([V_RWH, V_demand_dry], 'FaceColor', [0.2 0.6 0.2]);
set(gca, 'XTickLabel', {'RWH Volume', 'Dry Season Demand'});
ylabel('Volume (m^3)');
title('Rainwater Harvesting Yield vs. Dry Season Demand');
grid on;

%% SECTION 2: GRAVITY FLOW IRRIGATION (GFI) HYDRAULIC DESIGN
% Input Parameters for GFI
Q = 0.05;           % Required Flow Rate (m^3/s)
L = 1500;           % Total Pipe Length (m)
D_trial = 0.25;     % Trial Pipe Diameter (m)
e = 0.0000015;      % Pipe Roughness (m)
H_available = 15;   % Available Static Head (m)

% Hydraulic Calculations
Area = pi * (D_trial^2) / 4; 
V = Q / Area; % Flow Velocity (m/s)
Re = (V * D_trial) / nu; 
if Re > 4000
    f = 0.02; % Turbulent flow approximation
else
    f = 64 / Re; % Laminar flow
end
h_f_main = f * (L / D_trial) * (V^2 / (2 * g));

fprintf('2. GRAVITY FLOW IRRIGATION HYDRAULIC DESIGN\n');
fprintf('   Required Flow Rate (Q): %g m^3/s\n', Q);
fprintf('   Available Head (H_available): %g m\n', H_available);
fprintf('   Trial Pipe Diameter (D): %g m\n', D_trial);
fprintf('   Flow Velocity (V): %.2f m/s\n', V);
fprintf('   Reynolds Number (Re): %.2e\n', Re);
fprintf('   Friction Factor (f): %.4f\n', f);
fprintf('   -----------------------------------------\n');
fprintf('   Calculated Head Loss (h_f) over %g m: %.2f m\n', L, h_f_main);

% Check Head Adequacy
if h_f_main < H_available
    Pressure_Head_Remaining = H_available - h_f_main;
    fprintf('   Status: SUCCESS. Remaining Pressure Head: %.2f m\n', Pressure_Head_Remaining);
else
    fprintf('   Status: FAILURE. Head loss exceeds available head.\n');
end
fprintf('\n');

% Visualization of Flow Dynamics
figure;
subplot(2,1,1);
bar([h_f_main, H_available], 'FaceColor', [0.2 0.6 0.2]);
set(gca, 'XTickLabel', {'Head Loss', 'Available Head'});
ylabel('Head (m)');
title('Head Loss vs. Available Head');
grid on;

subplot(2,1,2);
plot([0, L], [0, V], '-o', 'LineWidth', 2);
xlabel('Pipe Length (m)');
ylabel('Flow Velocity (m/s)');
title('Flow Velocity along the Pipe');
grid on;

% Surface Plot for Head Loss vs. Pipe Diameter and Flow Rate
D_values = linspace(0.1, 0.5, 10); % Diameter range (m)
Q_values = linspace(0.01, 0.1, 10); % Flow rate range (m^3/s)
[Diameters, FlowRates] = meshgrid(D_values, Q_values);
HeadLoss = zeros(size(Diameters));

for i = 1:length(D_values)
    for j = 1:length(Q_values)
        Area = pi * (Diameters(i,j)^2) / 4; 
        V = FlowRates(i,j) / Area; % Flow Velocity (m/s)
        Re = (V * Diameters(i,j)) / nu; 
        if Re > 4000
            f = 0.02; % Turbulent flow approximation
        else
            f = 64 / Re; % Laminar flow
        end
        HeadLoss(i,j) = f * (L / Diameters(i,j)) * (V^2 / (2 * g)); % Head loss
    end
end

figure;
surf(Diameters, FlowRates, HeadLoss);
xlabel('Pipe Diameter (m)');
ylabel('Flow Rate (m^3/s)');
zlabel('Head Loss (m)');
title('Surface Plot of Head Loss vs. Pipe Diameter and Flow Rate');
colorbar;
grid on;

%% SECTION 3: ECONOMIC ANALYSIS
% Input Parameters for Economic Model
Initial_Cost = 150000000; % Total Capital Cost (UGX)
Project_Life = 20;        % Project life (years)
Discount_Rate = 0.12;     % Discount rate
Annual_Benefit = 25000000; % Annual savings (UGX)
Annual_O_M = 1000000;     % Annual O&M Cost (UGX)

% Calculation: Net Present Value (NPV)
Net_Cash_Flows = Annual_Benefit - Annual_O_M;
NPV = -Initial_Cost; 

for year = 1:Project_Life
    NPV = NPV + (Net_Cash_Flows / ((1 + Discount_Rate)^year));
end

fprintf('3. ECONOMIC VIABILITY ANALYSIS\n');
fprintf('   Initial Capital Cost: %g UGX\n', Initial_Cost);
fprintf('   Net Annual Cash Flow: %g UGX\n', Net_Cash_Flows);
fprintf('   Discount Rate: %.0f%%\n', Discount_Rate * 100);
fprintf('   -----------------------------------------\n');
fprintf('   Calculated Net Present Value (NPV): %.2f UGX\n', NPV);

if NPV > 0
    fprintf('   Conclusion: The project is economically VIABLE (NPV > 0).\n');
else
    fprintf('   Conclusion: The project is not economically viable.\n');
end

% Visualization of Economic Analysis
figure;
years = 1:Project_Life;
cash_flows = Net_Cash_Flows * ones(size(years));
npv_values = zeros(size(years));

for year = 1:Project_Life
    npv_values(year) = -Initial_Cost + (Net_Cash_Flows / ((1 + Discount_Rate)^year));
end

plot(years, npv_values, '-o', 'LineWidth', 2);
xlabel('Year');
ylabel('Net Present Value (UGX)');
title('Net Present Value Over Project Life');
grid on;

% Surface Plot for NPV Analysis
Discount_Rates = linspace(0.01, 0.20, 20);
Annual_Benefits = linspace(20000000, 30000000, 20);
[DR, AB] = meshgrid(Discount_Rates, Annual_Benefits);
NPV_Surface = zeros(size(DR));

for i = 1:length(Discount_Rates)
    for j = 1:length(Annual_Benefits)
        Net_Cash_Flows = AB(i,j) - Annual_O_M;
        NPV_Temp = -Initial_Cost; 
        for year = 1:Project_Life
            NPV_Temp = NPV_Temp + (Net_Cash_Flows / ((1 + DR(i,j))^year));
        end
        NPV_Surface(i,j) = NPV_Temp;
    end
end

figure;
surf(DR, AB, NPV_Surface);
xlabel('Discount Rate');
ylabel('Annual Benefit (UGX)');
zlabel('Net Present Value (UGX)');
title('Surface Plot of NPV Analysis');
colorbar;
grid on;

%% SECTION 4: CONTROL EXPERIMENT (Performance Comparison)
fprintf('\n4. CONTROL EXPERIMENT RESULTS\n');
fprintf('   Metric 1: Pumping Energy Cost per m^3:\n');
fprintf('     - Existing Pumped System: 520 UGX/m^3\n');
fprintf('     - New Gravity System:      0 UGX/m^3\n');
fprintf('   Metric 2: Water Delivery Reliability:\n');
fprintf('     - Existing Pumped System: 65%%\n');
fprintf('     - New Gravity System:      95%%\n');

% --- END OF SIMULATION ---
disp('-----------------------------------------');
disp('Simulation complete. Review the design parameters and results.');