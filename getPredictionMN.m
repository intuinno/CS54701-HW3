  
function prediction = getPredictionMN( testLC, targetMovie, Pvyz)



ratingValue = [1 2 3 4 5]';
    
 
                
                for countLC = 1: length(testLC) 
                    
                    temp(countLC) = sum(ratingValue .* Pvyz(:,targetMovie, countLC));
                    
                    
                end
                
                prediction =    sum (temp  .* testLC );
                
                
                
            end
            
        