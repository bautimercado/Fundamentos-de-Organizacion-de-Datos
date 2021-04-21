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
	writeln('Ingrese un codigo de ave que desee eliminar'); readln(unCodigo);
	
	while (unCodigo <> corte) do begin
		bajaLogica(archivo, unCodigo);
		writeln('Ingrese un codigp de ave que desee eliminar'); readln(unCodigo);
	end; 
end;

procedure llevarAlFinal (var archivo : archivo_aves; unAve : tAve; pos, borrados : integer);
var
	aux : tAve;
begin
	seek(archivo, filesize(archivo) - 1);
	read(archivo, aux);
	seek(archivo, filepos(archivo) - 1);
	write(archivo, unAve);
	seek(archivo, pos);
	write(archivo, aux);
end;

procedure compactarArchivo (var archivo : archivo_aves);
var
	unAve, ultimoReg : tAve;
	borrados, ultimaPos, actualPos : integer;
begin
	reset(archivo);
	//borrados contabiliza la cantidad de registros eliminados
	//sirve para tener que hacer un solo truncate...es ineficiente hacer muchos
	borrados := 0;
	//ultimaPos me indica el ultimo nrr de un registro valido (codigo <> marca_de_borrado)
	ultimaPos := filesize(archivo) - 1;

	//no es necesario el leer xq filepos(archivo) < ultimaPos me marca el fin del recorrido 
	while (filepos(archivo) < ultimaPos) do begin
		read(archivo, unAve);
		//si el registro actual tiene la marca
		if (unAve.codigo = '***') then begin
			//sumo un borrado
			borrados += 1;
			//guardo al posición actual
			actualPos := filepos(archivo) - 1;
			//me paro en el ultimo registro (indicado por ultimaPos) y lo leo
			seek(archivo, ultimaPos);
			read(archivo, ultimoReg);
			//mientras el ultimo registro este borrado y la posicion donde encontre el reg con la marca sea menor a la
			//ultima pos
			while ((ultimoReg.codigo = '***') and (actualPos < ultimaPos)) do begin
				//contabilizo los borrados, pueden haber registros borrados al final
				borrados += 1;
				//si el ultimo reg es un reg borrado, actualizo el contador de la ultima posicion
				ultimaPos -= 1;
				seek(archivo, ultimaPos);
				read(archivo, ultimoReg);
			end;
			//si el ultimo registro no es un registro a borrar, lo llevo al registro que estaba borrado
			if (ultimoReg.codigo <> '***') then begin
				//coloco la marca de borrado al final
				seek(archivo, ultimaPos);
				write(archivo, unAve);
				seek(archivo, actualPos);
				write(archivo, ultimoReg);
			end;
		end;
	end;
	
	seek(archivo, filesize(archivo) - borrados);
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
		
