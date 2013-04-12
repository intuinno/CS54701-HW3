function getRecommendationFile (filename, testData, trainData) 

%test5  = test10
fid = fopen(filename,'w');
    
test5 = testData;
test = trainData;

[m n] = size(test5);


%Read the test user rating
for i = 1:m
	test(test5(i,1),test5(i,2)) = test5(i,3);
end

%For every test user and movie pair calculate the movie
result = [];

parfor i = 1:m
	
	if test5(i,3) == 0
		
        result(i) =  getPrediction(test, test5(i,1), test5(i,2)) ;
	end
end

for i = 1:m
    if test5(i,3) == 0
        if result(i) == 0 
            disp 'something bad'
        end
        
        fprintf(fid,'%d  %d  %d\n',  test5(i,1), test5(i,2), result(i) );
    end
    
    
end

fclose(fid);
