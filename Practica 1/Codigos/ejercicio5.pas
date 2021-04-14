program cinco;
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

//Programa Principal
var
	celulares : Text; //archivo con datos
	celularFinal : Text; //archivo a cargar
	archivo : archivoCelulares;
	op : char;
	archivoFisico, unaDescripcion : String;
begin
	writeln('Ingrese nombre del archivo binario'); readln(archivoFisico);
	assign(archivo,archivoFisico);
	assign(celulares,'celulares.txt');
	assign(celularFinal,'celular.txt');
	
	repeat
		writeln('******************************************************************************************');
		writeln('Menu de opciones');
		writeln('		a.- Crear un archivo a partir de un archivo de texto');
		writeln('		b.- Listar celulares con un stock menor al minimo');
		writeln('		c.- Listar celulares cuya descripcion se corresponde con una ingresada');
		writeln('		d.- Exportar todos los datos del archivo a uno de texto');
		writeln('		e.- Salir');
		writeln('******************************************************************************************');
		readln(op);
		
		case op of
			'a': cargarArchivoBinario(archivo,celulares);
			'b': listarCelularesStockMenorAlMinimo(archivo);
			'c': begin
					writeln('Ingrese una descripcion: ');
					readln(unaDescripcion);
					listarCelularesConDescripcion(archivo,unaDescripcion);
				 end;
			'd': exportarDatos(archivo,celularFinal);
			else
				writeln('Saliendo. . .');
		end;
	until (op = 'e');
end.
