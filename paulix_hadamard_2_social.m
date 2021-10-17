function output = paulix_hadamard_2_social(userlist1,userlist2,type,diameter)

% social network user follow-back statistics

% use a scraper such as https://phantombuster.com/

% input two follow lists (or following/followers for same user) to find common users between follow lists

% input web-diameter variable to obtain a coarse measure of user relationship to web

% diameter = 0.35 + 2.06 * log(N)

% where N = # of webpages

% https://barabasi.com/f/65.pdf

% https://www.worldwidewebsize.com

% sample input:

% output = paulix_hadamard_2_social('kevin_following.csv','kevin_followers.csv',0,19);

if nargin ~= 4

	error('Please enter two user files, transform ordering type - 0 hadamard, 1 dyadic, default sequency, and web-diameter');

end

% power of twos table
p_two = [1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384,32768,65536,131072,262144,524288,1048576,2097152,4194304,8388608,16777216,33554432,67108864,134217728,268435456,536870912,1073741824,2147483648];

% read files
M = readcell(userlist1);
N = readcell(userlist2);

% generate hadamard vectors
w = length(M);
x = length(N);

% user list sizes
if w >= x

	q = w;

else

	q = x;
    
end

% set diameter of web
d = diameter;

% find transform size
for h = 1:length(p_two)

	if q < p_two(h)
	
		q0 = p_two(h);

        break;

    end

end

% init matrix
m = zeros(q0);
n = zeros(q0);

% copy vectors
M1 = cell(q0,1);
N1 = cell(q0,1);
output0 = cell(q0,1);
M1(1:w,1) = M(1:w,1);
N1(1:x,1) = N(1:x,1);

% fill matrices
for r = 1:q0

	for s = 1:q0

        if strcmpi(M1(r),N1(s))
                
        	m(r,s) = 1;
        	output(r) = M1(r);

		end
        
        if strcmpi(N1(r),M1(s))

            n(r,s) = 1;

        end

	end

end

%find common users
sum_m = sum(m,2);
for i = 1:q0

	if (sum_m(i) == 1)

		output0(i) = M1(i);

	end

end

% compute matrices
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

% plot
subplot(2,1,1);
plot(z*q);
subplot(2,1,2);
plot(q*z);

% output
output = output0(~cellfun('isempty',output0));

% common user count
a = size(output,1);

% statistics
p = (a/w);
l = (a/x);
r = p/l;
e = a/d;

% print stats
sprintf('%f common users',a)
sprintf('ratio common users to userlist1 = %f',p)
sprintf('ratio common users to userlist2 = %f',l)
sprintf('ratio of two ratios = %f',r)
sprintf('# of common users / diameter = %f',e)

end
