close all
clear

load dataset

if matlabpool('size') == 0 

	matlabpool 

end

tic

getRecommendationFile('result5.txt',test5, train, 4, 'Cosine');
getRecommendationFile('result10.txt',test10, train, 9, 'Cosine' );
getRecommendationFile('result20.txt',test20, train, 17, 'Cosine');

toc









	

