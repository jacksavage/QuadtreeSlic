function quad_tree_slic(img_name,K)
    
    outdir = 'results';
    if ~isfolder(outdir); mkdir(outdir); end
    timestamp = datestr(now, 'yyyymmdd_HHMMSSFFF');
    rundir = sprintf('%s %s K=%d',timestamp,img_name,K);
    outdir = fullfile(outdir, rundir);
    mkdir(outdir);
    fprintf('\n\t%s', outdir);

    % find the seed regions using quad tree decomposition
    [I,RGB] = load_lab_depth_img(img_name,0);    % load the default image
    [M,N,O] = size(I);                              % image height, width, depth
    fprintf('\tapplying quad tree decomposition to %d x %d image with %d regions\n',M,N,K);
    seeds = quad_tree_seeds(I,K);                   % use quad tree decomposition to find seed locations
    K = size(seeds,1);                              % find k again in case it was an invalid value (and was adjusted)

    imwrite(RGB,fullfile(outdir,'original.png'));
    imwrite(I(:,:,1),fullfile(outdir,'L.png'));
    imwrite(I(:,:,2),fullfile(outdir,'a.png'));
    imwrite(I(:,:,3),fullfile(outdir,'b.png'));
    imwrite(I(:,:,4),fullfile(outdir,'depth.png'));

    s = min(arrayfun(@(c) min(c.height,c.width), seeds));   % the min dimension of the smallest region  
    e = 200;                                                 % lab colorspace normalization

    % initialize a cluster from each seed region
    C = ...
        arrayfun( ...
            @(c) cluster( ...
                double(c.middle), double(c.center), ...     % initial row and column
                reshape(I(c.middle,c.center,:),O,1), ...    % initial pixel vector
                c.height, c.width, ...                      % region height and width for finding the cluster's search area
                s ...                                       % additional search distance beyond half height/width
            ), ...
            seeds ...
        );

    % show the seed locations
    fprintf('\tsaving image of seed locations from quadtree decomposition\n');
    QT = display_quad_tree(RGB,seeds,false,true,true);
    imwrite(QT,fullfile(outdir,'quadtree.png'));
    pause(0.1);

    % allocate space for pixel labels and best distances
    L = zeros(M,N,'int32');     % segment label for each pixel
    D = inf(M,N);               % best distance for each pixel
    % todo consider resetting on each iteration bc the centroids have moved and
    % those distances are no longer representative of the best possible
    % distance?

    % for each SLIC iteration
    for i = 1:10    
        fprintf('\t(%d) classifying each pixel\n', i);

        % for each cluster
        bc = 0;
        for k = 1:K       
            fprintf(repmat('\b',1,bc)); bc = fprintf('\tk = %d\n', i, k);

            % for each row and column in the search area
            for m = C(k).mm(M)
                for n = C(k).nn(N)
                    % select the corresponding pixel vector               
                    px  = reshape(I(m,n,:),O,1);

                    % find lab color distance from centroid
                    labk = C(k).px(1:3);
                    lab = px(1:3);
                    dE = sum((lab - labk).^ 2);

                    % find depth difference from centroid
                    depthk = C(k).px(4);
                    depth = px(4);
                    dDepth = (depth - depthk) ^ 2;

                    % find spatial difference from centroid
                    posk = [C(k).m C(k).n];
                    pos = double([m n]);
                    dPos = sum((pos - posk) .^ 2);

                    % normalize color and spatial differences
                    % the depth term was normalized when then image was loaded
                    dE = dE / e;
                    dPos = dPos / C(k).S;

                    % combine terms into one distance metric
                    d = sqrt(sum([dE dDepth dPos]));

                    % if this is the smallest distance we've found for this pixel
                    if d < D(m,n)
                       % change label to the current cluster and update the best distance
                       L(m,n) = k;
                       D(m,n) = d;
                    end
                end
            end
        end

        fprintf(repmat('\b',1,bc));
        fprintf('\tsaving color and depth label images\n');
        show_color_depth_labels(outdir,i,RGB,I(:,:,4),L,K);
        pause(0.1);

        % for each cluster
        fprintf('\tupdating cluster centroids\n'); bc = 0;
        for k = 1:K
           fprintf(repmat('\b',1,bc)); 
           bc = fprintf('\tk = %d\n', k);

           % find the mean of all pixel vectors with this cluster label
           mask = (L == k);

           % update the centroid position
           [mm,nn] = ind2sub([M,N], find(mask));
           C(k).m = mean(mm);
           C(k).n = mean(nn);

           % update the mean pixel
           px = zeros(O,1);
           for o = 1:O


               f = I(:,:,o);
               px(o) = mean(f(mask));
           end
           C(k).px = px;       
        end
    end
end
