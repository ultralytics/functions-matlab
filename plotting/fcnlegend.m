% Ultralytics 🚀 AGPL-3.0 License - https://ultralytics.com/license

function hl = fcnlegend(hf,alpha,type)
if nargin<3; type = 'normal';  end
hl = [];

if ~isgraphics(hf)
    alpha=hf;
    hf=gcf;
end

switch type
    case 'normal' %do nothing
    case 'unique' %plot only unique legend entries
        hd = findobj(hf,'-not','DisplayName','','-not','Type','axes');  n=numel(hd);
        dn = get(hd,'DisplayName');
        if n>1
            for i=1:n
                a=dn{i};
                if numel(a)>10 && all(a(1:6)=='getcol')
                    j=find(a==',',1,'last')-1;
                    dn{i} = a(11:j);
                end
            end
  
            [dn, i] = unique(dn);  [~,j]=sort(i,'descend');
            hl=legend(hd(i(j)),dn(j));
        elseif numel(hd)==1
            hl=legend(hd,dn);
        end
end

if alpha<1 %make existing legend transparent
    h1 = findobj(hf, 'Tag', 'legend');
    h2 = findobj(h1, 'Type', 'patch');
    set(h2,'FaceAlpha',alpha)
    set(h1,'EdgeColor',[1 1 1]*.7)
end
