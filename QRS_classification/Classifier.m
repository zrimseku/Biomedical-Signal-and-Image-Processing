function Classifier( record )

  fileName = sprintf('%sm.mat', record);
  t=cputime();
  [idx, count] = readannotations(record);
  if size(idx, 1) == 0
      fprintf('Empty %s', record)
      return
  end
  M = 31;
  N = 15;
  K = 10;
  beta = 0.05;
  type = QRSClassify(fileName, idx, M, N, K, beta, 0);
  fprintf('Running time: %f\n', cputime() - t);
  asciName = sprintf('mit-bih/%s.asc',record);
  fid = fopen(asciName, 'wt');
  for i=1:count
      ty = type(i, 2);
      if ty
          fprintf(fid,'0:00:00.00 %d V 0 0 0\n', type(i, 1));
      else
          fprintf(fid,'0:00:00.00 %d N 0 0 0\n', type(i, 1));
      end
  end
  fclose(fid);
end

