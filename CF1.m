close all
clear

load dataset

if matlabpool('size') == 0 

	%matlabpool 

end

test = train;

[m n] = size(test5);

%Read the test user rating
for i = 1:m
	test(test5(i,1),test5(i,2)) = test5(i,3);
end

%For every test user and movie pair calculate the movie

parfor i = 1:m
	i
	if test5(i,3) == 0
		getPrediction(test, test5(i,1), test5(i,2))
	end
end










	

