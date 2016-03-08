# tesseract-mapillary

Numa discussão na lista OSM Brasil no Telegram, aventou-se a possibilidade de importar para o Mapillary vídeos de motoristas dirigindo no YouTube, após pedir autorização aos autores. Após mandarmos algumas mensagens, um dos usuários a [autorizar a importação de seus vídeos](http://i.imgur.com/Su6V4Q5.png) foi o [Everton Silva](https://www.youtube.com/user/evertonsilva1986/videos). Seus vídeos tem uma camada mostrando a latitude e longitude, o que possibilita a geolocalização das imagens.

Para isso, faz-se necessário digitalizar as imagens, o que faremos com o software tesseract-ocr. Ele necessita ser calibrado com a fonte utilizada.

## Passo a passo

### Instalando dependências

Os comandos assumem um sistema Ubuntu, mas os softwares são multiplataforma.

    sudo apt-get install youtube-dl libav-tools tesseract-ocr imagemagick

### Baixando um vídeo

    youtube-dl https://www.youtube.com/watch?v=Qkg32qsbmC8

### Extraindo os quadros do vídeo (um por segundo)

    mkdir 1
    avconv -i São\ Paulo\ a\ Maceió\ -\ Inicio\ da\ Viagem\ Parte\ 1-Qkg32qsbmC8.mp4 -qscale:v 2 -r 1/1 1/% 03d.jpg
    
<table>
<thead>
<tr>
<th>Video 1</th>
<th>Video 2</th>
</tr>
</thead>
<tbody>
<tr>
<td><img src="https://github.com/OSMBrasil/tesseract-mapillary/blob/master/imgs/frame-fmt-1.jpg" width="400"></td>
<td><img src="https://github.com/OSMBrasil/tesseract-mapillary/blob/master/imgs/frame-fmt-2.jpg" width="400"></td>
</tr>
</tbody>
</table>
### Cortando a parte com a camada dos dados e o capô do carro

    cd 1
    mkdir crop
    for i in *jpg ; do echo "Convertendo $i" ; convert $i -crop 864x486+208+117 crop/$i ; done

### Cortando as coordenadas

    mkdir coord
    for i in *jpg ; do echo "Convertendo coordenadas $i" ; convert $i -crop [loc] coord/$i ; done

    Video 1 loc=183x97+861+15
    Video 2 loc=115x65+980+825

### Ajustando o contraste

#### Video 2

    convert [img] -level 0%,250% [out]
    convert [out] +level 150%,-250% [final]

### Cortando as datas

    mkdir data
    for i in *jpg ; do echo "Convertendo datas $i" ; convert $i -crop 196x87+1056+21 data/$i ; done

### OCR

#### Video 1

    tesseract [img] [out] -l dsdigital --tessdata-dir ./tessdata/ -psm 6 --user-patterns ./tessdata/latlng.user-patterns -c tessedit_char_whitelist=-,0123456789

#### Video 2
     tesseract  [img] [out] -l helvetica --tessdata-dir ./tessdata/ -psm 6 --user-patterns ./tessdata/latlng.user-patterns -c tessedit_char_whitelist=-,0123456789 -c language_model_penalty_punc=0.1
