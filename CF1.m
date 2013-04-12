close all
clear

load dataset

if matlabpool('size') == 0 

	matlabpool 

end

tic

getRecommendationFile('result5.txt',test5, train, 1);
getRecommendationFile('result10.txt',test10, train, 8 );
getRecommendationFile('result20.txt',test20, train, 16);

toc









	

