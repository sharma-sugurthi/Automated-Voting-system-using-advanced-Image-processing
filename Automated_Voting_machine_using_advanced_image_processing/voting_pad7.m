function voting_pad7()
    % Check if the voter has already voted
    if hasVoted()
        disp('You have already voted.');
        return;
    end
    
    % Create a figure for the voting pad
    hFig = figure('Name', 'Voting Pad', 'Position', [100, 100, 500, 400]);

    % Define candidate names and their image file paths
    candidates = {'Shah Rukh Khan', 'Chiranjeevi', 'Aiswarya Rai'};
    candidateImages = {'C:\Users\Administrator\Desktop\s.jpg', 'C:\Users\Administrator\Desktop\c.jpg', 'C:\Users\Administrator\Desktop\a.jpg'};

    % Create a group for candidate selection
    uicontrol('Style', 'text', 'String', 'Select a Candidate:', ...
              'Position', [150, 330, 200, 20], 'FontSize', 12);

    % Variable to store the selected candidate index
    selectedCandidateIndex = 0;

    % Create a button to cast the vote
    uicontrol('Style', 'pushbutton', 'String', 'Cast Vote', ...
              'Position', [200, 20, 100, 30], ...
              'Callback', @castVoteCallback);

    % Result display text
    resultText = uicontrol('Style', 'text', 'Position', [50, 5, 400, 30], ...
                            'FontSize', 12, 'String', '');

    % Initialize radio buttons array for candidate selection
    radioButtons = zeros(1, length(candidates));

    % Display candidates with their images and radio buttons
    for i = 1:length(candidates)
        % Display the candidate image
        img = imread(candidateImages{i});
        subplot(3, 2, (i - 1) * 2 + 1);  % Position for the image
        imshow(img);
        title(candidates{i});
        
        % Create a radio button for each candidate
        radioButtons(i) = uicontrol('Style', 'radiobutton', 'String', candidates{i}, ...
                                     'Position', [10, 240 - (70 * (i - 1)), 150, 30], ...
                                     'FontSize', 12, 'Callback', @(src, event) selectCandidate(i));
    end

    % Callback function to handle candidate selection
    function selectCandidate(index)
        % Deselect all radio buttons first
        for j = 1:length(radioButtons)
            set(radioButtons(j), 'Value', 0);
        end
        
        % Select the clicked radio button
        set(radioButtons(index), 'Value', 1);
        selectedCandidateIndex = index;  % Store the selected candidate index
    end

    % Callback function to cast the vote
    function castVoteCallback(~, ~)
        if selectedCandidateIndex == 0
            resultText.String = 'Please select a candidate!';
        else
            votedCandidate = candidates{selectedCandidateIndex};
            resultText.String = ['You voted for: ', votedCandidate];
            % Store the vote count in the results file
            incrementVoteCount(selectedCandidateIndex);
            markAsVoted();
            freezeVotingPad();  % Freeze the voting pad (disable buttons)
        end
    end

    % Function to increment the vote count for the selected candidate
    function incrementVoteCount(candidateIndex)
        voteCounts = loadVoteCounts();
        voteCounts(candidateIndex) = voteCounts(candidateIndex) + 1;
        saveVoteCounts(voteCounts);
    end

    % Function to freeze the voting pad after voting
    function freezeVotingPad()
        set(findall(hFig, 'Style', 'radiobutton'), 'Enable', 'off');
        set(findall(hFig, 'Style', 'pushbutton'), 'Enable', 'off');
    end
end

% Function to check if the voter has already voted
function status = hasVoted()
    % Check if a "voted" status file exists
    statusFile = 'voted_status.txt';
    if exist(statusFile, 'file')
        % If the file exists, read the status
        status = readStatusFromFile(statusFile);
    else
        status = false;  % If file doesn't exist, voter has not voted
    end
end

% Function to mark the voter as having voted
function markAsVoted()
    % Write the "voted" status to a file
    statusFile = 'voted_status.txt';
    writeStatusToFile(statusFile, true);  % Set status to true (voted)
end

% Function to reset the voting status (for refresh button)
function resetVotingStatus()
    % Reset the "voted" status to false (or delete status file)
    statusFile = 'voted_status.txt';
    writeStatusToFile(statusFile, false);  % Set status to false (not voted)
end

% Function to write the status (true/false) to a file
function writeStatusToFile(fileName, status)
    fileID = fopen(fileName, 'w');
    fprintf(fileID, '%d', status);
    fclose(fileID);
end

% Function to read the status from the file
function status = readStatusFromFile(fileName)
    fileID = fopen(fileName, 'r');
    status = fscanf(fileID, '%d');
    fclose(fileID);
end

% Function to load vote counts (for each candidate)
function voteCounts = loadVoteCounts()
    voteFile = 'vote_counts.txt';
    if exist(voteFile, 'file')
        fileID = fopen(voteFile, 'r');
        voteCounts = fscanf(fileID, '%d');
        fclose(fileID);
    else
        voteCounts = [0, 0, 0];  % Default if no votes are cast
    end
end

% Function to save the vote counts to a file
function saveVoteCounts(voteCounts)
    fileID = fopen('vote_counts.txt', 'w');
    fprintf(fileID, '%d\n', voteCounts);
    fclose(fileID);
end
