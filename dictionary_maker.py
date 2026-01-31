import nltk
from nltk.corpus import cess_esp

##### CONFIGURACION
# Se consideran palabras con longitud en el rango: (minimo de letras, maximo de letras)
limites = (3, 8)
# Numero de palabras del diccionario
N = 3000

# Descargamos los recursos necesarios para el espanyol
nltk.download('cess_esp')
# Para sacar las palabras etiquetadas (palabra, etiqueta)
palabras_etiq = cess_esp.tagged_words()

lista_palabras = set()
for palabra, etiqueta in palabras_etiq:
    palabra.lower()
    # Filtros:
    # Sustantivos comunes para no obtener palabras tecnicas o muy especificas
    # Longitud de la palabra
    # Que no tenga caracteres especiales, como e-mail
    if etiqueta.startswith('nc') and limites[0] <= len(palabra) <= limites[1] and palabra.isalpha():
        # Filtramos que no tengan tildes, hay terminales que no lo soportan
        tildes = "áéíóú"
        if not any(letra in tildes for letra in palabra):
            lista_palabras.add(palabra)
            # Check del numero de palabras solicitado
            if len(lista_palabras) >= N:
                break

# Controlamos el numero de palabras del diccionario
print(f'[INFO]: Se ha generado un diccionario con {len(lista_palabras)} palabras '
      f'de longitud entre {limites[0]} y {limites[1]} letras.')
if len(lista_palabras) < N:
    print(f'[WARN]: Solo existen {len(lista_palabras)} palabras con esas características. '
          f'Si deseas más, aumenta el rango de letras permitidas en el script dictionary_maker.py')

# Generamos el fichero diccionario.txt
with open('diccionario.txt', 'w', encoding='utf-8') as f:
    for palabra in lista_palabras:
        f.write(f"{palabra}\n")
