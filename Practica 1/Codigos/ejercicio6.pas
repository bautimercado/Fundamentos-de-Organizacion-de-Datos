program seis;

const
    corte = 0;

type
	celular = record
		codigo : integer;
		nombre : String;
		descripcion : String;
		marca : String;
		precio : real;
		stockMinimo : integer;
		stockDisponible : integer;
	end;
	
	archivoCelulares = file of celular;
	
procedure cargarArchivoBinario (var archivo : archivoCelulares; var celulares : Text);
var
	unCelular : celular;
begin
	reset(celulares);
	rewrite(archivo);
	writeln;
	
	while (not eof(celulares)) do begin
		readln(celulares, unCelular.codigo, unCelular.precio, unCelular.marca, unCelular.nombre);
		readln(celulares, unCelular.stockDisponible, unCelular.stockMinimo, unCelular.descripcion);
		write(archivo, unCelular);
	end;
	writeln('Archivo cargado');
	close(archivo);
	close(celulares);
end;

procedure listarCelularesStockMenorAlMinimo (var archivo : archivoCelulares);
var
	unCelular : celular;
begin
	reset(archivo);
	while (not eof(archivo)) do begin
		read(archivo,unCelular);
		if (unCelular.stockDisponible < unCelular.stockMinimo) then
			with unCelular do
				writeln('Codigo: ',codigo,' Precio: ',precio:4:2,'$ Marca: ',marca,' Nombre: ',nombre,' stock disponible: ',stockDisponible,' stock minimo: ',stockMinimo,' descrpicion: ',descripcion);
	end;
	close(archivo);
end;

procedure listarCelularesConDescripcion (var archivo : archivoCelulares; unaDescripcion : String);
var
	unCelular : celular;
begin
	reset(archivo);
	while (not eof(archivo)) do begin
		read(archivo,unCelular);
		if (unCelular.descripcion = unaDescripcion) then
			with unCelular do
				writeln('Codigo: ',codigo,' Precio: ',precio:4:2,'$ Marca: ',marca,' Nombre: ',nombre,' stock disponible: ',stockDisponible,' stock minimo: ',stockMinimo,' descrpicion: ',descripcion);
	end;
	close(archivo);
end;


procedure exportarDatos (var archivo : archivoCelulares; var celularFinal : Text);
var
	unCelular : celular;
begin
	reset(archivo);
	rewrite(celularFinal);
	while (not eof(archivo)) do begin
		read(archivo,unCelular);
		with unCelular do begin
			writeln('Codigo: ',codigo,' Precio: ',precio:4:2,'$ Marca: ',marca,' Nombre: ',nombre,' stock disponible: ',stockDisponible,' stock minimo: ',stockMinimo,' descrpicion: ',descripcion);
			writeln(celularFinal,' ',codigo,' ',precio:4:2,'$ ',marca,' ',nombre,' ',stockDisponible,' ',stockMinimo,' ',descripcion);
		end;
	end;
	close(archivo);
	close(celularFinal);
end;

procedure leerCelular (var unCelular : celular);
begin
    with unCelular do begin
        writeln('Ingrese codigo: '); readln(codigo);
        if (codigo <> corte) then begin
            writeln('Ingrese precio: '); readln(precio);
            writeln('Ingrese marca: '); readln(marca);
            writeln('Ingrese nombre: '); readln(nombre);
            writeln('Ingrese stock disponible: '); readln(stockDisponible);
            writeln('Ingrese stock minimo: '); readln(stockMinimo);
            writeln('Ingrese descripcion: '); readln(descripcion);
        end;
    end;
end;

procedure agregarDatos (var archivo : archivoCelulares);
var
    unCelular : celular;
begin
    reset(archivo);
    seek(archivo,filesize(archivo));
    leerCelular(unCelular);
    while (unCelular.codigo <> corte) do begin
        write(archivo,unCelular);
        leerCelular(unCelular);
    end;
    close(archivo);
end;

procedure modificarStock (var archivo : archivoCelulares; unNombre : String);
var
    unCelular : celular;
    nuevoStock : integer;
begin
    reset(archivo);
    while (not eof(archivo)) do begin
        read(archivo,unCelular);
        if (unCelular.nombre = unNombre) then begin
            writeln('Seleccione un nuevo stock'); readln(nuevoStock);
            unCelular.stockDisponible := nuevoStock;
        end;
    end;
    close(archivo);
end;

procedure exportarCelularesSinStock (var archivo : archivoCelulares; var sinStock : Text);
var
    unCelular : celular;
begin
    reset(archivo);
    rewrite(sinStock);
    while (not eof(archivo)) do begin
        read(archivo,unCelular);
        if (unCelular.stockDisponible = 0) then begin
            with unCelular do begin
                writeln('Codigo: ',codigo,' Precio: ',precio:4:2,'$ Marca: ',marca,' Nombre: ',nombre,' stock disponible: ',stockDisponible,' stock minimo: ',stockMinimo,' descrpicion: ',descripcion);
                writeln(sinStock,' ',codigo,' ',precio:4:2,'$ ',marca,' ',nombre,' ',stockDisponible,' ',stockMinimo,' ',descripcion);
            end;
        end;
    end;
    writeln('Exportados');
    close(archivo);
    close(sinStock);
end;

procedure mostrarDatos (var archivo : archivoCelulares);
var
	unCelular : celular;
begin
	reset(archivo);
	while (not eof(archivo)) do begin
		read(archivo,unCelular);
		with unCelular do
			writeln('Codigo: ',codigo,' Precio: ',precio:4:2,'$ Marca: ',marca,' Nombre: ',nombre,' stock disponible: ',stockDisponible,' stock minimo: ',stockMinimo,' descrpicion: ',descripcion);		
	end;
	close(archivo);
end;

//Programa Principal
var
	celulares : Text; //archivo con datos
	celularFinal : Text; //archivo a cargar
	sinStock : Text;
    archivo : archivoCelulares;
	op : char;
	archivoFisico, aux : String;
begin
	writeln('Ingrese nombre del archivo binario'); readln(archivoFisico);
	assign(archivo,archivoFisico);
	assign(celulares,'celulares.txt');
	assign(celularFinal,'celular.txt');
	assign(sinStock,'SinStock.txt');
	
    repeat
		writeln('******************************************************************************************');
		writeln('Menu de opciones');
		writeln('		a.- Crear un archivo a partir de un archivo de texto');
		writeln('		b.- Listar celulares con un stock menor al minimo');
		writeln('		c.- Listar celulares cuya descripcion se corresponde con una ingresada');
		writeln('		d.- Exportar todos los datos del archivo a uno de texto');
		writeln('		e.- Agregar celular/es');
        writeln('		f.- Modificar el stock de un celular cuyo nombre se corresponda con uno ingresado');
        writeln('		g.- Exportar aquellos celulares sin stock');
        writeln('		h.- Mostrar datos del archivo binario');
		writeln('		i.- Salir');
		writeln('******************************************************************************************');
		readln(op);
		
		case op of
			'a': cargarArchivoBinario(archivo,celulares);
			'b': listarCelularesStockMenorAlMinimo(archivo);
			'c': begin
					writeln('Ingrese una descripcion: ');
					readln(aux);
					listarCelularesConDescripcion(archivo,aux);
				 end;
			'd': exportarDatos(archivo,celularFinal);
			'e': agregarDatos(archivo);
            'f': begin
                    writeln('Ingrese un nombre: ');
                    readln(aux);
                    modificarStock(archivo,aux);
                 end;
            'g': exportarCelularesSinStock(archivo,sinStock);
            'h': mostrarDatos(archivo);
			else
				writeln('Saliendo. . .');
		end;
	until (op = 'i');
end.
