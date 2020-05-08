function show_color_depth_labels(outdir,i,RGB,D,L,K)
    R = RGB(:,:,1); G = RGB(:,:,2); B = RGB(:,:,3);
    
    se = strel('disk',1);
    [M,N,~] = size(RGB);
    borders = false(M,N);
    
    for k = 1:K
        mask = L == k;
        
        borders = borders | imerode(mask,se);
        
        R(mask) = mean(R(mask));
        G(mask) = mean(G(mask));
        B(mask) = mean(B(mask));
        
        D(mask) = mean(D(mask));
    end
    
    borders = ~borders;
    R(borders) = 0; G(borders) = 0; B(borders) = 0; 
    D(borders) = 1;
    
    meanRGB = zeros(size(RGB),'uint8');
    meanRGB(:,:,1) = R; meanRGB(:,:,2) = G; meanRGB(:,:,3) = B;
    
    imwrite(meanRGB,fullfile(outdir,sprintf('rgb_mean_%d.png',i)));
    imwrite(D,fullfile(outdir,sprintf('depth_mean_%d.png',i)));
end
