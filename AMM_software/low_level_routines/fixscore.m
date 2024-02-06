function outstr = fixscore(instr)
% function outstr = fixscore(instr);
% escapes those pesky underscores so text commands don't subscript
%
ii = strfind(instr,'_');
outstr = instr;

if any(ii)
  for j = 1:length(ii);
    ii = strfind(outstr,'_');
    if(ii(j)==1)
       outstr=['\',outstr];
     else
       outstr=[outstr(1:ii(j)-1),'\',outstr(ii(j):end)];
     end
  end
end
