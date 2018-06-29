
% input: 'data' to perform the rms on; 'window_size' stating the size of
% window, 'moving_window' stating whether the user wants to perform rms on
% moving or static window

% output: 'result' contains the rms of desired 'data'

function result = rms(data, window_size, moving_window)

result = [];
% % moving window
% performs rms AROUND the said datapoint rather than looking forward or
% backward. for example: rms(100) at window_size 100 would be rms on
% data(50:150)
if moving_window == true
	for i = 1:1:size(data,1)
		if i < window_size/2
			result(i,:) = sqrt(2/window_size*sum(data(i:i+window_size/2, :).^2)); 
		elseif i > size(data,1)-window_size/2
			result(i,:) = sqrt(2/window_size*sum(data(i-window_size/2+1:i, :).^2));
		else
			result(i,:) = sqrt(1/window_size*sum(data(i-window_size/2+1:i+window_size/2, :).^2));
		end
	end
% % static window
else
	for i = 1:window_size:size(data,1)
		a = sqrt(1/window_size*sum(data(i:i+window_size-1, :).^2));
		result = [result; repmat(a,window_size,1)];
	end
end
