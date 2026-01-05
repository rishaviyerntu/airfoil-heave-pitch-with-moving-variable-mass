clear all        % Clear all variables from the workspace
close all        % Close all open figure windows

% --- System Parameters ---
c = 2;           % Chord length (m)
a = 0.1;         % Distance from flexural axis (m)
k1 = 1000;       % Stiffness of plunge spring (N/m)
k2 = 1500;       % Stiffness of pitch spring (Nm/rad)
m = 100;         % Mass of the airfoil (kg)

% --- Range of moving mass position (p) ---
p1 = -c / 2;     % Leading edge position relative to origin
p2 = c / 2;      % Trailing edge position relative to origin

% --- Range of moving mass values (mp) ---
mp1 = 0;         % Minimum moving mass (kg)
mp2 = 20;        % Maximum moving mass (kg)

% --- Discretization of airfoil ---
N = 1000;        % Number of steps for parameter variation

i = 1;           % Row index for plotting data
for p = p1:(p2-p1)/N:p2     % Sweep moving mass position along chord
    j = 1;                   % Column index for plotting data
    for mp = (mp2-mp1)/N:mp2 % Sweep moving mass values from 0 to 20
        
        % --- Mass Matrix components ---
        M_11 = 100 + mp;                              
        M_12 = (mp * p) - (0.1 * mp) - 10;             
        M_21 = mp * p - (0.1 * mp) - 10;               
        M_22 = (103 / 3) + (0.1 * mp) - ...            
               (0.2 * mp * p) + (mp * p^2);
        M = [M_11 M_12; M_21 M_22];                   % Mass matrix

        % --- Stiffness Matrix ---
        K = [k1 0; 0 k2];                              

        % --- Solve generalized eigenvalue problem ---
        V = sqrt(eig(K,M));    % Natural frequencies (rad/s)

        % Store frequencies and parameter values
        V1(i,j) = V(1);        % Heave (plunge) frequency
        V2(i,j) = V(2);        % Pitch frequency
        pp_plot(i,j) = p;      % Store current position of moving mass
        mpmp_plot(i,j) = mp;   % Store current moving mass value

        j = j + 1;             % Increment column index
    end
    i = i + 1;                 % Increment row index
end

% --- Plot Results ---

% Heave frequency vs p vs mp
subplot(1,2,1)
mesh(pp_plot, mpmp_plot, V1/2/pi)   % Convert rad/s → Hz
xlabel('p (m)')
ylabel('Mass of moving mass (kg)')
zlabel('Frequency (Hz)')
title('Heave Frequency vs p vs Mass of moving mass mp')

% Pitch frequency vs p vs mp
subplot(1,2,2)
mesh(pp_plot, mpmp_plot, V2/2/pi)   % Convert rad/s → Hz
xlabel('p (m)')
ylabel('Mass of moving mass (kg)')
zlabel('Frequency (Hz)')
title('Pitch Frequency vs p vs Mass of moving mass mp')
