% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function s = regexpsafe(varargin)
s = varargin{1};
for i=2:nargin
   a = varargin{i};
   s=strrep(s,a,['\' a]); 
end

% s=strrep(s,'(','\(');
% s=strrep(s,')','\)');
% s=strrep(s,'|','\|');
% s=strrep(s,'^','\^');
% s=strrep(s,'$','\$');
% 
% s=strrep(s,'*','\*');
% s=strrep(s,'+','\+');
% s=strrep(s,'?','\?');

% replaces metacharacters in a string 's' with their ignored counterparts
% from help regexp:
%      Metacharacter   Meaning
%     ---------------  --------------------------------
%               ()     Group subexpression
%                |     Match subexpression before or after the |
%                ^     Match expression at the start of string
%                $     Match expression at the end of string
%               \<     Match expression at the start of a word
%               \>     Match expression at the end of a word
%  
%     The following metacharacters specify the number of times the previous
%     metacharacter or grouped subexpression may be matched:
%     
%      Metacharacter   Meaning
%     ---------------  --------------------------------
%                *     Match zero or more occurrences
%                +     Match one or more occurrences
%                ?     Match zero or one occurrence
%             {n,m}    Match between n and m occurrences
