function o_p2B(I)

format long g;
format compact;
workspace;
captionFontSize = 14;
treshold = 0.64;
area = 15;
contor = 0;

  % Plotare imagine originala
  
subplot(3, 3, 1)
imshow(I);
set(gcf, 'units', 'normalize', 'outerposition', [0 0 1 1]);
drawnow;
title('Original Image', 'FontSize', captionFontSize);
axis image;

  % Conv in imagine gri 
greyImage = rgb2gray(I);

  % Binarizare imagine dupa pragul stabilit + compactificare

binaryImage = imbinarize(greyImage, treshold);
binaryImage = imfill(binaryImage, 'holes');

  % Strel
  
SEcc = strel('square', 2);
binaryImage = imdilate(binaryImage, SEcc);

  % Plotare imagine binara
  
subplot(3, 3, 2)
imshow(binaryImage);
title('Binary Image', 'FontSize', captionFontSize);

  % Plotare imagine gri cu contururi pt sursele de caldura

subplot(3, 3, 3);
imshow(greyImage);
title('Outlines', 'FontSize', captionFontSize); 
axis image; 
hold on;

   % Detecteaza nr de surse de caldura
   
boundaries = bwboundaries(binaryImage);
blobMeasurements = regionprops(binaryImage, greyImage, 'Area', 'Centroid');
numberOfBlobs = size(blobMeasurements, 1);
n = numel(blobMeasurements);

   % Adaugare contururi pentru fiecare sursa de caldura
   
for k = 1 : n
    
     b = boundaries{k};
     v = blobMeasurements(k);
     plot(b(:,2), b(:,1), 'g', 'LineWidth', 2)
     if v.Area > area
     plot(v.Centroid(1), v.Centroid(2), 'r*')
     end
    
end
hold off;

  % Selectare corpuri cu aria mai mare decat cea prestabilita
  
for k = 1 : numberOfBlobs
    
    if blobMeasurements(k).Area > area
        contor = contor + 1;
    end
    
end

  % Strel
  
SEc = strel('square', 5);
binaryImage = imdilate(binaryImage, SEc);
%subplot(3, 3, 4)
%imshow(binaryImage)
%title('Binary Image strel', 'FontSize', captionFontSize);

  % Elimina formele cu aria mare, ie cele deja numarate
  
BW2 = bwareafilt(binaryImage,[5 15]);
%subplot(3, 3, 5)
%imshow(BW2)
%title('Binary Image ss', 'FontSize', captionFontSize);

  % Plotare corpuri mici cu contururi
  
%subplot(3, 3, 6);
%imshow(BW2);
%title('Outlines ss', 'FontSize', captionFontSize); 
%axis image; 
%hold on;

   % Detecteaza nr surselor mici de caldura
   
boundaries2 = bwboundaries(BW2);
numberOfBoundaries2 = size(boundaries2, 1);
 

    %Adaugare contururi pentru fiecare sursa mica de caldura
    
for k = 1 : numberOfBoundaries2
    
    thisBoundary2 = boundaries2{k};
     %plot(thisBoundary2(:,2), thisBoundary2(:,1), 'g', 'LineWidth', 2);
    
end
hold off;

    % Maresc sursele mici de caldura

SE = strel('square',5);
BW3 = imdilate(BW2, SE);
%subplot(3, 3, 7)
%imshow(BW3)
%title('Outlines ss strel', 'FontSize', captionFontSize);
%hold on;

    % Aplic algoritmul pentru sursele mici pe care le am marit anterior
    
boundaries3 = bwboundaries(BW3);
numberOfBoundaries3 = size(boundaries3, 1);
blobMeasurements3 = regionprops(BW3);
numberOfBlobs3 = size(blobMeasurements3, 1);

   % Adaugare contururi pentru fiecare sursa de caldura
   
for k = 1 : numberOfBoundaries3
    
    thisBoundary3 = boundaries3{k};
    plot(thisBoundary3(:,2), thisBoundary3(:,1), 'g', 'LineWidth', 2);
    if blobMeasurements3(k).Area > area
        plot(blobMeasurements3(k).Centroid(1), blobMeasurements3(k).Centroid(2), 'r*')
    end
    
end
hold off;

  % Selectare corpuri cu aria mai mare decat cea prestabilita
  
for k = 1 : numberOfBlobs3
    
    if blobMeasurements3(k).Area > area
        contor = contor + 1;
    end
    
end

subplot(3, 3, 8)
whiteImage = 255 * ones(10, 15, 'uint8');
imshow(whiteImage);
hold on;
myText = sprintf('%d', contor);
text(5.5, 6, myText, 'FontSize', 100);
axis off;
hold off;

% fprintf('Numarul oamenilor este %d\n\n', contor);
