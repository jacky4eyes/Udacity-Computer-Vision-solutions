%%
% fig_hand = plot_optical_flow_displacement(n,U,V)
function fig_hand = plot_optical_flow_displacement(n,U,V)
    U_min = min(min(U));
    U_max = max(max(U));
    V_min = min(min(V));
    V_max = max(max(V));
    bottom = min(U_min,V_min)
    top = max(U_max,V_max)

    fig_hand = figure(n);
    vl_tightsubplot(2,1,1,'Margin',0.06);
    imagesc(U)
    caxis manual; caxis([bottom top]);colorbar('EastOutside');
    colormap(gca,jet(100))
    title('U map');

    vl_tightsubplot(2,1,2,'Margin',0.06);
    imagesc(V)
    caxis manual; caxis([bottom top]);colorbar('EastOutside');
    colormap(gca,jet(100))
    title('V map');
end