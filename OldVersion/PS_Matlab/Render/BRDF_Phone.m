%%
%
%  Summary:Torrance¨CSparrow Bidirectional Reflectance Distribution Function.
%
%  References:
%
% # <https://en.wikipedia.org/wiki/Bidirectional_reflectance_distribution_function#cite_note-torrance_1967-11>
% # B. T. Phong, Illumination for computer generated pictures, Communications of ACM 18 (1975), no. 6, 311¨C317.
%
% $$I=k_d cos\theta + k_s cos^\xi \theta_2$$
%
% $$\theta=\gamma-\alpha,\theta_2=2\gamma-\alpha$$
% 
function I = BRDF_Phone(gamma,alpha,k_d,k_s,xi)
    I=k_d*cos(gamma-alpha)+k_s*(cos(2*gamma-alpha).^xi);
    I=abs(I);
end

