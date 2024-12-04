function recognizedIndex = recognize_face(testImage, faceImages)
    % Convert test image to grayscale and resize
    grayTestImage = rgb2gray(testImage);
    resizedTestImage = imresize(grayTestImage, [100, 100]);
    testVector = resizedTestImage(:);  % Flatten to a column vector

    % Flatten registered images
    [height, width, numImages] = size(faceImages);
    faceVectors = reshape(faceImages, height * width, numImages);  % Convert each image to a column vector

    % Apply PCA on the face image data (centered data)
    [coeff, ~, ~] = pca(double(faceVectors'));  % PCA on the data

    % Project test image onto PCA space
    testProjection = coeff' * double(testVector);

    % Compute distances
    distances = sum((testProjection - coeff' * faceVectors).^2, 1);
    disp('Distances to registered faces:');  
    disp(distances);

    % Set a threshold for recognition
    distanceThreshold = 150;  % Adjust this value based on your testing

    % Find the closest match
    [minDistance, recognizedIndex] = min(distances);

    % Check against the threshold
    if minDistance > distanceThreshold
        recognizedIndex = 0;  % No close match
    else
        disp(['Recognized Index: ', num2str(recognizedIndex), ' with Distance: ', num2str(minDistance)]);
    end
end
