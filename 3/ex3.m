n = length(u);

a = [
    u(3:n-1)'*u(3:n-1), u(3:n-1)'*u(2:n-2), u(3:n-1)'*u(1:n-3);
    u(2:n-2)'*u(3:n-1), u(2:n-2)'*u(2:n-2), u(2:n-2)'*u(1:n-3);
    u(1:n-3)'*u(3:n-1), u(1:n-3)'*u(2:n-2), u(1:n-3)'*u(1:n-3);
];

b = -[
    u(3:n-1)'*u(4:n);
    u(2:n-2)'*u(4:n);
    u(1:n-3)'*u(4:n);
];

theta = inv(a) * b;

phi = -[
    u(3:n-1), u(2:n-2), u(1:n-3)
];

Y = u(4:n);

theta2 = phi\Y;

pinv_phi = pinv(phi);

theta3 = pinv_phi * Y;



%%
phi2 = [
    -y(2:n-1), -y(1:n-2), u(2:n-1), u(1:n-2)
];

Y2 = y(3:n);

theta4 = phi2 \ Y2;