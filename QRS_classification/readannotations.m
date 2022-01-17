function [beats, count] = readannotations(file)
  % example use which returns table and number of heart beats
  % [beats, count] = readannotations('100');
  
  beats = []; count = 0;
  
%  fid = fopen(sprintf('ltstdb/%s.txt', file));
  fid = fopen(sprintf('mit-bih/%s.txt', file));
  
  while (~feof(fid))
    count = count + 1;
    line = fgetl(fid);
    line_split = split(strtrim(line));
    if length(line_split) == 6
        z = textscan(line, '%s %d %s %d %d %d');
        idx = z{2};
        ztype = z{3}{1};
    else
        z = textscan(line, '%s %s %d %s %d %d %d');
        idx = z{3};
        ztype = z{4}{1};
    end
    if (strcmp(ztype,'N')) 
      typ = 0;            % normal (N) heart beats will be returned as 0
    else 
      typ = 1;            % PVC (V) heart beats will be returned as 1
    end
    
    % add row to heart beat matrix that will be returned
    beats = [beats; [idx,typ]];    
  end
  
  % close the input file
  fclose(fid);
end
