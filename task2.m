clear;

syms x C1 C2 F l h b E u_c u_h u_F g_V
Iyy = ((b * h^3) / (12)) * ((2) - ((x)/(1000)));
My = F * (l - x);
w_dd = My / (E * Iyy);
w_prime = int(w_dd,x)+C1;

eq1 = subs(w_prime,x,0) == 0;
solution1 = solve(eq1,C1);
w_prime = subs(w_prime,C1,solution1);

w = int(w_prime,x)+C2;
eq2 = subs(w,x,0) == 0;
solution2 = solve(eq2,C2);
w = subs(w,C2,solution2);

xVector = 0:1000;
length_beam = 1000; % mm
force_F = 1000; % N
beam_height = 25; % mm
beam_width = 15; % mm
E_modulus = 1e9*1e-6; % Pa (GPa to Pa conversion)
Uncertain_force = 50; %N
Uncertain_beam = 1.5; %mm

% given_quantities = struct('F', force_F, 'l', length_beam, 'h', beam_height, 'b', beam_width, 'E', E_modulus);
% Iyy1 = ((b * h^3) / (12)) * ((2) - ((x)/(1000)));
% 
% % Define the symbolic variable for w(x)
% syms x
% My = given_quantities.F * (given_quantities.l - x);
% w_symbolic = int(My / (given_quantities.E * Iyy), x) + C1;

solutions= struct();
solutions.('w_x')= subs(w,{F E h b l},{force_F E_modulus beam_height beam_width length_beam});
f = matlabFunction(solutions.('w_x'));
solutions.('w_b')=real(f(xVector));

u_c= sqrt((diff(w,F)*Uncertain_force)^2+(diff(w,h)*Uncertain_beam)^2);
% needed_quantities = {('F'),('l'),('h'), ('b'), ('E')};
f = matlabFunction(u_c);
solutions.('u_c') = f(E_modulus,force_F,beam_width,beam_height,length_beam,xVector);
figure
hold on
P1 = plot(xVector,solutions.w_b,'b');
P2 = plot(xVector,solutions.w_b + solutions.u_c,'r');
P3 = plot(xVector,solutions.w_b - solutions.u_c,'r');

% Task 1: Generate random numbers for F and h
numSamples = 1000;
random_F = force_F + Uncertain_force * randn(1, numSamples);
random_h = beam_height + Uncertain_beam * randn(1, numSamples);

% Task 2: Convert the symbolic expression to a function
w_function = matlabFunction(w);

% Task 3: Calculate bending at the point of maximum deflection
x_max_deflection = 1000;
results = zeros(1, numSamples);
for i = 1:numSamples
    results(i) = real(w_function(random_F(i), E_modulus, random_h(i), beam_width, length_beam, x_max_deflection));
end

% Task 4: Prepare plots
figure;
subplot(3, 2, 1);
histogram(random_F);
title('Distribution of Force (F)');

subplot(3, 2, 2);
histogram(random_h);
title('Distribution of Beam Height (h)');

subplot(3, 2, 3);
histogram(results);
title('Distribution of Deflection at x = 1000');

% Task 5: Repeat the procedure with a larger number of random numbers
numSamples2 = 1e6;
random_F2 = force_F + Uncertain_force * randn(1, numSamples2);
random_h2 = beam_height + Uncertain_beam * randn(1, numSamples2);

results2 = zeros(1, numSamples2);
for i = 1:numSamples2
    results2(i) = real(w_function(random_F2(i), E_modulus, random_h2(i), beam_width, length_beam, x_max_deflection));
end

subplot(3, 2, 4);
histogram(random_F2);
title('Distribution of Force (F) - More Samples');

subplot(3, 2, 5);
histogram(random_h2);
title('Distribution of Beam Height (h) - More Samples');

subplot(3, 2, 6);
histogram(results2);
title('Distribution of Deflection at x = 1000 - More Samples');