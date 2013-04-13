function latentClass = getLatentClassMN(testUser, Pvyz)

numIteration = 500;

[numRatings numMovie numLatentClass] = size(Pvyz);

testLC = rand(1,numLatentClass);

previousError = 0;

ind = find(testUser);

Q = rand(numMovie, numRatings, numLatentClass);



for countIter=1:numIteration
    
    %Calculate E
    
    
    
    for countMovie=1:numMovie
        
        if testUser( countMovie) ~= 0
            
            for countRating =1:numRatings
                
                if testUser( countMovie) == countRating
                    for countLC = 1:numLatentClass
                        
                        Q(countMovie, countRating, countLC) = testLC(countLC) * Pvyz(countRating, countMovie, countLC);
                        
                    end
                    
                    if sum( Q(countMovie, countRating,:)) == 0
                        %disp 'I am here'
                        %pause;
                    else
                        
                        Q( countMovie, countRating, :) = Q(countMovie, countRating, :) ./ sum( Q(countMovie, countRating,:));
                        
                    end
                    
                end
                
                
                
            end
            
        end
        
        
        
        %Calculate M
        
        
        for countLC =1:numLatentClass
            
            
            
            testLC(countLC) = sum( sum ( Q( ind,:,countLC)));
            
        end
        
    
        
        testLC( :) = testLC(:) / sum(testLC(:));
        
        
        
        %Calculate Risk
        
        currentError = 0;
        for countMovie = ind
            
            error = 0;
            error = testUser(countMovie) - getPredictionMN( testLC , countMovie, Pvyz) ;
            currentError = currentError +  abs(error);
            
        end
        
        if     (previousError - currentError) / currentError < 0.00001
            break;
        end
        
        
    end
    
    
    latentClass = testLC;
    
end


