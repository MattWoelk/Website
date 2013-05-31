clc; clear; close all;
A = 20;
img1 = imread('image01.bmp');
imshow(img1);

figure%2
img2 = imread('imageTh01.bmp');
imshow(img2);

sizes = size(img2);

dat1 = zeros(sizes(1),sizes(2)); %matrix to display just the object
dat2 = zeros(sizes(1),sizes(2)); %matrix to display just the background
w1 = zeros(5382,1); %vector of object gray levels
w2 = zeros(5382,1); %vector of background gray levels
count1 = 1; %number of pixels in object
count2 = 1; %number of pixels in background


for x = 1:sizes(1)
    for y = 1:sizes(2)
       %if img2 shows 256, then add result to w1, else: w2.
       if img2(x,y) == 255
           dat1(x,y) = img1(x,y);
           w1(count1) = img1(x,y);
           count1 = count1 + 1;
           dat2(x,y) = 0;
       else
           dat2(x,y) = img1(x,y);
           w2(count2) = img1(x,y);
           count2 = count2 + 1;
           
           dat1(x,y) = 0;
       end
    end
end
t = 0:1:255;

figure%3
imshow(dat1,[0 255])
figure%4
imshow(dat2,[0 255])


n1 = hist(w1,256);
n2 = hist(w2,256);
nT = imhist(img1,256)';

figure%5
hold on;
hist(w1,256);
hist(w2,256);

figure%6
hold on;
bar(n1,'r')
bar(n2,'b')


%%%%%%%%%%%%%%%

totalnum = sizes(1) * sizes(2);
count1 = count1 - 1;
count2 = count2 - 1;

Pr1 = count1/totalnum
Pr2 = count2/totalnum

%%%%%%%%%%%%%%%

Pr1gx = [];
pr2gx = [];

for x = 1:256
    Prxg1(x) = n1(x)/count1;
    Prxg2(x) = n2(x)/count2;
end

figure%7
hold on;
plot(t,Prxg1);
plot(t,Prxg2);

%%%%%%%%%%%%%%%

%p = h/totalnum;

th = 0; %the threshold.

for i = 1:256
   if Prxg1(i) ~= 0
       if Prxg1(i)*Pr1 < Prxg2(i)*Pr2
         th = i;
         break
       end
   end
end

th

%%%%%%%%%%%%%%%

segobject = zeros(sizes(1),sizes(2));
segbackground = zeros(sizes(1),sizes(2));

for x = 1:sizes(1)
    for y = 1:sizes(2)
        if img1(x,y) > th
            segbackground(x,y) = img1(x,y);
        else
            segobject(x,y) = img1(x,y);
        end
    end
end

figure %8
imshow(segobject,[0 255]);
figure %9
imshow(segbackground,[0 255]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

























