function [CNT, SAT, EXP, pesos, HDR] = fusion(imgs)
    tam = size(imgs);

    printf('imagens: %d\n', tam(4));
    CNT = contraste(imgs);
    SAT = saturacao(imgs);
    EXP = exposicao(imgs);
   
    pesos = double(CNT).*double(SAT).*double(EXP);

    % normalização
    %soma_pesos = sum(pesos, 3);
    %for i = 1:size(pesos)(3)
    %    soma_pesos = soma_pesos + 0.00000001;
    %    pesos(:,:,i) = pesos(:,:,i)./soma_pesos;
    %end

    pesos = normalizar(pesos);

    piramide = piramide_glauciana(zeros(tam(1), tam(2), 3));
    for i = 1:tam(4)
        piramide_pesos = piramide_glauciana(pesos(:,:,i));
        piramide_imgs  = piramide_laplaciana(imgs(:,:,:,i));

        for l = 1:length(piramide)
            %piramide{l}(:,:,1) = piramide{l}(:,:,1) + piramide_pesos{l}.*piramide_imgs{l}(:,:,1);
            %piramide{l}(:,:,2) = piramide{l}(:,:,2) + piramide_pesos{l}.*piramide_imgs{l}(:,:,2);
            %piramide{l}(:,:,3) = piramide{l}(:,:,3) + piramide_pesos{l}.*piramide_imgs{l}(:,:,3);
            w = repmat(piramide_pesos{l}, [1 1 3]);
            a = w.*piramide_imgs{l};
            piramide{l} = piramide{l} + a;
        end
    end

    HDR = reconstruir_piramide_laplaciana(piramide);
    %HDR = normalizar(pesos);
end

function piramide = piramide_glauciana(img)
    filtro = [0,0625, 0.25, 0.375, 0.25, 0,0625];

    niveis = floor(log(min(size(img)) / log(2)));
    piramide = cell(niveis, 1);
    
    piramide{1} = img;
    for l = 2:niveis
        img = downsample(img, filtro);
        piramide{l} = img;
    end
end

function piramide = piramide_laplaciana(img)
    filtro = [0,0625, 0.25, 0.375, 0.25, 0,0625];

    niveis = floor(log(min(size(img)) / log(2)));
    piramide = cell(niveis, 1);

    img_temp = img;
    for l = 1:niveis - 1
        img = downsample(img_temp, filtro);
        tam = 2*size(img) - size(J);
        
        piramide{l} = img_temp - upsample(img, tam);
        
        img_temp = img;
    end
    piramide{niveis} = img_temp;
end

function matriz = normalizar(matriz)
    soma = sum(matriz, 3);
    for i = 1:size(matriz)(3)
        %soma = soma + 0.000000000000001;
        matriz(:,:,i) = matriz(:,:,i)./soma;
    end
end

function peso = contraste(imgs)
    laplaciano = [0 1 0; 1 -4 1; 0 1 0];

    t = size(imgs);
    peso = zeros(t(1), t(2), t(4));

    for i = 1:t(4)
        img_cinza = rgb2gray(imgs(:,:,:,i));
        peso(:,:,i) = imfilter(img_cinza, laplaciano,'replicate');
	    
        %peso(:,:,i) = peso_contraste
    end         
end

% Para cada imagem, 
function peso = saturacao(imgs)
    t = size(imgs);
    peso = zeros(t(1), t(2), t(4));

    for i = 1:t(4)
        img = imgs(:,:,:,i)
        
        r = img(:,:,1)
        g = img(:,:,2)
        b = img(:,:,3)
        media = (r + b + g) / 3.0

        peso_img = ((r - media).^2 + (g - media).^2 + (r - media).^2) / 3.;
        peso(:,:,i) = sqrt(peso_img);
    end
end

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
end

function m = upsample(img, tam)
    filtro = [0,0625, 0.25, 0.375, 0.25, 0,0625];

    img = padarray(img, [1 1 0], 'replicate');
    
    linha = 2 * size(img, 1);
    coluna = 2 * size(img, 2);
    qnt = size(img, 3);

    matriz = zeros(linha, coluna, qnt);
    matriz(1:2:linha, 2:1:coluna,:) = 4 * img;

    matriz = imfilter(img, filtro);
    matriz = imfilter(img, filtro');

    matriz = matriz(3:coluna - 2 - tam(1), 3:coluna - 2 - tam(2), :);
end

function m = downsample(img)
    filtro = [0,0625, 0.25, 0.375, 0.25, 0,0625];

    m = imfilter(img, filtro, 'symmetric');
    m = imfilter(m, filtro', 'symmetric');

    linha = size(img, 1);
    coluna = size(img, 2);
    m = m(1:2:linha, 1:2:coluna, :);
end

function m = reconstruir_piramide_laplaciana(piramide)
    filtro = [0,0625, 0.25, 0.375, 0.25, 0,0625];
    
    m = piramide{length(piramide)};

    for l = length(piramide) - 1: -1 : 1
        tam = 2 * size(m) - size(piramide{l});
        m = piramide{l} + upsample(m, tam, filtro);
    end
end


% Algoritmo de construção da pirâmide (Gonzalez, 308)

% O procedimento de tres passos a seguir é executado P vezes, para j = J, J-1, ... e J-P+1:

    % Passo 1: Calcule uma aproximação de resolução reduzida da imagem de entrada de nível j.
    % Isso é feito pela filtragem e subamostragem (downsampling) do resultado filtrado por um fator de 2.
    % Posicione a aproximação resultante no nível j-1 da pirâmide de aproximação.

    % Passo 2: Crie uma estimativa da imagem de nível j a partir da aproximação de resolução reduzida gerana no passo 1.
    % Isso é feito pela superamostragem (upsampling) e filtragem da aproximação gerada.
    % A imagem preditiva resultante terá as mesmas dimensões que a imagem de entrada de nível j.

    % Passo 3: Calcule a diferença entre a imagem preditiva do passo 2 e a entrada do passo 1. 
    % Coloque esse resultado no nível j da pirâmide de residual de previsão.

% No final das P repetições (isto é, após a iteração na qual j = J - P + 1), a seída da aproximação de nível J - P
%  é colocada na pirâmide de residual de previsão no nível J - P.
