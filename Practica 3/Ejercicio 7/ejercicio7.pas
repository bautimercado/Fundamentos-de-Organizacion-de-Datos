program siete;

const
	corte = '5000000';
	
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
	
procedure bajaLogica (var archivo : archivo_aves; unCodigo : str15);
var
	unAve : tAve;
begin
	reset(archivo);
	read(archivo,unAve);
	
	while ((not eof(archivo)) and (unAve.codigo <> unCodigo)) do
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

procedure llevarAlFinal (var archivo : archivo_aves; unAve : tAve; pos : integer);
var
	aux : tAve;
begin
	seek(archivo, filesize(archivo) - 1);
	read(archivo, aux);
	seek(archivo, filepos(archivo) - 1);
	write(archivo, unAve);
	seek(archivo, pos);
	write(archivo, aux);
	seek(archivo, filepos(archivo) - 1);
	truncate(archivo);
end;

procedure compactarArchivo (var archivo : archivo_aves);
var
	unAve : tAve;
begin
	reset(archivo);
	
	while (not eof(archivo)) do begin
		read(archivo, unAve);
		if (unAve.codigo = '***') then 
			llevarAlFinal(archivo, unAve, (filepos(archivo) - 1));
	end;
	
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
		
