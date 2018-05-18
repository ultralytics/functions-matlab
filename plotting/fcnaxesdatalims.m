function [mmx,mmy,mmz,mmc,x,y,z,c] = fcnaxesdatalims(h,sf) %sf=sigmaflag
nin = nargin;
if nin==0; h = gca; end
if nin<2; sf = false; end
n = numel(h);

srl = 6; %3.25 or 5 or 7 sigma rejection level
            
mmx=nan(n,2); mmy=mmx; mmz=mmx; mmc=mmx;
for i=1:n
    hi=h(i);    
    x = get(findobj(hi,'-depth',1,'-property','XData'),'Xdata');
    y = get(findobj(hi,'-depth',1,'-property','YData'),'Ydata');
    z = get(findobj(hi,'-depth',1,'-property','ZData'),'Zdata');
    
    a=findobj(hi.Children,'Type','histogram2');
    if ~isempty(a) %axes is histogram2
        x = [x;{[a.XBinEdges]}];
        y = [y;{[a.YBinEdges]}];
        c = a.Values;  c=c(c~=0);
    else
        c = get(findobj(hi,'-depth',1,'-property','CData'),'Cdata');
    end
    
    a=findobj(hi.Children,'Type','histogram','-not','Type','histogram2');
    if ~isempty(a) %axes is histogram2
        x = [x;{[a.BinEdges]}];
        y = [y;{[a.Values]}];
    end
    
    nx=numel(x);
    ny=numel(y);
    nz=numel(z);
    nc=numel(c);
    
    a = get(findobj(hi,'-depth',1,'-property','FaceVertexAlphaData'),'FaceVertexAlphaData'); na=numel(a);  if na==nc; try c=c(a>.1); nc=numel(c); catch; end; end; %ignore transparent patches with alpha < .1
    if (nx+ny+nz+nc)==0;  continue;  end
    
    if iscell(x)
        x = cellfun(@(x) x(:),x,'UniformOutput',false);  x=cat(1,x{:});
        y = cellfun(@(x) x(:),y,'UniformOutput',false);  y=cat(1,y{:});
    end
    if iscell(z)
        z = cellfun(@(x) x(:),z,'UniformOutput',false);  z=cat(1,z{:});
    end
    if iscell(c)
        c = cellfun(@(x) double(x(:)),c,'UniformOutput',false);  c=cat(1,c{:});
    end
    x=x(:); y=y(:); z=z(:); c=c(:);

    mmx(i,:)=oneAxis(x,sf,srl);
    mmy(i,:)=oneAxis(y,sf,srl);
    mmz(i,:)=oneAxis(z,sf,srl);
    mmc(i,:)=oneAxis(c,sf,srl);
end
end


function mm=oneAxis(v,sf,srl)
mm=[0 0];
if isempty(v); return; end
a=min(v); b=max(v);
if a==-inf || b==inf || sf
    v=v(isfinite(v));  
    if sf
        w=fcnsigmarejection(v,srl,3); if any(w); v=w; end; 
    end
    d=fcnminmax(v(:));
else
    d=[a b];
end
if numel(d)==2; mm=d; end;

end