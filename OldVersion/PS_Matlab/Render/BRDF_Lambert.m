%  References:
%
% # <https://en.wikipedia.org/wiki/Lambertian_reflectance>
% #  Ikeuchi, Katsushi (2014). "Lambertian Reflectance". Encyclopedia of Computer Vision. Springer. pp. 441¨C443. doi:10.1007/978-0-387-31439-6_534. ISBN 978-0-387-30771-8.
%
% $$I=k_d cos\theta$$
%
% $$\theta=\gamma-\alpha$$
% 
function I = BRDF_Lambert(gamma,alpha,k_d)
    I=k_d*cos(gamma-alpha);
    I=abs(I);
end

