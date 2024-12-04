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

function resetVotingStatus()
    % Reset the "voted" status to false (or delete status file)
    statusFile = 'voted_status.txt';
    writeStatusToFile(statusFile, false);  % Set status to false (not voted)
end

function writeStatusToFile(fileName, status)
    % Write the status (true/false) to a file
    fileID = fopen(fileName, 'w');
    fprintf(fileID, '%d', status);
    fclose(fileID);
end

function status = readStatusFromFile(fileName)
    % Read the status from the file
    fileID = fopen(fileName, 'r');
    status = fscanf(fileID, '%d');
    fclose(fileID);
end
