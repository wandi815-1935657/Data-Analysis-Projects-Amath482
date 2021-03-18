function [u, lambda, positions, numFrames] = pcanalysis(vidFrames1, vidFrames2, vidFrames3)
    numFrames1 = size(vidFrames1,4);
    numFrames2 = size(vidFrames2,4);
    numFrames3 = size(vidFrames3,4);
    numFrames = min([numFrames1, numFrames2, numFrames3]);
    positions = zeros(6, numFrames);
    
    [xvector1, yvector1] = findposition(vidFrames1, numFrames);
    positions(1, :) = xvector1;
    positions(2, :) = yvector1;
    [xvector2, yvector2] = findposition(vidFrames2, numFrames);
    positions(3, :) = xvector2;
    positions(4, :) = yvector2;
    [xvector3, yvector3] = findposition(vidFrames3, numFrames);
    positions(5, :) = xvector3;
    positions(6, :) = yvector3;
    
    positions = positions - repmat(mean(positions, 2), 1, numFrames);
    [u, s, ~] = svd(positions/sqrt(numFrames-1));
    lambda = diag(s).^2;
end


