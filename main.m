function img = main()

    conjunto = 'test2';
    pasta = strcat("img/", conjunto, "/");
    imagens = dir(pasta);
    qnt = size(imagens,1) - 2;
    
    imgs = zeros(480,640,3, qnt);
   % imgs = zeros(750,1500,3, qnt);

    for i = 3:size(imagens, 1)
        if 0 == imagens(i).isdir
            printf('lendo imagem: %s\n', strcat(pasta, imagens(i).name));

            img = imread(strcat(pasta, imagens(i).name));

            printf('tamanho da imagem %d vs %d\n', size(img)(1), size(img)(2));
        
            %if imgs == 0
            %    imgs = zeros(size(img)(1),size(img2), size(img)(3), qnt);
            %end
            
            imgs(:,:,:,i-2) = double(img) / 255;
        end
    end

    [cnt, sat, Exp, pesos, hdr] = fusion(imgs);
 
    imshow(hdr);
    nome = strcat('img-geradas/', conjunto, '/resultado.jpg');
    print(nome, '-djpg');
    
    for i = 1:qnt
        subplot(2,2,1);
        imshow(cnt(:,:,i));
        subplot(2,2,2);
        imshow(sat(:,:,i));
        subplot(2,2,3);
        imshow(Exp(:,:,i));
        subplot(2,2,4);
        imshow(imgs(:,:,:,i));

        nome = strcat('img-geradas/', conjunto, '/',int2str(i), '.jpg')
        print(nome, '-djpg')

        %imshow(pesos(:,:,i));
        %nome = strcat('img-geradas/', conjunto, '/lagoa.tudo', int2str(i), '.jpg')
        %print(nome, '-djpg');
    end
end
