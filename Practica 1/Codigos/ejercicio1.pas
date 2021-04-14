{1. Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
incorporar datos al archivo. Los números son ingresados desde teclado. El nombre del
archivo debe ser proporcionado por el usuario desde teclado. La carga finaliza cuando
se ingrese el número 30000, que no debe incorporarse al archivo.}


program uno;

type
    archivo = file of integer;

var
    arcNumeros : archivo;
    n : integer;

begin
    assign(arcNumeros,'archivo');
    rewrite(arcNumeros);
    writeln('Ingrese un numero: '); readln(n);
    while (n <> 30000) do begin
        write(arcNumeros,n);
        writeln('Ingrese un numero: '); readln(n);
    end;
    close(arcNumeros);
end.