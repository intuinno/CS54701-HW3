
close all

clear

load dataset

if matlabpool('size') == 0 

	matlabpool 

end
%============================
% Custom input Parameters
%============================

q = 1;

numIteration = 500;

numLatentClass = 2;

beta = 1;

ratings = train;

nowSet = now;

[numUser numMovie] = size(ratings);

testMetric=[];
numIterLC = 0;

% for numLatentClass = [2 5 10 20 40 60 80 100]

numIterLC = numIterLC + 1;

%Get the mean and std of nonzero ratings
meanUser = zeros(numUser,1);
stdUser = zeros(numUser,1);

parfor i=1:numUser
    meanUser(i) = mean( ratings(i, find(ratings(i,:))) );
    stdUser(i) = std( ratings(i, find(ratings(i,:))) );
end

globalMean = mean(meanUser);
globalStd = std(stdUser);

%Do the normalization
%origRatings will contain original ratings
%ratings will contain normalized ratings

origRatings = ratings;



parfor i = 1:numUser
    
    ratings(i,:) = (ratings(i,:)-meanUser(i)) / stdUser(i);
    
end


%Randomly initialize Q
Q = rand(numUser, numMovie, numLatentClass);

%Normalize random value 
for i=1:numUser
    for j=1:numMovie
        D = sum(Q(i,j,:));
        Q(i,j,:) = Q(i,j,:)/D;
    end
end

A = rand(numUser, numLatentClass);

B = sum(A,2);

C = ones(1,numLatentClass);

D = B * C;

Pzu = A ./ D;

M_yz = rand(numMovie, numLatentClass)*2-1;

Std_yz = 3*rand(numMovie, numLatentClass)+1;

%h=waitbar(0,'Please wait..');

tic

for countIter=1:numIteration
    
    %calculateE;
    
    %	    waitbar(i/numIteration);
    
    PreviousQ = Q;
    
    
    for countUser=1:numUser
        
        for countItem=1:numMovie
            
            down = 0;
            
            if origRatings(countUser,countItem) ~= 0
                
                for countLC=1:numLatentClass
                    
                    up = Pzu(countUser,countLC) .* gaussianPDF2(ratings(countUser,countItem),M_yz(countItem,countLC),Std_yz(countItem,countLC));
                    
                    up = up.^beta;
                    
                    down = down + up;
                    
                    if up == 0
                        
                        disp 'Q up is 0';
                        pause;
                        
                    end
                    
                    Q(countUser,countItem, countLC) = up;
                    
                    
                    
                end
                
                if down ~=0
                    
                    Q(countUser,countItem,:) = Q(countUser,countItem,:)/down;
                    
                    
                    
                else
                    
                    disp 'Q2 down = 0 occured'
                    pause;
                    
                end
                
                
                
                
            end
            
            
            
        end
        
        
    end
    
    %D = sum(sum(sum(Q)));
    
    %Q = Q/D;
    
    if ismember(1,isnan(Q))
        
        disp 'Q NaN occured'
        
        pause;
        
    end
    
    %disp([num2str(countIter), ' : Finished E step']);
    
    %calculate M
    
    %First Calculate M_yz
    
    PreviousM = M_yz;
    
    for countItem=1:numMovie
        %
        % 			if countItem == 711
        %
        % 				disp 'M countItem is 711'
        %
        % 				pause;
        %
        % 			end
        
        
        for countLC=1:numLatentClass
            
            up = 0;
            
            down = 0;
            
            for countUser = 1 : numUser
                
                
                if origRatings(countUser,countItem) ~= 0
                    
                    up = up + ratings(countUser,countItem)*Q(countUser,countItem,countLC);
                    
                    %disp(Q(countUser,countItem,countLC))
                    
                    
                    down = down + Q(countUser,countItem,countLC);
                    
                    
                    
                end
                
                
            end
            
            
            if (down ~=0)
                M_yz(countItem,countLC) = up/down;
                
            else
                M_yz(countItem,countLC) = 0;
                %disp 'M down is 0'
                %pause;
                
            end
            
            
        end
        
    end
    
    
    if ismember(1,isnan(M_yz))
        
        disp 'M NaN occured'
        
        pause;
        
    end
    
    %disp([num2str(countIter), ' : Updated Mean(yz)']);
    
    %Second Calculate Std_yz
    
    PreviousStd = Std_yz;
    
    stdCount = 0;
    for countItem=1:numMovie
        
        
        
        for countLC=1:numLatentClass
            
            tempup = 0;
            
            down =0;
            
            
            for countUser = 1 : numUser
                
                if origRatings(countUser,countItem) ~= 0
                    
                    tempup = tempup + (ratings(countUser,countItem)-PreviousM(countItem,countLC))^2*Q(countUser,countItem,countLC);
                    
                    down = down +  Q(countUser,countItem,countLC);
                end
                
            end
            
            %Std_yz(countItem,countLC) = sqrt(tempup/down);
            
            if(tempup/down > 0.1)
                
                Std_yz(countItem,countLC) = sqrt(tempup/down);
                
            elseif (down == 0)
                
                
                Std_yz(countItem,countLC) = 1;
                %					disp 'Std down is 0!'
                %					pause;
                
            else
                
                Std_yz(countItem,countLC) = 0.5;
                
                
                stdCount = stdCount + 1;
                
                %disp(['Std saturation has occured!',num2str(stdCount)]);
                %pause;
                
            end
            
        end
        
    end
    
    if ismember(1,isnan(Std_yz))
        
        %disp 'Std NaN occured'
        
        pause;
        
    end
    
    %disp([num2str(countIter), ' : Updated STD(yz)']);
    %Lastly Calculate Pzu
    
    PreviousPzu = Pzu;
    
    for countUser=1:numUser
        
        down=0;
        
        for countLC=1:numLatentClass
            
            
            up = 0;
            
            
            for countItem = 1 : numMovie
                
                if origRatings(countUser,countItem) ~= 0
                    
                    
                    up = up + Q(countUser,countItem,countLC);
                    
                    down = down + Q(countUser,countItem,countLC);
                    
                end
                
                
            end
            
            Pzu(countUser,countLC) = up;
            
            
        end
        
        if down == 0
            
            disp 'Pzu down is 0!'
            
            pause;
            
        end;
        
        Pzu(countUser,:) = Pzu(countUser,:) / down;
        
    end
    
    if ismember(1,isnan(Pzu))
        
        disp 'Pzu NaN occured'
        
        pause;
        
    end
    
    
    %disp([num2str(countIter), ' : Updated P(yz)']);
    
    %disp(i);
    
    %calculateM;
    %displayRisk;
    
    numRating = 0;
    
    ExpectedRating = zeros(numUser,numMovie);
    
    for countUser=1:numUser
        
        for countItem=1:numMovie
            
            acc = 0;
            
            for countLC = 1:numLatentClass
                
                acc = acc + Pzu(countUser,countLC)*M_yz(countItem, countLC);
                
            end
            
            ExpectedRating(countUser,countItem) = acc;
            
            
        end
        
    end
    
    squareLoss = 0;
    
    for countUser=1:numUser
        
        for countItem=1:numMovie
            
            if origRatings(countUser, countItem) ~= 0
                
                
                numRating = numRating + 1;
                
                
                squareLoss = squareLoss +  (ratings(countUser,countItem)-ExpectedRating(countUser,countItem))^2;
                
            end
            
        end
        
    end
    
    for i =1:numUser
        
        NorExpRating(i,:) = ExpectedRating(i,:)*stdUser(i) + meanUser(i);
        
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
    
    squareLoss = squareLoss/numRating;
    
    realSquareLoss = realSquareLoss/numRating;
    
    realMAE = realMAE/numRating;
    
    Risk(countIter)=realSquareLoss;
    
    titleStr = ['  Number of Latent Class k = ', num2str(numLatentClass)];
    
    plot(Risk),title(titleStr);
    
    drawnow;
    
    if countIter > 5
        
        if  abs(Risk(countIter-1) - Risk(countIter)) < Risk(countIter-1)*0.00001
            
            %disp 'Converged'
            
            break;
            
            
        end
        
    end
    
    
    
    
    %disp([num2str(countIter), ' : Updated Risk)']);
    
    
end


getRecFileAspectModeling (test5, 'result5AM.txt', M_yz, Std_yz,globalMean, globalStd);

getRecFileAspectModeling (test10, 'result10AM.txt', M_yz, Std_yz,globalMean, globalStd);
getRecFileAspectModeling (test20, 'result20AM.txt', M_yz, Std_yz,globalMean, globalStd);


