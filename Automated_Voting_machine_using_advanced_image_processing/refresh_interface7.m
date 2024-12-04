function refresh_interface()
    % Create a figure for the refresh interface
    hFig = figure('Name', 'Refresh Voting Status', 'Position', [100, 100, 400, 300]);

    % Create a button to reset the voting status
    uicontrol('Style', 'pushbutton', 'String', 'Reset Voting Status', ...
              'Position', [100, 220, 200, 40], 'Callback', @resetVotingStatusCallback);

    % Create a button to end the election and display results
    uicontrol('Style', 'pushbutton', 'String', 'End Election', ...
              'Position', [100, 170, 200, 40], 'Callback', @endElectionCallback);

    % Display status text in the center of the window
    statusText = uicontrol('Style', 'text', 'Position', [50, 80, 300, 70], ...
                           'FontSize', 12, 'String', 'Click "End Election" to display results.', ...
                           'HorizontalAlignment', 'center');

    % Callback to reset the "voted" status
    function resetVotingStatusCallback(~, ~)
        resetVotingStatus();
        statusText.String = 'Voting status has been reset.';
    end

    % Callback to display results and end the election
    function endElectionCallback(~, ~)
        % Try to load the vote counts
        try
            voteCounts = loadVoteCounts();
            resultsText = sprintf('Candidate 1: %d votes\nCandidate 2: %d votes\nCandidate 3: %d votes', voteCounts);
            statusText.String = resultsText;  % Display results in the center
        catch ME
            % If there's an error, display a helpful message
            disp('Error while loading vote counts:');
            disp(ME.message);
            statusText.String = 'Error loading vote counts. Please check the vote counts file.';
        end
    end
end

% Function to load vote counts (for each candidate)
function voteCounts = loadVoteCounts()
    voteFile = 'vote_counts.txt';
    
    if exist(voteFile, 'file') == 2
        % File exists, load the data
        fileID = fopen(voteFile, 'r');
        voteCounts = fscanf(fileID, '%d');
        fclose(fileID);
        % Check if the file has three vote counts
        if length(voteCounts) ~= 3
            error('The vote_counts.txt file does not have the expected number of entries.');
        end
    else
        error('The vote_counts.txt file does not exist.');
    end
end

% Function to reset the voting status (for refresh button)
function resetVotingStatus()
    % Reset the "voted" status to false (or delete status file)
    statusFile = 'voted_status.txt';
    writeStatusToFile(statusFile, false);  % Set status to false (not voted)
    % Optionally, reset vote counts here as well
    resetVoteCounts();
end

% Function to reset vote counts to zero
function resetVoteCounts()
    voteFile = 'vote_counts.txt';
    fileID = fopen(voteFile, 'w');
    fprintf(fileID, '0\n0\n0');  % Reset all vote counts to zero
    fclose(fileID);
end

% Function to write the status (true/false) to a file
function writeStatusToFile(fileName, status)
    fileID = fopen(fileName, 'w');
    fprintf(fileID, '%d', status);
    fclose(fileID);
end
