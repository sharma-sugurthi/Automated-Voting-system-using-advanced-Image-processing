function displayVotingResults()
    % Read the vote counts for each candidate from a file
    resultsFile = 'vote_results.txt';  % This file will store the vote counts
    if exist(resultsFile, 'file')
        fileID = fopen(resultsFile, 'r');
        results = fscanf(fileID, '%d');
        fclose(fileID);
    else
        results = [0, 0, 0];  % Default for 3 candidates (or as many as needed)
        saveVotingResults(results);  % Initialize file with default results
    end
    
    % Check if results are properly read
    disp('Current Vote Results:');
    disp(results);

    % Format the results as a string for display
    resultStr = 'Voting Results:\n';
    for i = 1:length(results)
        resultStr = sprintf('%sCandidate %d: %d votes\n', resultStr, i, results(i));
    end
    
    % Display the results in the result text box
    resultText.String = resultStr;  % Update the resultText field with the formatted results
end
