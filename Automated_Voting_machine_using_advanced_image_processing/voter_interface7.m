function voter_interface()
    % Check if the faces folder path exists, otherwise ask the user to select it
    facesFolder = getFacesFolder();
    if isempty(facesFolder)
        disp('No faces folder selected. Exiting...');
        return;
    end
    
    % Create a figure for the voter interface
    hFig = figure('Name', 'Voter Verification', 'Position', [100, 100, 400, 300]);

    % Create a button to load the test image
    uicontrol('Style', 'pushbutton', 'String', 'Load Test Image', ...
              'Position', [100, 220, 200, 30], ...
              'Callback', @loadImageCallback);

    % Create a button to refresh voting status
    uicontrol('Style', 'pushbutton', 'String', 'Refresh Voting Status', ...
              'Position', [100, 180, 200, 30], ...
              'Callback', @resetVotingStatusCallback);

    % Text field to display the result
    resultText = uicontrol('Style', 'text', 'Position', [50, 150, 300, 30], ...
                            'FontSize', 12, 'String', '');

    % Callback function for loading and recognizing the image
    function loadImageCallback(~, ~)
        % Check if the voter has already voted
        if hasVoted()
            resultText.String = 'You have already voted!';
            return;  % Exit if the voter has already voted
        end
        
        % Load registered face images from the selected folder
        faceImages = load_registered_faces(facesFolder);
        
        if isempty(faceImages)
            resultText.String = 'No registered faces found.';
            return;
        end
        
        % Allow user to select a test image
        [testFile, testPath] = uigetfile({'*.jpg;*.png;*.bmp', 'Image Files'}, 'Select a test image');
        if isequal(testFile, 0)
            resultText.String = 'No test image selected.';
            return;
        end
        
        % Read the test image
        testImage = imread(fullfile(testPath, testFile));

        % Recognize the test image
        recognizedIndex = recognize_face(testImage, faceImages);

        % Update the result text based on recognition
        if recognizedIndex > 0
            resultText.String = ['Voter verified: Face index ', num2str(recognizedIndex)];
            voting_pad();  % Proceed to voting pad
            % Mark as voted
            writeStatusToFile('voted_status.txt', true);
        else
            resultText.String = 'Voter not recognized.';
        end
    end

    % Callback function to reset the voting status
    function resetVotingStatusCallback(~, ~)
        resetVotingStatus();  % Reset the voting status when clicked
        resultText.String = 'Voting status has been reset. Voters can vote again.';
    end
end

% Function to get the faces folder path from the file (or ask for input if not present)
function facesFolder = getFacesFolder()
    if exist('faces_folder_path.txt', 'file')
        % Read folder path from file
        fid = fopen('faces_folder_path.txt', 'r');
        facesFolder = fgetl(fid);
        fclose(fid);
    else
        % Ask user to select the folder if not found
        facesFolder = uigetdir('', 'Select the folder containing registered faces');
        if facesFolder ~= 0
            % Save the selected folder path for future use
            fid = fopen('faces_folder_path.txt', 'w');
            fprintf(fid, '%s', facesFolder);
            fclose(fid);
        else
            facesFolder = '';  % Return empty if no folder is selected
        end
    end
end

% Function to load registered faces from the saved folder path
function faceImages = load_registered_faces(facesFolder)
    % Initialize a 3D array to store face images (height x width x numImages)
    faceImages = [];
    
    % Get a list of all image files in the folder (only .jpg files in this case)
    imageFiles = dir(fullfile(facesFolder, '*.jpg'));  % Change to '*.png' or '*.bmp' if needed
    
    if isempty(imageFiles)
        disp('No image files found in the folder.');
        return;
    end
    
    % Get the size of the first image to initialize faceImages matrix
    firstImage = imread(fullfile(facesFolder, imageFiles(1).name));
    grayFirstImage = rgb2gray(firstImage);
    resizedFirstImage = imresize(grayFirstImage, [100, 100]);  % Resize for consistency
    [height, width] = size(resizedFirstImage);  % Get the dimensions of the resized image
    
    % Initialize the faceImages matrix to store all face images
    faceImages = zeros(height, width, length(imageFiles));  % 3D matrix to store each face as a slice
    
    % Process each registered face image
    for i = 1:length(imageFiles)
        % Read the image
        img = imread(fullfile(facesFolder, imageFiles(i).name));
        
        % Convert the image to grayscale (necessary for face recognition)
        grayImage = rgb2gray(img);
        
        % Resize the image to a standard size (e.g., 100x100 pixels)
        grayImage = imresize(grayImage, [100, 100]);  % Resize for consistency
        
        % Store the preprocessed image in the 3D matrix (each image is a slice)
        faceImages(:,:,i) = grayImage; 
    end
end

% Function to check if the voter has voted
function status = hasVoted()
    statusFile = 'voted_status.txt';
    if exist(statusFile, 'file')
        status = readStatusFromFile(statusFile);
    else
        status = false;  % If file doesn't exist, voter has not voted
    end
end

% Function to reset the "voted" status
function resetVotingStatus()
    statusFile = 'voted_status.txt';
    if exist(statusFile, 'file')
        delete(statusFile);  % Delete the file to reset status
    end
end

% Function to write the voting status (true/false) to the file
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
