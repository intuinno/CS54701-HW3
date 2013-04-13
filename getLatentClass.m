function latentClass = getLatentClass(testUser, M_yz, Std_yz, ind)


numIteration = 500;

[numMovie numLatentClass] = size(M_yz);

testLC = rand(1,numLatentClass);

previousError = 0;

for countIter=1:numIteration
    
    %Calculate E
    
    for countMovie = ind
        
        down = 0;
        
        for countLC = 1:numLatentClass
            
            Q(countMovie, countLC) = testLC(countLC) .* gaussianPDF2(testUser(countMovie),M_yz(countMovie,countLC),Std_yz(countMovie,countLC));
            
        end
        
        down = sum(Q(countMovie,:));
        
        if down 
        
        Q(countMovie, :) = Q(countMovie,:) ./ down;
        
    end
    
    
    %Calculate M
    
    for countLC = 1: numLatentClass
        
        testLC(countLC) = sum ( Q(:, countLC) );
        
    end
    
    down = sum (testLC);
    
    testLC = testLC / down;
    
    
    %Calculate Risk
    
    currentError = 0;
    for countMovie = ind
        
        error = 0;
        error = testUser(countMovie) - sum( testLC .* M_yz(countMovie,:) );
        currentError = currentError +  abs(error);
        
    end
    
    if     (previousError - currentError) / currentError < 0.00001
        break;
    end
    
    
end


latentClass = testLC;

end


