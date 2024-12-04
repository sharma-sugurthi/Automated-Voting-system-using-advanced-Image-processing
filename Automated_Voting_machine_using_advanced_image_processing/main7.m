% Main Script for Voter Verification and Voting

% Load registered face images
faceImages = load_registered_faces7();

if isempty(faceImages)
    disp('No face images loaded. Exiting...');
    return;
end

% Allow user to select a test image
[testFile, testPath] = uigetfile({'*.jpg;*.png;*.bmp', 'Image Files'}, 'Select a test image');
if isequal(testFile, 0)
    disp('No test image selected. Exiting...');
    return;
end

% Read the test image
testImage = imread(fullfile(testPath, testFile));

% Recognize the test image
recognizedIndex = recognize_face7(testImage, faceImages);

% Check if the voter is recognized
if recognizedIndex > 0
    disp(['Voter verified: Face index ', num2str(recognizedIndex)]);
    %figure;
    %imshow(faceImages(:,:,recognizedIndex));
    %title(['Recognized Face ', num2str(recognizedIndex)]);
    voting_pad7();
else
    disp('Voter not recognized. Exiting...');
    return;  % Exit if the voter is not recognized
end
