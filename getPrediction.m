function getPrediction(data, user, movie)

	%Get the Pearson similarity score for every users
	simUsers = [];
	
	for i= 1:200
		
		simUsers(i) =  getPearsonScore(data, i, user);
		
	end
	
	
	
end