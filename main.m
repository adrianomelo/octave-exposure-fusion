function img = main()
    
    imgs = 0

    pasta = "img/test1/";
    imagens = dir(pasta);
    qnt = size(imagens,1) - 2;

    for i = 3:size(imagens, 1)
        if 0 == imagens(i).isdir
            printf('lendo imagem: %s\n', strcat(pasta, imagens(i).name));

            img = imread(strcat(pasta, imagens(i).name));

            printf('tamanho da imagem %d vs %d\n', size(img)(1), size(img)(2));
        
            if imgs == 0
                imgs = zeros(size(img)(1),size(img)(2), size(img)(3), qnt);
            end
        
            imgs(:,:,:,i-2) = img;
        end
    end

    img = fusion(imgs);
end
