function [idx] = QRSDetect(fileName,m, windowSize, alpha, gama)
  S = load(strcat("data/", fileName));
  ecg = S.val;
  
  % plot original signal
  plot(ecg(1,1:2500))
  
  % linear high-pass filtering stage
  L = size(ecg);
  yhp1 = zeros(L);
  yhp2 = zeros(L);
  
  % faster summation
  s = sum(ecg(:, 1:m), 2);
  
  for i=m:L(2)
      yhp1(:,i) = s / m;
      yhp2(:,i) = ecg(:, i-(m+1)/2);
      if i ~= L(2)
          s = s - ecg(:, i+1-m) + ecg(:, i+1);
      end
  end
  yhp = yhp2 - yhp1;
  
  % plot result after HPF
  hold on
  plot(yhp(1, 1:2500))
  
  % nonlinear low-pass filtering stage
  ylp1 = yhp.^2;
  ylp = zeros(L);
  for i=windowSize:L(2)
      ylp(:,i) = sum(ylp1(:,i+1-windowSize:i), 2);
  end
  
  % plot result after LPF
  figure 
  plot(ecg(1,1:2500))
  plot(ylp(1, 1:5000))
  
  y = sum(ylp, 1);
  
  % decision-making stage
  threWS = 100;     % windowsize for searching the local maximum
  idx = [];
  
  peak = max(y(1:threWS));
  threshold = peak;
  
  i = 1;
  while i+threWS < L(2)
      if y(i) > threshold
          [peak, index] = max(y(i:i+threWS));
          idx = [idx i+index];
          threshold = alpha * gama * peak + (1 - alpha) * threshold;
          i = i + index + 50;           % there can't be another heartbeat for at least 50 samples (max 300 hb in 1min)
      else
          i = i + 1;
      end
      if i > 400 && ~isempty(idx) && idx(end) < i - 400     % there wasn't a heartbeat detected for 400 samples --> reset the threshold
          peak = max(y(1:threWS));
          threshold = peak;
      end
  end
  
  % fixing the delay
  idx = idx - (m-1) - (windowSize-1);
  
  % plot the result
  figure
  plot(ecg(1,1:2500))  
  hold on 
  plot(idx(1:11), ecg(1, idx(1:11)), 'r*')
end
   
    