{2. Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
creados en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y
el promedio de los números ingresados. El nombre del archivo a procesar debe ser
proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
contenido del archivo en pantalla.}
program dos;

type

    archivo = file of integer;

procedure menoresA1500 (num : integer; var cant : integer);
begin
    if (num < 1500) then
      cant := cant + 1;
end;

function promedio (cantNumeros, total : integer):real;
begin
    promedio := total / cantNumeros;
end;

var
    arcNumeros : archivo;
    n, total, cantMenor, cantNumeros : integer;
    nomArchivo : String;
begin
    writeln('Ingrese nombre de archivo: '); readln(nomArchivo);
    assign(arcNumeros,nomArchivo);
    reset(arcNumeros);
    
    total := 0; cantMenor := 0; cantNumeros := 0;

    while (not eof (arcNumeros)) do begin
       read(arcNumeros,n);
       writeln(n);
       menoresA1500(n,cantMenor);
       total := total + n;
       cantNumeros := cantNumeros + 1;
    end;   
    
    writeln('La cantidad de numeros menores a 1500 es: ',cantMenor);
    writeln('El promedio de numeros es: ',promedio(cantNumeros,total):4:2);

end.