program tres;

const
	valorAlto = 'zzz';

type
	str15 = String[15];
	
	tNovela = record
		nombre : str15;
		codigo : integer;
		genero : str15;
		duracion : str15;
		precio : real;
	end;
	
	archivo_novelas = file of tNovela;

procedure nombrarArchivo (var archivo : archivo_novelas);
var
	nombre_archivo : String;
begin
	writeln('Ingrese el nombre del archivo de novelas'); readln(nombre_archivo);
	assign(archivo, nombre_archivo);
end;

procedure leerNovela (var reg : tNovela);
begin
	with reg do begin
		writeln('Ingrese el nombre de la novela'); readln(nombre);
		if (nombre <> valorAlto) then begin
			writeln('Ingrese codigo de la novela'); readln(codigo);
			writeln('Ingrese el genero de la novela'); readln(genero);
			writeln('Ingrese la duracion de la novela'); readln(duracion);
			writeln('Ingrese el precio de la novela'); readln(precio);
		end;
	end;
end;

procedure generarArchivo ();
var
	unaNovela : tNovela;
	archivo : archivo_novelas;
begin
	nombrarArchivo(archivo);
	rewrite(archivo);
	
	//Creo el cabecera
	with unaNovela do begin
		codigo := 0; //indice de nrr
		nombre := '';
		genero := '';
		duracion := '';
		precio := 0;
	end;
	
	write(archivo, unaNovela);
	
	leerNovela(unaNovela);
	
	while (unaNovela.nombre <> valorAlto) do begin
		write(archivo, unaNovela);
		leerNovela(unaNovela);
	end;
	
	close(archivo);
end;

procedure darAlta ();
var
	nuevaNovela, regC, reg : tNovela;
	archivo : archivo_novelas;
begin
	nombrarArchivo(archivo);
	reset(archivo);
	
	leerNovela(nuevaNovela);
	
	read(archivo, regC);
	//si no hay espacio libre
	if (regC.codigo = 0) then begin
		seek(archivo, filesize(archivo));
		write(archivo, nuevaNovela);
	end
	//si tengo espacio libre
	else begin
		//voy a la pos indicada por el reg cabecera
		seek(archivo, (-1 * regC.codigo));
		//leo el registro
		read(archivo, reg);
		//actualizo el registro cabecera
		regC.codigo := reg.codigo;
		//vuelvo a la pos
		seek(archivo, filepos(archivo) - 1);
		//escribo la novela recuperando espacio
		write(archivo, nuevaNovela);
		//vuelvo al reg cabecera
		seek(archivo, 0);
		//lo actualizo
		write(archivo, regC);
	end;
	
	close(archivo);
end;

procedure leerNovelaSinCodigo (var reg : tNovela);
begin
	with reg do begin
		writeln('Ingrese nombre de la novela'); readln(nombre);
		writeln('Ingrese genero de la novela'); readln(genero);
		writeln('Ingrese la duracion de la novela'); readln(duracion);
		writeln('Ingrese el precio de la novela'); readln(precio);
	end;
end;

procedure modificarNovela ();
var
	archivo : archivo_novelas;
	cod : integer;
	nuevaNovela, reg : tNovela;
begin
	nombrarArchivo(archivo);
	reset(archivo);
	
	writeln('Ingrese el codigo de la novela que desee modificar'); readln(cod);
	read(archivo, reg);
	while ((not eof(archivo)) and (reg.codigo <> cod)) do
		read(archivo, reg);
		
	if (reg.codigo = cod) then begin
		nuevaNovela.codigo := reg.codigo;
		leerNovelaSinCodigo(nuevaNovela);
	end
	else
		writeln('No se encontro a una novela con codigo ',cod);
		
	close(archivo);
end;

procedure darBajaPorCodigo ();
var
	archivo : archivo_novelas;
	cod, pos : integer;
	regC, reg : tNovela;
begin
	nombrarArchivo(archivo);
	reset(archivo);
	
	writeln('Ingrese el codigo de novela a eliminar'); readln(cod);
	read(archivo, reg);
	while ((not eof(archivo)) and (reg.codigo <> cod)) do
		read(archivo, reg);
		
	if (reg.codigo <> cod) then
		writeln('No se encontro una novela con codigo ',cod)
	
	else begin
		//guardo la pos donde encontre el registro a eliminar
		pos := filepos(archivo) - 1;
		//voy al reg cabecera y lo leo
		seek(archivo, 0);
		read(archivo, regC);
		//asigno a una variable el contenido del cabecera
		reg.codigo := regC.codigo;
		//actualizo el reg cabecera
		seek(archivo, 0);
		regC.codigo := -1 * pos;
		write(archivo, regC);
		//elimino logicamente el registro
		seek(archivo, pos);
		write(archivo, reg);
	end;
	
	close(archivo);
end;

procedure submenu ();
var
	i : integer;
begin
	writeln('///////////////////////////////////////////////////////////////////');
	writeln('		USTED ELIGIO LA OPCION B	');
	writeln('		1.- Dar de alta una novela');
	writeln('		2.- Modificar una novela (el codigo de novela NO puede ser modificado)');
	writeln('		3.- Eliminar una novela a partir de un codigo de novela');
	writeln('///////////////////////////////////////////////////////////////////');
	readln(i);
	
	case i of
		1:darAlta();
		2:modificarNovela();
		3:darBajaPorCodigo();
	end;
	
end;	
	
procedure listarNovelas ();
var
	archivo : archivo_novelas;
	texto : Text;
	reg : tNovela;
begin
	nombrarArchivo(archivo);
	reset(archivo); 
	assign(texto, 'novelas.txt');
	rewrite(texto);
	
	//read(archivo,reg);
	//no hay que omitir el registro cabecera
	while (not eof(archivo)) do begin
		read(archivo, reg);
		with reg do
			writeln(texto,' ',codigo,' ',nombre,' ',genero,' ',duracion,' ',precio);
	end;
	
	close(texto); close(archivo);
end;


procedure menu ();
var
	op : char;
begin
	repeat
		writeln('///////////////////////////////////////////////////////////////////');
		writeln('	MENU DE OPCIONES	');
		writeln('		a.- Crear el archivo');
		writeln('		b.- Abrir el archivo. . .');
		writeln('		c.- Listar en un txt todas las novelas');
		writeln('		d.- Salir');
		writeln('///////////////////////////////////////////////////////////////////');
		readln(op);
	
		case op of
			'a':generarArchivo();
			'b':submenu();
			'c':listarNovelas()
		else
			writeln('Saliendo. . .');
		end;
	until(op = 'd');
	
end;


//Programa principal
begin
	menu();
end.
