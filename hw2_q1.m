% The transfer function 
s = tf('s');

% The plant function
G = 1/(s*(s+10)*(s+20)); 
desiredOvershoot = 0.205; 
varK = 1000:0.1:1500;

% Initialize variables to store the best K and minimum error
bestK = 0;
minError = inf; 

for K = varK
    T = feedback(K*G, 1);
    S = stepinfo(T);
    currentError = abs((S.Overshoot/100) - desiredOvershoot);
    if currentError < minError
        minError = currentError;
        bestK = K; 
    end
end

disp(['Best K: ', num2str(bestK)]);
% Based on tuning this is (1215.1) the best true value of K but from the
% graph it is 1180 but I used the best K values for the dominant poles
% which is 1215.1

% Plot Root Locus
figure;
rlocus(G);
title('Root Locus of the Plant');
grid on;
% Plot the step response
figure;
step(T_best);
title(['Step Response with K = ', num2str(bestK)]);
grid on;
% Plot Pole-Zero Map
figure;
pzmap(bestK*G);
title('Pole-Zero Map');
grid on;
% Closed-loop transfer function with the best K
T_best = feedback(bestK*G, 1);
figure;
pzmap(T_best);
title('Pole-Zero Map of the Closed-Loop System');
grid on;
%%
% Comparative plot for different values of K
K_values = [bestK/2, bestK, 2*bestK]; 
colors = ['r', 'g', 'b']; 
figure;
hold on;
for i = 1:length(K_values)
    T_temp = feedback(K_values(i)*G, 1);
    step(T_temp, colors(i));
end
legend(arrayfun(@(k) ['K = ', num2str(k)], K_values, 'UniformOutput', false));
title('Comparative Step Response for Different K Values');
grid on;
hold off;
%%
s = tf('s');
G2 = (s + 4.87)/(s*(s+10)*(s+20)); 
desiredOvershoot = 20.5; 
varK2 = 0:0.1:1300;
bestK2 = 0;
minError = inf;  

for K2 = varK2
    T = feedback(K2*G2, 1);
    S = stepinfo(T);
    currentError = abs(S.Overshoot - desiredOvershoot);
    if currentError < minError
        minError = currentError;
        bestK2 = K2; 
    end
end

disp(['Best K2: ', num2str(bestK2)]);
% Based on tuning this is (1060.8) the best true value of K but from the
% graph it is 711 but I used the best K values for the dominant poles
% which is 1060.8
%%
% PD Controller
Kp = 1060.8; 
PD = Kp * (s + 4.87);
G_PD = PD * G;

% Uncompensated system
T_comp = feedback(Kp*G_PD, 1);

% Step Response
figure;
step(T_comp);
title('Step Response - Compensated');
title(['Step Response - Compensated', num2str(bestK2)]);
grid on;

% Root Locus
figure;
rlocus(G_PD);
title('Root Locus - Compensated');
grid on;

% Pole-Zero Map
figure;
pzmap(T_comp);
title('Pole-Zero Map - Compensated');
grid on;
%%
figure;
step(K*G/s); % Ramp response
title('Ramp Response');
title(['Ramp Response']);
grid on;

figure;
step(G_PD/s); % Ramp response
title('Ramp Response - Compensated');
title(['Ramp Response - Compensated']);
grid on;
%%
% Data preparation
plantData = {
    'K/s(s+10)(s+20)', '-3.11 + j6.03', 1215.1, 0.65, 1.273;
    'K(s+4.87)/s(s+10)(s+20)', '-12.57 + j23.42', 1060.8, 0.45, 0.32
};

% Create a figure for the table
f = figure;

% Define the column widths. Increase these values as needed.
columnWidths = {120, 80, 50, 50, 50};

% Create a table UI component
t = uitable(f, 'Data', plantData, ...
            'ColumnName', {'Plant', 'Poles', 'K', 'Ksi', 'T'}, ...
            'ColumnWidth', columnWidths, ...
            'Position', [20 50 500 150]); % Adjust the position and size as needed
