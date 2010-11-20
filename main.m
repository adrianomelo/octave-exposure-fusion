
i1 = imread("test1.jpg");
i2 = imread("test2.jpg");
i3 = imread("test3.jpg");
i4 = imread("test4.jpg");
i5 = imread("test5.jpg");

imgs = zeros([size(i1), 5]);

imgs(:,:,:,1) = i1;
imgs(:,:,:,2) = i2;
imgs(:,:,:,3) = i3;
imgs(:,:,:,4) = i4;
imgs(:,:,:,5) = i5;

IMG = ef(imgs);

imshow(IMG);

