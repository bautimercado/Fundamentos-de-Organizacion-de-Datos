program seis;

type
	str20 = String[20];

	tPrenda = record
		cod_prenda : integer;
		descripcion : str20;
		colores : str20;
		tipo_prenda : str20;
		stock : integer;
		precio : real;
	end;
	
	archivo_maestro = file of tPrenda;
	
	//este archivo posee los codigos de prenda que se tienen que hay que dar de baja
	archivo_detalle = file of integer;
	
//no se usa lista invertida
procedure darBaja (var archivo : archivo_maestro; unCodigo : integer);
var
	unaPrenda : tPrenda;
begin
	reset(archivo);
	read(archivo, unaPrenda);
	
	while ((not eof(archivo)) and (unaPrenda.cod_prenda <> unCodigo)) do
		read(archivo, unaPrenda);
		
	if (unaPrenda.cod_prenda <> unCodigo) then
		writeln('No se encontro una prenda con el codigo ',unCodigo)
	else begin
		//el stock en negativo me indica que el registro esta eliminado
		unaPrenda.stock := -1 * unaPrenda.stock;
		seek(archivo, filepos(archivo) - 1);
		write(archivo, unaPrenda);
	end;
	
	close(archivo);
end;	
	
procedure darBajaLogica (var archivo : archivo_maestro; var det : archivo_detalle);
var
	unCodigo : integer;
begin
	reset(det);
	while (not eof(det)) do begin
		read(det, unCodigo);
		darBaja(archivo, unCodigo);
	end;
	close(det);
end;

procedure compactarArchivo (var archivo, compacto : archivo_maestro);
var
	unaPrenda : tPrenda;
begin
	reset(archivo); rewrite(compacto);
	
	while (not eof(archivo)) do begin
		read(archivo, unaPrenda);
		if (unaPrenda.stock >= 0) then 
			write(compacto, unaPrenda);
	end; 
	
	close(compacto); close(archivo);
end;

//Programa principal
var
	archivo, compacto : archivo_maestro;
	detalle : archivo_detalle;
begin
	assign(archivo, 'archivo_prendas'); 
	assign(detalle, 'detalle');
	assign(compacto, 'nuevas_prendas');
	darBajaLogica(archivo, detalle);
	compactarArchivo(archivo, compacto);
	rename(archivo, 'prendas_viejas');
end.
