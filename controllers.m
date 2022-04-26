% Tecnológico de Monterrey
% Computerized Control
% Homework 4 - Controllers Design
% 3 Controllers: Deadbit, Dahlin and Kalman

% Predefined values
clc;

% Sampling Time = 1 second
T = 1;
% 100 Iterations
n = 100;
% Input is a unitary step
r = ones(size(1:n));

% Tuning Value of Tao (Only applies for Dahlin)
tao = 0.65;

% -------------------------------------------------

% 1 - Deadbit Controller

% Initial Values

c(1) = 0;
e(1) = r(1) - c(1);
m(1) = 0;

c(2) = 0.822 * c(1);
e(2) = r(2) - c(2);
m(2) = 13.2625 * e(1) - 1.3594 * m(1);

c(3) = 0.822 * c(2);
e(3) = r(3) - c(3);
m(3) = 13.2625 * e(2) - 10.9018 * e(1) - 1.3594 * m(2);

c(4) = 0.822 * c(3);
e(4) = r(4) - c(4);
m(4) = 13.2625 * e(3) - 10.9018 * e(2) - 1.3594 * m(3);

c(5) = 0.0754 * m(1) + 0.822 * c(4);
e(5) = r(5) - c(5);
m(5) = 13.2625 * e(4) - 10.9018 * e(3) - 1.3594 * m(4);

c(6) = 0.0754 * m(2) + 0.1025 * m(1) + 0.822 * c(5);
e(6) = r(6) - c(6);
m(6) = 13.2625 * e(5) - 10.9018 * e(4) - 1.3594 * m(5) + m(1);

% Loop

for k=7:1:n
    c(k) = 0.0754 * m(k-4) + 0.1025 * m(k-5) + 0.822 * c(k-1);
    e(k) = r(k) - c(k);
    m(k) = 13.2625 * e(k-1) - 10.9018 * e(k-2) - 1.3594 * m(k-1) + m(k-5) + 1.3594 * m(k-6);
end

t = 1*(1:n);
figure(1);
subplot(3,1,1),plot(t,r,'m',t,c,'b--');
xlabel('Iterations');
ylabel('Output');
legend({'r(k)','c(k)'},'Location','southeast')
title('Deadbit Controller - Output Response');
subplot(3,1,2),plot(t,m,'b');
xlabel('Iterations');
ylabel('Output');
legend({'m(k)'},'Location','southeast')
title('Deadbit Controller - Controller Signal');
subplot(3,1,3),plot(t,e,'r');
xlabel('Iterations');
ylabel('Output');
legend({'e(k)'},'Location','southeast')
title('Deadbit Controller - Error Signal');



% -----------------------------------------------

% 2 - Dahlin Controller

% Initial Values

c(1) = 0;
e(1) = r(1) - c(1);
m(1) = 0;

c(2) = 0.822 * c(1);
e(2) = r(2) - c(2);
m(2) = (1 - exp(-T/tao)) * e(1) - (-0.0754 * exp(-T/tao) + 0.1025) * m(1);

c(3) = 0.822 * c(2);
e(3) = r(3) - c(3);
m(3) = (1 - exp(-T/tao)) * e(2) + (-0.822 + 0.822 * exp(-T/tao)) * e(1) - (-0.0754 * exp(-T/tao) + 0.1025) * m(2) + (0.1025 * exp(-T/tao)) * m(1);

c(4) = 0.822 * c(3);
e(4) = r(4) - c(4);
m(4) = (1 - exp(-T/tao)) * e(3) + (-0.822 + 0.822 * exp(-T/tao)) * e(2) - (-0.0754 * exp(-T/tao) + 0.1025) * m(3) + (0.1025 * exp(-T/tao)) * m(2);

c(5) = 0.0754 * m(1) + 0.822 * c(4);
e(5) = r(5) - c(5);
m(5) = (1 - exp(-T/tao)) * e(4) + (-0.822 + 0.822 * exp(-T/tao)) * e(3) - (-0.0754 * exp(-T/tao) + 0.1025) * m(4) + (0.1025 * exp(-T/tao)) * m(3);

c(6) = 0.0754 * m(2) + 0.1025 * m(1) + 0.822 * c(5);
e(6) = r(6) - c(6);
m(6) = (1 - exp(-T/tao)) * e(5) + (-0.822 + 0.822 * exp(-T/tao)) * e(4) - (-0.0754 * exp(-T/tao) + 0.1025) * m(5) + (0.1025 * exp(-T/tao)) * m(4) - (0.0754 * exp(-T/tao) - 0.0754) * m(1);

% Loop

for k=7:1:n
    c(k) = 0.0754 * m(k-4) + 0.1025 * m(k-5) + 0.822 * c(k-1);
    e(k) = r(k) - c(k);
    m(k) = (1 - exp(-T/tao)) * e(k-1) + (-0.822 + 0.822 * exp(-T/tao)) * e(k-2) - (-0.0754 * exp(-T/tao) + 0.1025) * m(k-1) + (0.1025 * exp(-T/tao)) * m(k-2) - (0.0754 * exp(-T/tao) - 0.0754) * m(k-5) - (0.1025 * exp(-T/tao) - 0.1025) * m(k-6);
end

figure(2);
subplot(3,1,1),plot(t,r,'m',t,c,'b--');
xlabel('Iterations');
ylabel('Output');
legend({'r(k)','c(k)'},'Location','southeast')
title('Dahlin Controller - Output Response');
subplot(3,1,2),plot(t,m,'b');
xlabel('Iterations');
ylabel('Output');
legend({'m(k)'},'Location','southeast')
title('Dahlin Controller - Controller Signal');
subplot(3,1,3),plot(t,e,'r');
xlabel('Iterations');
ylabel('Output');
legend({'e(k)'},'Location','southeast')
title('Dahlin Controller - Error Signal');



% -----------------------------------------------

% 3 - Kalman Controller

% Initial Values

c(1) = 0;
e(1) = r(1) - c(1);
m(1) = 5.6211 * e(1);

c(2) = 0.822 * c(1);
e(2) = r(2) - c(2);
m(2) = 5.6211 * e(2) - 4.6205 * e(1);

c(3) = 0.822 * c(2);
e(3) = r(3) - c(3);
m(3) = 5.6211 * e(3) - 4.6205 * e(2);

c(4) = 0.822 * c(3);
e(4) = r(4) - c(4);
m(4) = 5.6211 * e(4) - 4.6205 * e(3);

c(5) = 0.0754 * m(1) + 0.822 * c(4);
e(5) = r(5) - c(5);
m(5) = 5.6211 * e(5) - 4.6205 * e(4) + 0.4238 * m(1);

% Loop

for k=6:1:n
    c(k) = 0.0754 * m(k-4) + 0.1025 * m(k-5) + 0.822 * c(k-1);
    e(k) = r(k) - c(k);
    m(k) = 5.6211 * e(k) - 4.6205 * e(k-1) + 0.4238 * m(k-4) + 0.5761 * m(k-5);
end

figure(3);
subplot(3,1,1),plot(t,r,'m',t,c,'b--');
xlabel('Iterations');
ylabel('Output');
legend({'r(k)','c(k)'},'Location','southeast')
title('Kalman Controller - Output Response');
subplot(3,1,2),plot(t,m,'b');
xlabel('Iterations');
ylabel('Output');
legend({'m(k)'},'Location','southeast')
title('Kalman Controller - Controller Signal');
subplot(3,1,3),plot(t,e,'r');
xlabel('Iterations');
ylabel('Output');
legend({'e(k)'},'Location','southeast')
title('Kalman Controller - Error Signal');

