% Function to count the total number of voters based on images in a folder
function totalVoters = countVoters(voterFolderPath)
    % Get all the .jpg files (or any image type you use) in the folder
    files = dir(fullfile(voterFolderPath, '*.jpg'));  % You can change file extension if needed
    totalVoters = length(files);  % Count the number of voter images
end

% Function to display the current voter status
function displayVoterStatus(voterFolderPath)
    % Calculate total voters
    totalVoters = countVoters(voterFolderPath);
    
    % Read the number of voted voters from file (from previous voting session)
    votedFile = 'voted_count.txt';
    if exist(votedFile, 'file')
        fileID = fopen(votedFile, 'r');
        votedCount = fscanf(fileID, '%d');
        fclose(fileID);
    else
        votedCount = 0;  % If no file, assume no one has voted yet
    end
    
    % Calculate remaining voters
    remainingVoters = totalVoters - votedCount;
    
    % Display the current voter status in the command window
    disp(['Total Voters: ', num2str(totalVoters)]);
    disp(['Voted: ', num2str(votedCount)]);
    disp(['Remaining Votes: ', num2str(remainingVoters)]);
end
