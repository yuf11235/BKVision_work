%%
%
%  Summary:Torrance¨CSparrow Bidirectional Reflectance Distribution Function.
%
%  References:
%
% # <https://en.wikipedia.org/wiki/Bidirectional_reflectance_distribution_function#cite_note-torrance_1967-11>
% # K. Torrance and E. Sparrow. Theory for Off-Specular Reflection from Roughened Surfaces. J. Optical Soc. America, vol. 57. 1967. pp. 1105¨C1114.
%
% $$I=k_d cos\theta + k_s e^{-\displaystyle\frac{\theta_2^2}{2\sigma^2}}$$
%
% $$\theta=\gamma-\alpha,\theta_2=2\gamma-\alpha$$
% 
function I = BRDF_TS(gamma,alpha,k_d,k_s,sigma)
    I=k_d*cos(gamma-alpha)+k_s*(exp(-0.5*((2*gamma-alpha)/sigma).^2));
    I=abs(I);
end

