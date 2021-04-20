program siete;

const
	corte = '5000000';
	valorAlto = 'zzzzzzzzzz';
	
type
	str15 = String[15];
	
	tAve = record
		codigo : str15;
		nombre : str15;
		familia : str15;
		descripcion : str15;
		zonaGeografica : str15;
	end;
	
	archivo_aves = file of tAve;

procedure leerRegistro (var arc : archivo_aves; var reg : tAve);
begin
	if (not eof(arc)) then
		read(arc, reg)
	else
		reg.codigo := valorAlto;
end;
	
procedure bajaLogica (var archivo : archivo_aves; unCodigo : str15);
var
	unAve : tAve;
begin
	reset(archivo);
	leerRegistro(archivo, unAve);
	
	while ((unAve.codigo <> valorAlto) and (unAve.codigo <> unCodigo)) do
		read(archivo, unAve);
	
	if (unAve.codigo = unCodigo) then
		writeln('No se encontro el codigo ',unCodigo)
	
	else begin
		unAve.codigo := '***';
		seek(archivo, filepos(archivo) - 1);
		write(archivo, unAve);
		writeln('Registro eliminado');
	end;
	
	close(archivo);
end;
	
procedure darDeBaja (var archivo : archivo_aves);
var
	unCodigo : str15;
begin
	writeln('Ingrese un codigp de ave que desee eliminar'); readln(unCodigo);
	
	while (unCodigo <> corte) do begin
		bajaLogica(archivo, unCodigo);
		writeln('Ingrese un codigp de ave que desee eliminar'); readln(unCodigo);
	end; 
end;

procedure llevarAlFinal (var archivo : archivo_aves; unAve : tAve; pos, cant : integer);
var
	aux : tAve;
begin
	seek(archivo, filesize(archivo) - cant);
	read(archivo, aux);
	seek(archivo, filepos(archivo) - 1);
	write(archivo, unAve);
	seek(archivo, pos);
	write(archivo, aux);
end;

procedure compactarArchivo (var archivo : archivo_aves);
var
	unAve : tAve;
	cant : integer;
begin
	reset(archivo);
	leerRegistro(archivo, unAve);
	cant := 0;

	while (unAve.codigo <> valorAlto) do begin
		if (unAve.codigo = '***') then begin
			cant := cant + 1;
			llevarAlFinal(archivo, unAve, (filepos(archivo) - 1), cant);
		end;
		leerRegistro(archivo, unAve);
	end;
	
	seek(archivo, filesize(archivo) - cant);
	truncate(archivo);
	close(archivo);
end;

//Programa principal
var
	archivo : archivo_aves;
begin
	assign(archivo, 'aves_en_peligro_de_extinsion');
	darDeBaja(archivo);
	compactarArchivo(archivo);
end.
