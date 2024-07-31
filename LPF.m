function [hnL,n]=LPF(N,QCL,wn)
    nn=0:N/2-1;
    Low = sin(QCL.*(nn-N/2))./(pi.*(nn-N/2));
    hnL = Low.*wn(1:length(wn)-1);
    hnL(N/2+1) = QCL*wn(end)./pi;
    for i=N/2+2:N+1      
    wn(i) = wn(N+2-i);
    hnL(i) = hnL(N+2-i);
    end
    n=0:N;
end
