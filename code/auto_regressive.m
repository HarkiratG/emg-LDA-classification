
% input: 'data' to perform AR on; 'window_size' stating the size of
% window, 'moving_window' stating whether the user wants to perform AR on
% moving or static window

% output: 'result' contains the x(i+1) acquired from using AR coeffs 
% of desired 'data' over 'window_size'

function result = auto_regressive(data, window_size, moving_window)
% order of the auto regressive coefficients
p=4;
% % moving window
% performs waveform length calc AROUND the said datapoint rather than looking  
% forward or backward. for example: wavelength(100) at window_size 100 
% would be rms on data(50:150)
if moving_window == 1
	for i = 1:1:size(data,1)
		for sensor = 1:1:8
			if i < window_size/2
				ar_data = data(1:i+window_size/2, sensor);
				AR_coeff = aryule(ar_data , p);
				result(i, sensor) = -AR_coeff(2:end) * ar_data(end:-1:end-p+1);
			elseif i > size(data,1)-window_size/2
				ar_data = data(i-window_size/2+1:size(data,1), sensor);
				AR_coeff = aryule(ar_data , p);
				result(i, sensor) = -AR_coeff(2:end) * ar_data(end:-1:end-p+1);
			else
				ar_data = data(i-window_size/2+1:i+window_size/2, sensor);

				AR_coeff = aryule(ar_data , p);

				result(i, sensor) = -AR_coeff(2:end) * ar_data(end:-1:end-p+1);
			end
		end
	end
% % static window
else
	result = [];
	for i = 1:window_size:size(data,1)
		for sensor = 1:1:8
			ar_data = data(i:i+window_size-1, sensor);
			AR_coeff = aryule(ar_data , p);	
			a(sensor) = -AR_coeff(2:end) * ar_data(end:-1:end-p+1);	
		end
		result = [result; repmat(a,window_size,1)];
	end
end