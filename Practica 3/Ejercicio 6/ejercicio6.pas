program seis;

const
	valorAlto = 32767;

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

procedure leerRegistroMaestro (var arc : archivo_maestro; var reg : tPrenda);
begin
	if (not eof(arc)) then
		read(arc, reg)
	else
		reg.cod_prenda := valorAlto;
end;
	
//no se usa lista invertida
procedure darBaja (var archivo : archivo_maestro; unCodigo : integer);
var
	unaPrenda : tPrenda;
begin
	reset(archivo);
	leerRegistroMaestro(archivo, unaPrenda);
	
	while ((unaPrenda.cod_prenda <> valorAlto) and (unaPrenda.cod_prenda <> unCodigo)) do
		leerRegistroMaestro(archivo, unaPrenda);
		
	//los detalle tienen info que estan en el maestro
	if (unaPrenda.cod_prenda = unCodigo) then begin
		//el stock en negativo me indica que el registro esta eliminado
		unaPrenda.stock := -1 * unaPrenda.stock;
		seek(archivo, filepos(archivo) - 1);
		write(archivo, unaPrenda);
	end;
	
	close(archivo);
end;	
	
procedure recorrerDetalle (var archivo : archivo_maestro; var det : archivo_detalle);
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
	
	leerRegistroMaestro(archivo, unaPrenda);
	
	while (unaPrenda.cod_prenda <> valorAlto) do begin
		if (unaPrenda.stock >= 0) then 
			write(compacto, unaPrenda);
		leerRegistroMaestro(archivo, unaPrenda);
	end; 
	
	close(compacto); close(archivo);
end;

//preguntar por esto. . .
procedure renombrarArchivos (var arc, compacto : archivo_maestro);
begin
	reset(arc);
	rename(arc, 'original');
	close(arc);
	erase(arc);
	rename(compacto, 'nuevo');
	close(compacto);
end;

//Programa principal
var
	archivo, compacto : archivo_maestro;
	detalle : archivo_detalle;
begin
	assign(archivo, 'archivo_prendas'); 
	assign(detalle, 'detalle');
	assign(compacto, 'nuevas_prendas');
	recorrerDetalle(archivo, detalle);
	compactarArchivo(archivo, compacto);
	renombrarArchivos(archivo, compacto);
end.
