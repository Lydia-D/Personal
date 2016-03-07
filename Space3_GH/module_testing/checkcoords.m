%% By Lydia Drabsch
% function that checks the input to coordinate transform functions have 3
% rows
function checkcoords(input)
    if size(input,2)~=3
        fprintf('error with coordinate input')
    end
end
        

