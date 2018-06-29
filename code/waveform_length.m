
% input: 'data' to perform the waveform on; 'window_size' stating the size of
% window, 'moving_window' stating whether the user wants to perform waveform length on
% moving or static window

% output: 'result' contains the rms of desired 'data'

function result = waveform_length(data,window_size, moving_window)

result = [];
% % moving window
% performs waveform length calc AROUND the said datapoint rather than looking  
% forward or backward. for example: wavelength(100) at window_size 100 
% would be rms on data(50:150)
if moving_window == true
	for i = 1:1:size(data,1)
		if i < window_size/2+2
			result(i,:) = 2*sum(abs( data(i+1:i+window_size/2+1,:) ...
				- data(i:i+window_size/2,:) ));
		elseif i > size(data,1)-window_size/2-1
			result(i,:) = 2*sum(abs( data(i-window_size/2+1:i,:) ...
				- data(i-window_size/2:i-1,:) ));
		else
			result(i,:) = sum(abs( data(i-window_size/2:i+window_size/2,:) ...
				- data(i-window_size/2-1:i+window_size/2-1,:) ));
		end
	end
% % static window
else
	for i = 2:window_size:size(data,1)
		a = sum(abs( data(i:i+window_size-2,:) - data(i-1:i+window_size-3,:) ));
		result = [result; repmat(a,window_size,1)];
	end
end