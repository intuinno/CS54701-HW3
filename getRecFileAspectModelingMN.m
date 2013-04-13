function getRecFileAspectModelingMN (testData, filename , Pvyz)


test5 = testData;
test = [];
testPzu = [];

[m n] = size(test5);


%Read the test user rating
for i = 1:m
	test(test5(i,1),test5(i,2)) = test5(i,3);
end


[numTestUser numTestMovie] = size(test);
smooth = 5;

numTestMovie = length(find( test(test5(1,1),:) ));



%Do the normalization
%origRatings will contain original ratings
%ratings will contain normalized ratings




for i = test5(1,1):numTestUser
    
%For every test user , get the latent class testPzu
testPzu(i,:) = getLatentClassMN( test(i,:) , Pvyz  ) ;

end



for i = 1:m
	
	if test5(i,3) == 0
        
        
        result(i) =  getPredictionMN(testPzu(test5(i,1)), test5(i,2), Pvyz);
        result(i) = round(result(i)); 
        
        if result(i) > 5 
            result(i) = 5;
        elseif result(i) < 1
            result(i) = 1;
        end
        
    
    end
end


fid = fopen(filename,'w');

for i = 1:m
    if test5(i,3) == 0
        if result(i) == 0 
            disp 'something bad'
        end
        
        fprintf(fid, '%d %d %d\n',  test5(i,1), test5(i,2), result(i) );
    end
    
    
end

fclose(fid);

end
