% Do a reflection in the fourier domain for a 2-dimensional signal

function xf_reflected = reflect_spectrum2(xf)

xf_reflected = circshift(flip(flip(xf, 1), 2), [1 1 0]);%circshift - 循环平移数组;flip - 翻转元素顺序