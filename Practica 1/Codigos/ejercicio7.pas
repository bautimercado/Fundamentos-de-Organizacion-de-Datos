program siete;

const
    corte = 0;

type
    novela = record
        codigo : integer;
        precio : real;
        genero : String;
        nombre : String;
    end;

    archivoNovela = file of novela;

procedure cargarArchivo (var archivo : archivoNovela; var novelas : Text);
var
	unaNovela : novela;
begin
	reset(novelas);
	rewrite(archivo);
	while (not eof(novelas)) do begin
		with unaNovela do begin
			readln(novelas, codigo, precio, genero); 
			readln(novelas, nombre);
		end;
		write(archivo,unaNovela);
	end;
	close(novelas);
	close(archivo);
end;

procedure leerNovela (var unaNovela : novela);
begin
    with unaNovela do begin
        writeln('Ingrese un codigo'); readln(codigo);
        if (codigo <> corte) then begin
            writeln('Ingrese un precio'); readln(precio);
            writeln('Ingrese un genero'); readln(genero);
            writeln('Ingrese un nombre'); readln(nombre);
        end;
    end;
end;

procedure agregarDatos (var archivo : archivoNovela);
var
    unaNovela : novela;
begin
    reset(archivo);
    seek(archivo,filesize(archivo));
    leerNovela(unaNovela);
    while (unaNovela.codigo <> corte) do begin
        write(archivo,unaNovela);
        leerNovela(unaNovela);
    end;
    close(archivo);
end;

procedure listarDatos (var archivo : archivoNovela);
var
    unaNovela : novela;
begin
    reset(archivo);
    while (not eof(archivo)) do begin
        read(archivo,unaNovela);
        with unaNovela do
            writeln('Codigo: ',codigo,' precio: ',precio:4:2,'$ Genero: ',genero,' Nombre: ',nombre);
    end;
    close(archivo);
end;

procedure modificarDatos (var archivo : archivoNovela; var unCodigo : integer);
var
    unaNovela : novela;
begin
    reset(archivo);
    while(not eof(archivo)) do begin
        read(archivo,unaNovela);
        if (unaNovela.codigo = unCodigo) then begin
            writeln('A continuacion ingrese los nuevos datos de la novela');
            leerNovela(unaNovela);
            seek(archivo,filepos(archivo) - 1);
            write(archivo,unaNovela);
        end;
    end;
    close(archivo);
end;

//Programa Principal
var
    novelas : Text;
    archivo : archivoNovela;
    op : char;
    aux : integer;
begin
    assign(archivo,'archivoNovelas'); 
    assign(novelas,'novelas.txt');
    
    
    repeat   
        writeln('*******************************************************');
        writeln('Menu de opciones: ');
        writeln('       a.- Crear archivo binario');
        writeln('       b.- Agregar novela/s');
        writeln('       c.- Modificar novela cuyo codigo se corresponda con uno ingresado');
        writeln('       d.- Listar datos');
        writeln('       e.- Salir');
        writeln('*******************************************************');
		read(op);
		
		case op of
			'a':cargarArchivo(archivo,novelas);
			'b':agregarDatos(archivo);
			'c':begin
					writeln('Ingrese un codigo: ');
					readln(aux);
					modificarDatos(archivo,aux);
				end;
			'd':listarDatos(archivo);
			else
				writeln('Saliendo. . .');
        end;
    until (op = 'e'); 

end.
