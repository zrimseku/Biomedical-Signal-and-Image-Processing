function marr_hildreth(file, threshold, K)
% Function shows original image saved in 'file' and binirazed image detecting edges.
% If 'K' (parameter for edge linking) > 0 it also shows image with linked
% edges. You can also set 'threshold' for finding zero crossing to
% determine how important edges you want to see - bigger threshold means less edges.
    close all
    im = imread(file);

    image = im2double(im);
    % Show original image
    figure
    imshow(image)
    title('Original image')

    % Select size and sigma for gauss filter
    sigma = min(size(image))*0.005;
    
    n = ceil(sigma*6);
    if rem(n,2)==0 
        n=n+1; 
    end
    
    gf = gauss_filter(n, sigma);
    
    % Smooth the image
    smoothed = conv2(image, gf, 'same');
    
    % Show smoothed image
    % figure
    % imshow(smoothed)
    % title('Smoothed image')
    
    % Compute the Laplacian
    mask = [0, 1, 0; 1, -4, 1; 0, 1, 0];
    
    laplacian = conv2(smoothed, mask, 'same');
    
    % Show Laplacian
    % figure
    % imshow(laplacian * 255)
    % title('Laplacian of the image')
    
    % Find zero crossings - if you don't want to use the threshold set it
    % to 0
    [h, w] = size(laplacian);
    edges = zeros(h, w);
    
    for i = 2:h-1
        for j = 2:w-1
            differ = 0;
            % check up-down and diagonal neighbours
            for d = -1:1
                if laplacian(i+d, j+1)*laplacian(i-d, j-1) < 0 && abs(laplacian(i+d, j+1) - laplacian(i-d, j-1)) >= threshold
                    differ = differ + 1;
                end
            end
            % check left-right neighbours
            if laplacian(i+1, j)*laplacian(i-1, j) < 0 && abs(laplacian(i+1, j) - laplacian(i-1, j)) >= threshold
                differ = differ + 1;
            end
            if differ >= 2
                edges(i, j) = 1;
            end
        end
    end
    
    figure
    imshow(edges)
    imwrite(edges, strcat('binarized_', file))
    title('Binarized image')
    
    
    % Edge linking
    linked = edges;
    for i = 1:h
        for j = 1:h-K-1
            if edges(i, j)
                max_idx = find(edges(i, j+1:j+K+1), 1, 'last');
                linked(i, j:j+max_idx) = 1;
            end
            if edges(j, i)
                max_idx = find(edges(j+1:j+K+1, i), 1, 'last');
                linked(j:j+max_idx, i) = 1;
            end
        end
    end
        
    if K    
        figure
        imshow(linked)
        title('Linked edges')
    end
        

end