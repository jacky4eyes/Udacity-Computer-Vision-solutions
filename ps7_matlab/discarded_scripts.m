
figure(2);

vl_tightsubplot(2,2,1);
histogram(abs(img1-img2),'BinLimits',[0,5e-2])

vl_tightsubplot(2,2,2);
histogram(abs(img1_fil-img2_fil),'BinLimits',[0,5e-2])
