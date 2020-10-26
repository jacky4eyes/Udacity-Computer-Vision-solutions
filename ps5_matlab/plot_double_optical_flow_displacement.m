%%
% fig_hand = plot_optical_flow_displacement(n,U,V)
function fig_hand = plot_double_optical_flow_displacement(n,U1,V1,U2,V2)
    U1_min = min(min(U1));
    U1_max = max(max(U1));
    V1_min = min(min(V1));
    V1_max = max(max(V1));
    U2_min = min(min(U2));
    U2_max = max(max(U2));
    V2_min = min(min(V2));
    V2_max = max(max(V2));

    bottom = min(min(min(min(U1_min,V1_min)),U2_min),V2_min)
    top = max(max(max(U1_max,V1_max),U2_max),V2_max)

    fig_hand = figure(n);
    
    vl_tightsubplot(2,2,1,'Margin',0.06);
    imagesc(U1)
    caxis manual; caxis([bottom top]);colorbar('EastOutside');
    colormap(gca,jet(100))
    title('U1 map');

    vl_tightsubplot(2,2,2,'Margin',0.06);
    imagesc(V1)
    caxis manual; caxis([bottom top]);colorbar('EastOutside');
    colormap(gca,jet(100))
    title('V1 map');
    
    vl_tightsubplot(2,2,3,'Margin',0.06);
    imagesc(U2)
    caxis manual; caxis([bottom top]);colorbar('EastOutside');
    colormap(gca,jet(100))
    title('U2 map');

    vl_tightsubplot(2,2,4,'Margin',0.06);
    imagesc(V2)
    caxis manual; caxis([bottom top]);colorbar('EastOutside');
    colormap(gca,jet(100))
    title('V2 map');
    
    
end