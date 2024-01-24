clear;
clc;
%TASK2.a
%Create symbolic variables
syms x F l b h E C1 C2

%Define My(x) and Iyy
Iyy = (b * h^3 / 12) * ((2 - x) / 1000);
My = F * (l - x);

w_double_prime = My / (E * Iyy);

%TASK.b
w_prime = int()




