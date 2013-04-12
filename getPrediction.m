function rating = getPrediction(data, user, movie, numThreshold, method)

	%Get the Pearson similarity score for every users
	simUsers = [];
	sumSimilarity = 0;
    sumRatings = 0;
    
    if user== 265
  %      disp ' I am here';
    end
    
	for i= 1:200
		if strcmp(method,'Pearson')
    		simUsers(i) =  getPearsonScore(data, i, user, numThreshold);
    
        elseif strcmp(method, 'Cosine')
            simUsers(i) = getCosineScore(data,i, user, numThreshold);
        end
    
    end
        
    sumSimilarity = sum( abs(simUsers) );
    
    sumRatings = 0;
    
    for i=1:200
        
        %mean( data(i, find(data(i,:))))
        sumRatings = sumRatings + simUsers(i) * ( data(i, movie) - mean( data(i, find(data(i,:)))));
        
    end
    
    if sumSimilarity == 0
        rating = mean( data(i, find(data(i,:))));
        
    else 
    
        rating = mean( data(user, find(data(user,:)))) + sumRatings/sumSimilarity;
    end
    
    rating =  round(rating);
    
    if rating < 1 
        rating = 1;
    elseif rating > 5 
        rating =5;    
    end
    
   
    
    
end