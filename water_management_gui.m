function water_management_gui()
% BUSITEMA UNIVERSITY WATER MANAGEMENT SYSTEM - SIMPLE GUI
% This script creates a simple GUI to run the water management simulation.

    % --- 1. GUI FIGURE SETUP ---
    fig = figure('Name', 'Busitema Water Management System', ...
                 'NumberTitle', 'off', ...
                 'Position', [100, 100, 800, 700], ...
                 'MenuBar', 'none', ...
                 'ToolBar', 'none');

    % --- 2. GLOBAL CONSTANTS ---
    g = 9.81;       % Acceleration due to gravity (m/s^2)
    rho = 1000;     % Density of water (kg/m^3)
    nu = 1.004e-6;  % Kinematic viscosity of water at 20C (m^2/s)
    
    % --- 3. UI CONTROLS (INPUT PANELS) ---

    % Panel 1: RWH Parameters
    uipanel('Title', ' RWH Parameters', 'Position', [0.02, 0.70, 0.30, 0.28]);
    
    uicontrol('Style', 'text', 'String', 'Catchment Area (m^2):', 'Position', [10, 630, 130, 20], 'HorizontalAlignment', 'left');
    A_catchment_h = uicontrol('Style', 'edit', 'Position', [150, 630, 80, 20], 'String', '20000');
    
    uicontrol('Style', 'text', 'String', 'Annual Rainfall (m):', 'Position', [10, 600, 130, 20], 'HorizontalAlignment', 'left');
    P_annual_h = uicontrol('Style', 'edit', 'Position', [150, 600, 80, 20], 'String', '1.2');
    
    uicontrol('Style', 'text', 'String', 'Runoff Coeff (C_r):', 'Position', [10, 570, 130, 20], 'HorizontalAlignment', 'left');
    C_runoff_h = uicontrol('Style', 'edit', 'Position', [150, 570, 80, 20], 'String', '0.85');
    
    uicontrol('Style', 'text', 'String', 'Dry Season Demand (m^3):', 'Position', [10, 540, 130, 20], 'HorizontalAlignment', 'left');
    V_demand_dry_h = uicontrol('Style', 'edit', 'Position', [150, 540, 80, 20], 'String', '30000');
    
    % Panel 2: GFI Parameters
    uipanel('Title', ' GFI Hydraulic Parameters', 'Position', [0.34, 0.70, 0.30, 0.28]);
    
    uicontrol('Style', 'text', 'String', 'Flow Rate (Q, m^3/s):', 'Position', [270, 630, 130, 20], 'HorizontalAlignment', 'left');
    Q_h = uicontrol('Style', 'edit', 'Position', [410, 630, 80, 20], 'String', '0.05');
    
    uicontrol('Style', 'text', 'String', 'Pipe Length (L, m):', 'Position', [270, 600, 130, 20], 'HorizontalAlignment', 'left');
    L_h = uicontrol('Style', 'edit', 'Position', [410, 600, 80, 20], 'String', '1500');
    
    uicontrol('Style', 'text', 'String', 'Trial Diameter (D, m):', 'Position', [270, 570, 130, 20], 'HorizontalAlignment', 'left');
    D_trial_h = uicontrol('Style', 'edit', 'Position', [410, 570, 80, 20], 'String', '0.25');
    
    uicontrol('Style', 'text', 'String', 'Available Head (H, m):', 'Position', [270, 540, 130, 20], 'HorizontalAlignment', 'left');
    H_available_h = uicontrol('Style', 'edit', 'Position', [410, 540, 80, 20], 'String', '15');
    
    % Panel 3: Economic Parameters
    uipanel('Title', ' Economic Analysis', 'Position', [0.66, 0.70, 0.32, 0.28]);
    
    uicontrol('Style', 'text', 'String', 'Initial Cost (UGX):', 'Position', [530, 630, 130, 20], 'HorizontalAlignment', 'left');
    Initial_Cost_h = uicontrol('Style', 'edit', 'Position', [670, 630, 100, 20], 'String', '150000000');
    
    uicontrol('Style', 'text', 'String', 'Project Life (years):', 'Position', [530, 600, 130, 20], 'HorizontalAlignment', 'left');
    Project_Life_h = uicontrol('Style', 'edit', 'Position', [670, 600, 100, 20], 'String', '20');
    
    uicontrol('Style', 'text', 'String', 'Discount Rate (%):', 'Position', [530, 570, 130, 20], 'HorizontalAlignment', 'left');
    Discount_Rate_h = uicontrol('Style', 'edit', 'Position', [670, 570, 100, 20], 'String', '0.12');
    
    uicontrol('Style', 'text', 'String', 'Annual Benefit (UGX):', 'Position', [530, 540, 130, 20], 'HorizontalAlignment', 'left');
    Annual_Benefit_h = uicontrol('Style', 'edit', 'Position', [670, 540, 100, 20], 'String', '25000000');
    
    % --- 4. OUTPUT CONTROLS ---

    % Run Button
    uicontrol('Style', 'pushbutton', 'String', 'RUN SIMULATION', ...
              'Position', [340, 500, 120, 30], ...
              'BackgroundColor', [0.2 0.6 0.2], 'ForegroundColor', 'white', ...
              'FontSize', 10, 'FontWeight', 'bold', ...
              'Callback', @run_simulation_callback);
          
    % Results Text Area
    uicontrol('Style', 'text', 'String', 'Simulation Results Log:', 'Position', [10, 480, 150, 20], 'HorizontalAlignment', 'left');
    results_h = uicontrol('Style', 'edit', 'Position', [10, 320, 780, 160], ...
                          'Max', 2, 'Min', 0, 'HorizontalAlignment', 'left', ...
                          'Enable', 'inactive', 'String', 'Ready to run simulation...');

    % Axes for Plots
    rwh_axes = axes('Parent', fig, 'Position', [0.05, 0.10, 0.28, 0.18]); % RWH Plot
    gfi_axes = axes('Parent', fig, 'Position', [0.36, 0.10, 0.28, 0.18]); % GFI Plot
    npv_axes = axes('Parent', fig, 'Position', [0.68, 0.10, 0.28, 0.18]); % NPV Plot

    % --- 5. CALLBACK FUNCTION ---
    function run_simulation_callback(~, ~)
        
        % Read Inputs (Convert from string to number)
        try
            A_catchment = str2double(get(A_catchment_h, 'String'));
            P_annual = str2double(get(P_annual_h, 'String'));
            C_runoff = str2double(get(C_runoff_h, 'String'));
            V_demand_dry = str2double(get(V_demand_dry_h, 'String'));
            
            Q = str2double(get(Q_h, 'String'));
            L = str2double(get(L_h, 'String'));
            D_trial = str2double(get(D_trial_h, 'String'));
            H_available = str2double(get(H_available_h, 'String'));
            e = 0.0000015; % Hardcoded minor input
            
            Initial_Cost = str2double(get(Initial_Cost_h, 'String'));
            Project_Life = str2double(get(Project_Life_h, 'String'));
            Discount_Rate = str2double(get(Discount_Rate_h, 'String'));
            Annual_Benefit = str2double(get(Annual_Benefit_h, 'String'));
            Annual_O_M = 1000000; % Hardcoded minor input
        catch
            set(results_h, 'String', 'ERROR: Invalid input detected. Ensure all fields are numbers.');
            return;
        end
        
        % Initialize Results Log
        log = {'--- Simulation Results ---'};
        log{end+1} = sprintf('Inputs: A_catchment=%g, Q=%g, D=%g, H_avail=%g, Cost=%g', A_catchment, Q, D_trial, H_available, Initial_Cost);
        log{end+1} = '------------------------------------';
        
        
        %% SECTION 1: RAINWATER HARVESTING (RWH) SYSTEM DESIGN & YIELD
        V_RWH = A_catchment * P_annual * C_runoff;
        log{end+1} = '1. RAINWATER HARVESTING YIELD:';
        log{end+1} = sprintf('   RWH Volume: %.2f m^3 | Demand: %.2f m^3', V_RWH, V_demand_dry);
        
        if V_RWH >= V_demand_dry
            Storage_Required = 0;
            log{end+1} = '   Conclusion: RWH meets demand.';
        else
            Storage_Required = V_demand_dry; 
            log{end+1} = '   Conclusion: Storage required is full demand.';
        end
        log{end+1} = sprintf('   Design Storage Target: %.2f m^3', Storage_Required);
        
        % Plot RWH Yield
        cla(rwh_axes);
        bar(rwh_axes, [V_RWH, V_demand_dry], 'FaceColor', [0.2 0.6 0.2]);
        set(rwh_axes, 'XTickLabel', {'RWH Volume', 'Demand'});
        ylabel(rwh_axes, 'Volume (m^3)');
        title(rwh_axes, 'RWH Yield vs. Demand');
        grid(rwh_axes, 'on');
        
        
        %% SECTION 2: GRAVITY FLOW IRRIGATION (GFI) HYDRAULIC DESIGN
        Area = pi * (D_trial^2) / 4; 
        V = Q / Area;
        Re = (V * D_trial) / nu; 
        
        if Re > 4000
            f = 0.02; % Simple approximation
        else
            f = 64 / Re;
        end
        h_f_main = f * (L / D_trial) * (V^2 / (2 * g));
        
        log{end+1} = ' ';
        log{end+1} = '2. GRAVITY FLOW HYDRAULICS:';
        log{end+1} = sprintf('   Flow Velocity (V): %.2f m/s', V);
        log{end+1} = sprintf('   Head Loss (h_f): %.2f m', h_f_main);
        
        if h_f_main < H_available
            Pressure_Head_Remaining = H_available - h_f_main;
            log{end+1} = sprintf('   Status: SUCCESS. Remaining Head: %.2f m', Pressure_Head_Remaining);
        else
            log{end+1} = '   Status: FAILURE. Head loss exceeds available head.';
        end
        
        % Plot Head Adequacy
        cla(gfi_axes);
        bar(gfi_axes, [h_f_main, H_available], 'FaceColor', [0.8 0.4 0.1]);
        set(gfi_axes, 'XTickLabel', {'Head Loss', 'Available Head'});
        ylabel(gfi_axes, 'Head (m)');
        title(gfi_axes, 'Head Loss vs. Available Head');
        grid(gfi_axes, 'on');

        
        %% SECTION 3: ECONOMIC VIABILITY ANALYSIS
        Net_Cash_Flows = Annual_Benefit - Annual_O_M;
        NPV = -Initial_Cost; 
        years = 1:Project_Life;
        npv_values = zeros(size(years));
        cumulative_npv = -Initial_Cost;
        
        for year = 1:Project_Life
            discount_factor = 1 / ((1 + Discount_Rate)^year);
            NPV = NPV + (Net_Cash_Flows * discount_factor);
            cumulative_npv = cumulative_npv + (Net_Cash_Flows * discount_factor);
            npv_values(year) = cumulative_npv;
        end
        
        log{end+1} = ' ';
        log{end+1} = '3. ECONOMIC VIABILITY:';
        log{end+1} = sprintf('   Net Annual Cash Flow: %g UGX', Net_Cash_Flows);
        log{end+1} = sprintf('   Calculated NPV: %.2f UGX', NPV);
        
        if NPV > 0
            log{end+1} = '   Conclusion: Project is economically **VIABLE** (NPV > 0).';
        else
            log{end+1} = '   Conclusion: Project is not economically viable.';
        end
        
        % Plot Cumulative NPV
        cla(npv_axes);
        plot(npv_axes, years, npv_values, '-o', 'LineWidth', 2, 'Color', [0.1 0.5 0.8]);
        line(npv_axes, xlim(npv_axes), [0 0], 'Color', 'r', 'LineStyle', '--'); % Zero Line
        xlabel(npv_axes, 'Year');
        ylabel(npv_axes, 'Cumulative NPV (UGX)');
        title(npv_axes, 'Cumulative NPV Over Project Life');
        grid(npv_axes, 'on');
        
        % --- Display Results ---
        set(results_h, 'String', log);
    end
end