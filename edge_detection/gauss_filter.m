function gf = gauss_filter(n, sigma)
    gf = zeros(n);
    
    for i=-(n-1)/2:(n-1)/2
        for j=-(n-1)/2:(n-1)/2
            gf(j+(n+1)/2,i+(n+1)/2)=exp(-(i^2+j^2)/(2*sigma^2));
        end
    end

    gf=gf/sum(sum(gf));
end