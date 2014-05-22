function regMat = remove_blank_inds(regMat,keep_inds)

% remove non keep inds
regMat(:,~keep_inds) = 0;


