
close all

clear

load dataset

%============================
% Custom input Parameters
%============================


numIteration = 500;

numLatentClass = 50;

numRatings = 5;

ratings = train;


[numUser numMovie] = size(ratings);

Q = rand(numUser, numMovie, numRatings, numLatentClass) ;

origRatings = ratings;

Pzu = rand(numUser, numLatentClass);
Pvyz = rand(numRatings, numMovie, numLatentClass);

for countIter=1:numIteration
    
    %calculateE;
    
    
    for countUser=1:numUser
        
        for countMovie=1:numMovie
            
            if origRatings(countUser, countMovie) ~= 0
                
                for countRating =1:numRatings
                    
                %    if origRatings(countUser, countMovie) == countRating
                    for countLC = 1:numLatentClass
                        
                        Q(countUser, countMovie, countRating, countLC) = Pzu(countUser, countLC) * Pvyz(countRating, countMovie, countLC);
                        
                    end
                    
                    if sum( Q(countUser,countMovie, countRating,:)) == 0
                        %disp 'I am here'
                        %pause;
                    else
                        
                        Q(countUser, countMovie, countRating, :) = Q(countUser,countMovie, countRating, :) ./ sum( Q(countUser,countMovie, countRating,:));
                    
                    end
                    
                 %   end
                    
                    
                    
                end
                
            end
        end
        
    end
    
    %Calculate M
    %Update Pzu
    for countUser=1:numUser
        
        for countLC =1:numLatentClass
            
            itemInd = find(ratings(countUser,:));
            
            Pzu(countUser, countLC) = sum( sum ( Q(countUser, itemInd,:,countLC)));
            
        end
        
        if sum(Pzu(countUser,:)) == 0
                        disp 'I am here'
                        pause;
                    end
        
        Pzu(countUser, :) = Pzu(countUser, :) / sum(Pzu(countUser,:));
        
    end
    
    %Update Pvyz
    for countLC=1:numLatentClass
        
        for countMovie=1:numMovie
            
            for countRating=1:numRatings
                
                userInd = find( ratings(:,countMovie) == countRating);
                
                Pvyz(countRating, countMovie, countLC) = sum( Q(userInd, countMovie, countRating, countLC) );
                
            end
            
            if sum(Pvyz(:,countMovie, countLC)) == 0
                        %disp 'Pvyz 0 occured'
                        %pause;
                        
                        
            else
                Pvyz(:, countMovie, countLC) = Pvyz(:,countMovie, countLC) ./ sum(Pvyz(:,countMovie, countLC));
            
                
            end
                    
            
            
        end
        
    end
    
    
    
     for countUser = 1:numUser
        
        for countItem = 1: numMovie
            
            if origRatings(countUser, countItem) ~= 0
                
         
                
                NorExpRating(countUser, countItem) =    getPredictionMN (Pzu(countUser,:), countItem,Pvyz);
                
                
                
            end
            
        end
        
    end
    
    
    
    
    
    realSquareLoss = 0;
    
    realMAE = 0;
    
    for countUser=1:numUser
        
        for countItem=1:numMovie
            
            if origRatings(countUser, countItem) ~= 0
                
                realSquareLoss = realSquareLoss +  (origRatings(countUser,countItem)-NorExpRating(countUser,countItem))^2;
                realMAE = realMAE + abs(origRatings(countUser,countItem)-NorExpRating(countUser,countItem));
                
            end
            
        end
        
    end
    
%    squareLoss = squareLoss/numRating;

numRating = length(find(ratings));
    
    realSquareLoss = realSquareLoss/numRating;
    
    realMAE = realMAE/numRating;
    
    Risk(countIter)=realSquareLoss;
    
    titleStr = ['  Number of Latent Class k = ', num2str(numLatentClass)];
    
    plot(Risk),title(titleStr);
    
    drawnow;
    
    if countIter > 5
        
        if  (Risk(countIter-1) - Risk(countIter)) < Risk(countIter-1)*0.00001
            
            %disp 'Converged'
            
            break;
            
            
        end
        
        if Risk(countIter-1) < Risk(countIter) 
            
            disp 'riversed'
            break;
        end
        
            
            
        
    end
    
    
    
    
    %disp([num2str(countIter), ' : Updated Risk)']);
    
    
end


getRecFileAspectModelingMN (test5, 'result5AMM.txt' , Pvyz);

getRecFileAspectModelingMN (test10, 'result10AMM.txt' , Pvyz);
getRecFileAspectModelingMN (test20, 'result20AMM.txt', Pvyz);


