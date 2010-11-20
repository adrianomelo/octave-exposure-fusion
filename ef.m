

function IMG = ef(imgs)
    printf("imagens: '%d'", size(imgs)(4));

    %pesos = contraste(imgs)



    IMG = imgs(:,:,:,1)
endfunction



function peso_contraste = contraste(imgs)
    laplaciano = [0 1 0; 1 -4 1; 0 1 0];

    t = size(imgs);
    peso_contraste = zeros(t(1), t(2), t(4));

    for i = 1:t(4)
        img_cinza = rgb2gray(imgs(:,:,:,i));
        peso_contraste = abs(imfilter(img_cinza, laplaciano,'replicate');
endfunction


function peso = saturacao(imgs)
    t = size(imgs);
    peso = zeros(t(1), t(2), t(4));

    for i = 1:t(4)
        %img = imgs(:,:,:,i);
        %media = (img(:,:,1) + img(:,:,2) + img(:,:,3)/3;

        r = img(:,:,1)
        g = img(:,:,2)
        b = img(:,:,3)
        media = (r + b +g)/3

        peso_img = ((r - media).^2 + (g - media).^2 + (r - media).^2) / 3;
        peso(:,:,i) = sqrt(peso_img);
    end
endfunction

function peso = exposicao(imgs)
    t = size(imgs);
    peso = zeros(t(1), t(2), t(4));

    for i = 1:size(imgs,4)
        r_img = imgs(:,:,1,i);
        g_img = imgs(:,:,2,i);
        b_img = imgs(:,:,3,i);

        r = exp(-1 * (r_img - 0.5).^2 / (2 * 0.2.^2));
        g = exp(-1 * (g_img - 0.5).^2 / (2 * 0.2.^2));
        b = exp(-1 * (b_img - 0.5).^2 / (2 * 0.2.^2));

        peso_img = r .* g .* b;

        peso(:,:,i) = peso_img;
    end

endfunction
