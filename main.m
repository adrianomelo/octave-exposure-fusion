
i1 = imread("img/test1.jpg");
i2 = imread("img/test2.jpg");
i3 = imread("img/test3.jpg");
i4 = imread("img/test4.jpg");
i5 = imread("img/test5.jpg");

imgs = zeros([size(i1), 5]);

imgs(:,:,:,1) = i1;
imgs(:,:,:,2) = i2;
imgs(:,:,:,3) = i3;
imgs(:,:,:,4) = i4;
imgs(:,:,:,5) = i5;

IMG = ef(imgs);

imshow(IMG);

