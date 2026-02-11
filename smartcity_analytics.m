%% SMART CITY ENVIRONMENTAL DATA ANALYTICS SYSTEM
% Scenario 1 – Temperature & Humidity Analysis
% Final Year IT Workshop (MATLAB)

clc;
clear;
close all;

%% -------------------------------
% 1. PARAMETERS & DATA GENERATION
% --------------------------------

numSensors = 3;     % Number of sensors deployed in city
hours = 24;         % 24 hours per day
days = 7;           % 7 days monitoring

% Time vector
time = 1:hours;

% Base temperature pattern (daily sinusoidal variation)
baseTemp = 30 + 8*sin((time)*(pi/12));

% Initialize 3D matrices
temperature = zeros(numSensors, hours, days);
humidity = zeros(numSensors, hours, days);

% Generate realistic sensor data with noise
for s = 1:numSensors
    for d = 1:days
        temperature(s,:,d) = baseTemp + randn(1,hours)*1.5;
        humidity(s,:,d) = 65 - 0.5*temperature(s,:,d) + randn(1,hours)*2;
    end
end

disp('Data generation completed...');

%% -------------------------------
% 2. STATISTICAL ANALYSIS
% --------------------------------

% Flatten data for overall statistics
tempAll = temperature(:);
humidityAll = humidity(:);

meanTemp = mean(tempAll);
stdTemp = std(tempAll);
maxTemp = max(tempAll);
minTemp = min(tempAll);

meanHumidity = mean(humidityAll);
stdHumidity = std(humidityAll);
maxHumidity = max(humidityAll);
minHumidity = min(humidityAll);

fprintf('\n--- Temperature Statistics ---\n');
fprintf('Mean Temperature: %.2f °C\n', meanTemp);
fprintf('Std Dev Temperature: %.2f\n', stdTemp);
fprintf('Max Temperature: %.2f °C\n', maxTemp);
fprintf('Min Temperature: %.2f °C\n', minTemp);

fprintf('\n--- Humidity Statistics ---\n');
fprintf('Mean Humidity: %.2f %%\n', meanHumidity);
fprintf('Std Dev Humidity: %.2f\n', stdHumidity);
fprintf('Max Humidity: %.2f %%\n', maxHumidity);
fprintf('Min Humidity: %.2f %%\n', minHumidity);

%% -------------------------------
% 3. MOVING AVERAGE SMOOTHING
% --------------------------------

% Example: Sensor 1, Day 1
sampleTemp = squeeze(temperature(1,:,1));
windowSize = 3;

smoothedTemp = movmean(sampleTemp, windowSize);

%% -------------------------------
% 4. CORRELATION ANALYSIS
% --------------------------------

corrMatrix = corrcoef(tempAll, humidityAll);
correlationValue = corrMatrix(1,2);

fprintf('\nCorrelation between Temperature and Humidity: %.3f\n', correlationValue);

%% -------------------------------
% 5. ANOMALY DETECTION (Z-SCORE METHOD)
% --------------------------------

zScoreTemp = (tempAll - meanTemp) / stdTemp;

% Threshold ±2 standard deviations
anomalyIndices = find(abs(zScoreTemp) > 2);

fprintf('\nNumber of Temperature Anomalies Detected: %d\n', length(anomalyIndices));

%% -------------------------------
% 6. VISUALIZATION SECTION
% --------------------------------

figure('Name','Smart City Environmental Analysis','NumberTitle','off');

% Raw vs Smoothed Temperature
subplot(2,2,1);
plot(sampleTemp,'r','LineWidth',2);
hold on;
plot(smoothedTemp,'b','LineWidth',2);
title('Raw vs Smoothed Temperature (Sensor 1 Day 1)');
xlabel('Hour');
ylabel('Temperature (°C)');
legend('Raw','Smoothed');
grid on;

% Temperature vs Humidity Scatter
subplot(2,2,2);
scatter(tempAll, humidityAll, 20, 'filled');
title('Temperature vs Humidity Correlation');
xlabel('Temperature (°C)');
ylabel('Humidity (%)');
grid on;

% Temperature Distribution
subplot(2,2,3);
histogram(tempAll,15);
title('Temperature Distribution');
xlabel('Temperature (°C)');
ylabel('Frequency');
grid on;

% Weekly Average Temperature Per Sensor
subplot(2,2,4);
weeklyAvg = squeeze(mean(mean(temperature,2),3));
bar(weeklyAvg);
title('Weekly Average Temperature per Sensor');
xlabel('Sensor Number');
ylabel('Average Temperature (°C)');
grid on;

%% -------------------------------
% 7. HEATMAP VISUALIZATION (ADVANCED)
% --------------------------------

figure;
avgPerHour = squeeze(mean(temperature,3));
imagesc(avgPerHour);
colorbar;
title('Heatmap: Average Hourly Temperature (All Sensors)');
xlabel('Hour');
ylabel('Sensor');
colormap jet;

%% -------------------------------
% 8. CONCLUSION MESSAGE
% --------------------------------

disp('Analysis Completed Successfully.');
disp('System performed statistical modeling, smoothing,');
disp('correlation analysis, anomaly detection, and visualization.');
