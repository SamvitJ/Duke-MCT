function [out, traj_f] = loadAllTraj(opts)
global text dataset

kk = 1;
for c = opts.cameras
    trackerOutput = double(load(fullfile(opts.path, 'SCT_output', sprintf('tracker_output_%d.txt', c))));
    idx = ismember(trackerOutput(:,2), dataset.frame_range(1):dataset.frame_range(2));
    trackerOutput = trackerOutput(idx==1, :);
    
    text = cell(1, 1); text{c} = ''; % initialize text streams    
    
    vid = fullfile(opts.path, 'frames', sprintf('camera%d', c), opts.framesFormat);
    msk = fullfile(opts.path, 'masks', sprintf('camera%d', c), opts.masksFormat);
        
    ids = unique(trackerOutput(:, 1));
    for idx = 1 : length(ids)
        printMyText(c, 'Computing tracks for traj %d of %d (cam %d)...\n', idx, length(ids), c);
        
        % extract features for current ID
        current_id = ids(idx);
        [data_id, frames]   = loadDataID(trackerOutput, current_id, c);
        
        thisModel = cell(1, length(frames));
        for f_idx = 1 : length(frames)
            f = frames(f_idx);
            
            % find img to world feet position in homogeneous coordinates
            [img_feet, wrl_feet, wrl_vel] = feetPosition(data_id, f, c);
            
            % explicit patch coords (bb_pr has fixed w/h ratio)
            bb = getBB(data_id, f);
            
            % store information about this frame
            current_id = data_id(1,1);
            thisModel{f_idx} = storeFrameInfo(c, current_id, f, img_feet, wrl_feet, wrl_vel, bb);
        end
        
        out{kk}.c = c; out{kk}.id = current_id; %#ok
        out{kk}.wrl_pos     = getPositionalInformation(thisModel); %#ok
        out{kk}.mean_hsv    = getBaselineDescriptor(thisModel, vid, msk); %#ok
        
        a                   = cellfun(@(x) x.bb, thisModel, 'uniformoutput', 0);
        out{kk}.bb          = cat(1, a{:}); %#ok
        kk = kk + 1;
    end
end

for i = 1 : numel(out), out{i}.MC_id = -1; end
traj_f = zeros(numel(out), 2);
for i = 1 : numel(out), if ~isempty(out{i}.wrl_pos), traj_f(i, :) = [out{i}.wrl_pos(1, 1) out{i}.wrl_pos(end, 1)]; end, end
