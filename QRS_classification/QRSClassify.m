function type = QRSClassify(fileName, idx, M, N, K, beta, do_plot)
  close all;
  S = load(strcat("mit-bih/", fileName));
  ecg = S.val;
  
  if do_plot
      % plot original signal
      interval = 1:2500;
      plot(ecg(1, interval));
  end

  % nonlinear high-pass filtering stage
  L = size(ecg, 2);
  yb = zeros(L, 2);

  % trimmed moving average process
  f = zeros(M, 1);
  f(N+1:M-N) = 1/(M-2*N);

  for i=M:L
      for j=1:2
          T = sort(ecg(j, i-M+1:i));
          yb(i, j) = ecg(j, i-(M+1)/2) - T*f;
      end
  end
  
  if do_plot
      % plot result after NHPF
      hold on
      plot(yb(interval, 1))
  end
  
  % nonlinear low-pass filtering stage
  z = yb.^2;
  zb = zeros(L,2);
  for i=K:L
      zb(i, :) = sum(z(i+1-K:i, :), 1);
  end
  
  % sum of both transformed leads
  zb = sum(zb, 2);
  % zb = zb(:,1); % if you want to get results on only one lead
  
  if do_plot
      % plot result after LPF
      figure 
      plot(ecg(1, interval))
      plot(zb(interval, 1))
  end
  
  % pattern classification
  type = zeros(L, 2);
  
  if do_plot
      % plot detected heartbeats
      for i=idx(1:12, 1)
        hold on
        plot(i - interval(1), zb(i), 'r*')
      end
  end
  
  
  WS = 100;     % windowsize for searching the local maximum
  
  % set initial threshold - the smallest normal beat
  normal = [];
  for i = 1:min(20, size(idx, 1))
      if idx(i, 2) == 0
          peak = max(zb(max(1, idx(i,1)-50):idx(i,1)+50));
          normal = [normal peak];
      end
  end
  
  if length(normal) > 0
      threshold = min(normal);
  else
      threshold = max(zb(max(1, idx(1,1)-50):idx(1,1)+50)) * 2;
  end
 
  c = 0;
  for i=1:size(idx, 1)
      id = idx(i, 1); 
      c = c + 1;
      peak = max(zb(max(1, id-WS/2):min(L, id+WS/2)));
      if peak >= threshold
          type(c, :) = [id, 0];
          threshold = beta * 0.6 * peak + (1 - beta) * threshold;
      else
          type(c, :) = [id, 1];
      end
  end
 
  
end
   
    