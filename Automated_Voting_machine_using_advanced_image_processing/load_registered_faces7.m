function faceImages = load_registered_faces7()
    % Check if the folder path for registered faces exists in the file
    if exist('faces_folder_path.txt', 'file')
        % Read folder path from file
        fid = fopen('faces_folder_path.txt', 'r');
        facesFolder = fgetl(fid);
        fclose(fid);
        disp('Using previously selected folder for registered faces.');
    else
        % If no folder path exists, ask the user to select the folder
        facesFolder = uigetdir('', 'Select the folder containing registered faces');
        
        % If folder is selected, save the path to the file for future use
        if facesFolder ~= 0
            fid = fopen('faces_folder_path.txt', 'w');
            fprintf(fid, '%s', facesFolder);
            fclose(fid);
            disp('Folder path saved for future use.');
        else
            facesFolder = '';  % Return empty if no folder is selected
            disp('No folder selected. Exiting...');
            return;
        end
    end
    
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
    
    % Display success message
    disp(['Loaded ', num2str(length(imageFiles)), ' registered faces.']);
end
