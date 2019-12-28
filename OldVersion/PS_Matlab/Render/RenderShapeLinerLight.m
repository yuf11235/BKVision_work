%%
%
%  Summary:Render shape under liner light
%
%  References:
%
% # <https://en.wikipedia.org/wiki/Gabor_filter>
% # <https://en.wikipedia.org/wiki/Gaussian_function>
% # <https://jingyan.baidu.com/article/5bbb5a1bedf94413eba179ba.html>
%
% $$z(x,y)=\frac{1}{2\pi \sigma_x \sigma_y}\cdot e^{-\left [ \frac{(x-x_0)^2}{2\sigma_x ^2} + \frac{(y-y_0)^2}{2\sigma_y ^2}\right ]}$$
% 
% $$A = \frac{1}{2\pi \sigma_x \sigma_y}$$
% 
% $$z(x,y)=A\cdot e^{-\left [ a(x-x_0)^2 + 2b(x-x_0)(y-y_0) + c(y-y_0)^2 \right ]}$$
% 
% $$a=\frac{cos^2\theta }{2\sigma _x^2}+\frac{sin^2\theta }{2\sigma _y^2}$$
% 
% $$b=\frac{cos\theta sin\theta}{2\sigma _x^2}+\frac{cos\theta sin\theta}{2\sigma _y^2}$$
% 
% $$c=\frac{sin^2\theta }{2\sigma _x^2}+\frac{cos^2\theta }{2\sigma _y^2}$$
%
% $$p(x,y)=\frac{\partial z(x,y)}{\partial x} = -2z(x,y) \cdot \left[ a(x-x_0)+b(y-y_0) \right]$$
%
% $$q(x,y)=\frac{\partial z(x,y)}{\partial y} = -2z(x,y) \cdot \left[ b(x-x_0)+c(y-y_0) \right]$$

function I = RenderShapeLinerLight(C,Q,Gamma_func)
%UNTITLED2 Summary of this function goes here,Light
%   Detailed explanation goes here,depthMat
    C=double(C);
    Gamma=atan(Q);
    I=C.*Gamma_func(Gamma);
end
