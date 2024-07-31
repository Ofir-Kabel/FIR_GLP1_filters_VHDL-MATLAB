function [hnH,n]=HPF(N,QCH,wn)
    nn=0:N/2-1;
    High= -sin(QCH.*(nn-N/2))./(pi.*(nn-N/2));
    hnH = High.*wn(1:length(wn)-1);
    hnH(N/2+1) = 1-(QCH*wn(end)./pi);
    for i=N/2+2:N+1      
    wn(i) = wn(N+2-i);
    hnH(i) = hnH(N+2-i);
    end
    n=0:N;
end