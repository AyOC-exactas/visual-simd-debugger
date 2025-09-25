section .data
  message: db "Primer celda", 10, 0
  emessage equ $ - message

;Este programa se encarga de pasar los 2 primeros pixeles en memoria a escala de grises.
;Esto se hace mediante la formula: gris = (rojo + 2 * verde + azul)/4.
;Una vez se obtienen los 2 valores se les hace un broadcast de tal modo que
;la parte baja del registro este formada por el primer pixel gris repetido 2 veces y
;la parte alta contenga el segundo pixel gris.
pixeles: db 173, 68, 144, 255, 16, 54, 231, 255, 29, 178, 50, 255, 79, 211, 203, 255
mascara: db 0, 0, 0, 2, 0, 0, 0, 2, 1, 1, 1, 2, 1, 1, 1, 2

global simd_main

section .text
simd_main:

;Cargo la mascara en xmm0 y los 2 primeros pixeles en xmm1 e imprimo los valores.
movdqu xmm0, [rel mascara]
pmovzxbw xmm1, [rel pixeles]
;p/u xmm0.v16_int8
;p/u xmm1.v8_int16

;Reemplazo el valor alfa de cada pixel con el valor verde del mismo. Hacemos esto para ambos pixeles.
;Esto nos permite conseguir el valor de gris haciendo sumas horizontales.
pshufhw xmm1, xmm1, 0b01100100
pshuflw xmm1, xmm1, 0b01100100

;Hacemos la primer suma horizontal.
;Ahora tenemos en los 2 registros de la derecha el los valores de R + 2G + B de cada pixel.
phaddw xmm1, xmm1
phaddw xmm1, xmm1

;Shifteamos a derecha para dividir los resultados por 4 y asi obtener el valor gris del pixel.
psrlw xmm1, 2

;Volvemos a almacenar los pixeles conseguidos como enteros de 8 bits. En este punto vuelvo a imprimir en 8 bits.
packuswb xmm1, xmm1
;p xmm1.v16_int8"

;Inserto un 255 en el valor de alfa para restaurar el valor original.
xor rax, rax
dec rax
pinsrb xmm1, al, 2

;Uso la mascara en xmm0 para hacer un broadcast de los valores conseguidos y del alfa
; como decia el enunciado.
pshufb xmm1, xmm0
ret
