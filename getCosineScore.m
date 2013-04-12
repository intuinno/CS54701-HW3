
function y = getCosineScore(data, user1, user2, numThreshold)


	% Get the list of shared movie item
	si = [];
	
% 	for movie = 1:1000 
% 		if data(user1,movie) * data(user2, movie) > 0 
% 			
% 			si = [si movie];
% 			
% 		end
% 	end
	
mul = data(user1,:) .* data(user2,:);
si = find(mul);

	%Now the si has the movie item both reviewed
	
	n = length(si);
	
	if n < numThreshold
		y=0;
		return ;
	end
	

	
	%Add up all the preference product
	divend = sum( data(user1, si)  .* data(user2, si) );
	
	divider = sqrt( sum( (data(user1,si)).^2 ) * sum( (data(user2,si)).^2 ) );
	
	if divider == 0
		y=0;
		
	else 
		y = divend/divider;
	
			
	
	
end


