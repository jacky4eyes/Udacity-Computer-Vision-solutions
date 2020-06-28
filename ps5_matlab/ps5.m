%% ps5
%
%%
clc;
img = imread(fullfile('input', 'ps5-input0.png'));  % already grayscale
% [img_edges, threshOut]  = edge(img,'canny',0.1,0.01);
figure(1)
subplot(2,2,1)
imshow(img);

%% projection testing

clear
flow_angle = pi/2;
z = 0.45;
theta = -pi/4;


f1 = [-sin(theta);cos(theta);0];
f2 = [cos(theta);sin(theta);-tan(z)];
A = [f1 f2];
P = A/(A'*A)*A';
P_new = P(:,:);
P_new(:,3) = 1;

f1 = f1/norm(f1)*cos(-flow_angle + pi/2 + theta);
f2 = f2/norm(f2)*sin(-flow_angle + pi/2 + theta);
invP = inv(P_new);
V = invP*(f1+f2)
atan2(V(2),V(1))/pi*180

%%
% x = [sin(z)*cos(phi);sin(z)*sin(phi);cos(z)];
% n = [sin(z)*cos(theta);sin(z)*sin(theta);cos(z)];
% m = [0,0,1];
% n = n/norm(n);
% m = m/norm(m);
% v = v/norm(v);
% F = F/norm(F);
% f2 = [-sin(theta)/tan(z);cos(theta)/tan(z);-sin(phi)*cos(theta)+cos(phi)*sin(theta)];

% v = [-0.6832;2.0575;0];
% v = [0.1179;1.2795;-0.0000];
v = V;
F = P*v
FF = f1+f2
%%
figure(2);
grid();
hold on
plot3([0,m(1)],[0,m(2)],[0,m(3)],'color','red');
plot3([0,n(1)],[0,n(2)],[0,n(3)],'color','magenta');
% plot3([0,x(1)],[0,x(2)],[0,x(3)]);
plot3([0,f1(1)],[0,f1(2)],[0,f1(3)],'color','blue');
plot3([0,f2(1)],[0,f2(2)],[0,f2(3)],'color','green');
% legend([1,2,3,4]);
plot3([0,v(1)],[0,v(2)],[0,v(3)],'color','yellow')
plot3([0,F(1)],[0,F(2)],[0,F(3)],'color','black')

hold off

