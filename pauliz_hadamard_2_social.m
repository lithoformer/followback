function [m,n,z,q] = pauliz_hadamard_2_social(user1,user2,type,diameter)

%computes social network user follow list Hadamard transform in Pauli-Z space

if nargin ~= 4

	error('Please enter two user files, transform ordering type - 0 for hadamard, 1 for dyadic, default is sequency');

end

%power of twos table
p_two = [1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384,32768,65536,131072,262144,524288,1048576,2097152,4194304,8388608,16777216,33554432,67108864,134217728,268435456,536870912,1073741824,2147483648];

%read files
M = readcell(user1);
N = readcell(user2);

%generate hadamard vectors
w = length(M);

x = length(N);

%user list sizes
if w >= x

	q = w;

else

	q = x;
    
end

d = diameter;

%find transform size
for h = 1:length(p_two)

	if q < p_two(h)
	
		q0 = p_two(h);

        break;

    end

end

%init matrix
m = zeros(q0);
n = zeros(q0);

%copy vectors
M1 = cell(q0,1);
N1 = cell(q0,1);
M1(1:w,1) = M(1:w,2);
N1(1:x,1) = N(1:x,2);

%fill matrices
for r = 1:q0

	for s = 1:q0

        if strcmpi(M1(r),N1(s))
                
        	m(r,s) = 1;

        else

			m(r,s) = 0;

		end
        
        if strcmpi(N1(r),M1(s))

            n(r,s) = 1;

        else

			n(r,s) = 0;

        end

	end

end

%compute matrices
switch type

	case 0

	z = fwht(m,q0,'hadamard');
	q = fwht(n,q0,'hadamard');

	case 1

	z = fwht(m,q0,'dyadic');
	q = fwht(n,q0,'dyadic');

	otherwise

	z = fwht(m,q0,'sequency');
	q = fwht(n,q0,'sequency');

end

%plot
subplot(2,1,1);
plot(z*q);
subplot(2,1,2);
plot(q*z);

z = sum(m);
a = sum(z);

p = (a/w);
l = (a/x);
r = p/l;

%d = a/50; % d = 50 (Barabasi 1999)

disp(a);
disp(p);
disp(l);
disp(r);
disp(a/d);

end