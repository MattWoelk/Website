clear; close all; clc;

images = ['image_0001.bmp';'image_0002.bmp';'image_0003.bmp';'image_0004.bmp';'image_0005.bmp';'image_0006.bmp';'image_0007.bmp';'image_0008.bmp';'image_0009.bmp';'image_0010.bmp'];
imagemap = ['image_0001GT.bmp';'image_0002GT.bmp';'image_0003GT.bmp';'image_0004GT.bmp';'image_0005GT.bmp';'image_0006GT.bmp';'image_0007GT.bmp';'image_0008GT.bmp';'image_0009GT.bmp';'image_0010GT.bmp'];
img1 = [];
img2 = [];

count1 = 0; %number of object pixels
count2 = 0; %number of background pixels

M = 0; %num of pixels.
sizes = []; %dimensions of image

means = [0,0,0,0,0,0,0,0,0,0];
stdevs = [0,0,0,0,0,0,0,0,0,0];
Pr1 = [0,0,0,0,0,0,0,0,0,0];
Pr2 = [0,0,0,0,0,0,0,0,0,0];

means1 = [0,0,0,0,0,0,0,0,0,0];
stdevs1 = [0,0,0,0,0,0,0,0,0,0];
means2 = [0,0,0,0,0,0,0,0,0,0];
stdevs2 = [0,0,0,0,0,0,0,0,0,0];


w1 = []; %the object data
w2 = []; %the background data

for num = 1:10
    %%ONCE FOR EACH IMAGE%%
    figure
    img1 = imread(images(num,1:end));
    img2 = imread(imagemap(num,1:end));
    
    
    h = imhist(img1);
    imhist(img1);
    
    sizes = size(img1);
    M = sizes(1)*sizes(2);
    
    means(num) = 0;
    for x = 0:255
       means(num) = means(num) + x*h(x+1); 
    end
    means(num) = 1/M*means(num);
    
    %stdevs
    stdevs(num) = 0;
    for x = 0:255
       stdevs(num) = stdevs(num) + h(x+1)*((x - means(num))^2);
    end
    stdevs(num) = stdevs(num)/M;
    stdevs(num) = stdevs(num)^0.5;
    
    
    count1 = 1;
    count2 = 1;
    for x = 1:sizes(1)    %go through and figure out how much space we need
        for y = 1:sizes(2)
            %if img2 shows 256, then add result to w1, else: w2.
            if img2(x,y) == 255
               count1 = count1 + 1;
            else
               count2 = count2 + 1;
            end
        end
    end
    w1 = linspace(0,0,count1);%pre-allocate space
    w2 = linspace(0,0,count2);
    count1 = 1;
    count2 = 1;
    for x = 1:sizes(1)
        for y = 1:sizes(2)
            %if img2 shows 256, then add result to w1, else: w2.
            if img2(x,y) == 255
               w1(count1) = img1(x,y);
               count1 = count1 + 1;
            else
               w2(count2) = img1(x,y);
               count2 = count2 + 1;
            end
        end
    end
    
    
    n1 = hist(w1,256);
    n2 = hist(w2,256);
    nT = imhist(img1,256)';
    
    totalnum = sizes(1) * sizes(2);
    count1 = count1 - 1;
    count2 = count2 - 1;

    Pr1(num) = count1/totalnum;
    Pr2(num) = count2/totalnum;
    
    Pr1gx = linspace(0,0,256); %pre-allocate space
    Pr2gx = linspace(0,0,256);

    for x = 1:256
        Prxg1(x) = n1(x)/count1; %#ok<AGROW>
        Prxg2(x) = n2(x)/count2; %#ok<AGROW>
    end
    
    
    
    %means
    means1(num) = 0;
    for x = 0:255
       means1(num) = means1(num) + x*Prxg1(x+1); 
    end
    means1(num) = 1/M*means1(num);
    
    %stdevs
    stdevs1(num) = 0;
    for x = 0:255
       stdevs1(num) = stdevs1(num) + Prxg1(x+1)*((x - means1(num))^2);
    end
    stdevs1(num) = stdevs1(num)/M;
    stdevs1(num) = stdevs1(num)^0.5;
    
    %means 
    means2(num) = 0;
    for x = 0:255
       means2(num) = means2(num) + x*Prxg2(x+1); 
    end
    means2(num) = 1/M*means2(num);
    
    %stdevs
    stdevs2(num) = 0;
    for x = 0:255
       stdevs2(num) = stdevs2(num) + Prxg2(x+1)*((x - means2(num))^2);
    end
    stdevs2(num) = stdevs2(num)/M;
    stdevs2(num) = stdevs2(num)^0.5;
    
    
    
    
end




%step 2!:

mavg1 = 0; %average of the means of the object
mavg2 = 0; %average of the means of the background
savg1 = 0; %average of the standard deviations of the object
savg2 = 0; %average of the standard deviations of the background
P1avg = 0; %average of the object probabilities
P2avg = 0; %average of the background probabilities

for x = 1:10
   mavg1 = mavg1 + means1(x);
   mavg2 = mavg2 + means2(x);
   savg1 = savg1 + stdevs1(x);
   savg2 = savg2 + stdevs2(x);
   P1avg = P1avg + Pr1(x);
   P2avg = P2avg + Pr2(x);
end






