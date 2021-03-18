function [xvector, yvector] = findposition (vidFrame, numFrames)
    xvector = zeros(1, numFrames);
    yvector = zeros(1, numFrames);
    for j = 1:numFrames
        X = vidFrame(:,:,:,j);
        X = rgb2gray(X);
        [place1, place2] = find(X > 220); 
        xvector(j) = mean(place1);
        yvector(j) = mean(place2);
    end
end