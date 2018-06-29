
%%
% Author: Harkirat Gill
%
% Use: Classifies test data into approprimate labels. Achieved accuracy on
% unseen data = 80-86%

% Features tested: RMS, waveform length, AR coefficients
% Methods tested: moving window, static window, different window sizes
% Classifier: LDA (Linear Discriminant Analysis)
% LDA finds a projection plane that achieves the minimum variance within
% different classes and maximum mean between classes. Classes = labels

%% reset workspace
clc
clearvars
close all

%% inputs
% change the window size of features
window = 200;
% state whether a moving or static window is desired
moving_window = false;
% state whether plots are desired or not
want_plots = true;
% state whether to discard half of training data to achieve a higher
% accuracy
discard_half_trainingset = false;

%% loading data
load('semgExcerciseRand.mat');

if discard_half_trainingset == true
	xTrain = xTrain(1:10000,:);
	yTrain = yTrain(1:10000,:);
end

time_test = 1:1:size(xTest,1);
time_train = 1:1:size(xTrain,1);

%% Feature extraction
% % RMS
xTest_rms = rms(xTest, window, moving_window);
xTrain_rms = rms(xTrain, window, moving_window);

% % Waveform lengtr
% xTest_waveform = waveform_length(xTest, window, moving_window);
% xTrain_waveform = waveform_length(xTrain, window, moving_window);

% % Auto regressive co-efficients
% xTest_AR = auto_regressive(xTest, window, moving_window);
% xTrain_AR = auto_regressive(xTrain, window, moving_window);

%% classifier
% training classifier
trainer = fitcdiscr([xTrain_rms], yTrain);

% classifying data using the classifier
classified_train = predict(trainer, [xTrain_rms]);
classified_test = predict(trainer, [xTest_rms]);

% attaining accuracy of classified data
accuracy_train = sum(yTrain==classified_train)/size(yTrain,1)*100.0
accuracy_test = sum(yTest==classified_test)/size(yTest,1)*100.0

%% plots
if want_plots == true
	figure('Name', 'xTest Raw Data')
	title('xTest Raw Data')
	for i=1:1:8
		subplot(2,4,i)
		hold on
		plot(time_test, xTest(:,i))
		xlabel("Sensor " + i)
		ylabel('Volt [V]')
	end
	
	figure('Name', 'xTest RMS Data')
	title('xTest RMS Data')
	for i=1:1:8
		subplot(2,4,i)
		hold on
		plot(time_test, xTest_rms(:,i))
		xlabel("Sensor " + i)
		ylabel('RMS [V]')
	end
	
	figure('Name', 'xTest Waveform Length')
	for i=1:1:8
		subplot(2,4,i)
		hold on
		plot(time_test, xTest_waveform(:,i))
		xlabel("Sensor " + i)
		ylabel('Wavelength [V]')
	end
	
	figure('Name', 'xTest AR Length')
	for i=1:1:8
		subplot(2,4,i)
		hold on
		plot(time_test, xTest_AR(:,i))
		xlabel("Sensor " + i)
		ylabel('Wavelength [V]')
	end
	
	figure
	hold on
	plot(time_test, classified_test)
	plot(time_test, yTest)
	title('Test data')
	legend('Classified', 'Actual')
	xlabel('Time [ms]')
	ylabel('Labels')
	
	figure
	hold on
	plot(time_train, classified_train)
	plot(time_train, yTrain)
	title('Train data')
	legend('Classified', 'Actual')
	xlabel('Time [ms]')
	ylabel('Labels')
end
