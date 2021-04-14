FUNDAMENTOS DE ORGANIZACION DE DATOS

  Practica 1:
    .- Basico, generar archivos binarios 
    .- Archivos de texto
    .- Recorrer archivos 
    .- Actualizarlos, etc.

  Practica 2 Algoritmica clasica :
    .- Agregar nuevos registros al final del archivo 
    .- Actualizar maestro con 1, 2, N detalles (si son muchos han de estar en registros)
    .- Corte de control
    .- Buscar un minimo entre varios archivos
    .- Merge

  Practica 3 Bajas y Altas:
    .- Bajas Físicas: Recupera el espacio, los algoritmos no favorecen a la performance
        - Generar un nuevo archivo sin los elementos que tengo que borrar (va de la mano con baja lógica, el nuevo archivo se puede renombrar).
        - Hacer un reacomodamiento (como en un arreglo).
        - Intercambiar el espacio del registro eliminado e intercambiarlo por el ultimo. (Hay que usar truncate())
    
    .- Bajas Lógicas: Coloca una marca de borrado a los registros
        - Reasignación de espacio
        - Permite realizar facilmente altas donde los archivos estan "borrados"
        - Lista invertida, el 1er registro, cabecera, tiene la sig. pos. del registro borrado o puede no tener.
        