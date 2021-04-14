program seis;

uses sysutils;

const
	corte = 32767;
	dimF = 15;
	
type
	rango = 1..dimF;
	str20 = String[20];
	
	tArticulos_maestro = record
		cod : integer;
		nombre : str20;
		descripcion : str20;
		talle : str20;
		color : str20;
		stockDisponible : integer;
		stockMinimo : integer;
		precio : real;
	end;
	
	archivoMaestro = file of tArticulos_maestro;
	
	tArticulos_detalle = record
		cod : integer;
		cantVendida : integer;
	end;
	
	archivoDetalle = file of tArticulos_detalle;
	
	arrDetalles = array [rango] of archivoDetalle;
	
	arrRegistrosDetalle = array [rango] of tArticulos_detalle;
	
procedure leerArticulo (var archivo : archivoDetalle; var reg : tArticulos_detalle);
begin
	if (not eof(archivo)) then
		read(archivo, reg)
	else
		reg.cod := corte;
end;
		
procedure leerArchivosDetalles (var vectorDetalles : arrDetalles; var registrosDetalle : arrRegistrosDetalle);
var
	i : integer;
begin
	for i := 1 to dimF do
		leerArticulo(vectorDetalles[i], registrosDetalle[i]);
end;

procedure asignarDetalles (var vectorDetalles : arrDetalles);
var
	i : integer;
begin
	for i := 1 to dimF do
		assign(vectorDetalles[i], 'detalle_' + IntToStr(i));
end;

procedure abrirDetalles (var vectorDetalles : arrDetalles);
var
	i : integer;
begin
	for i := 1 to dimF do
		reset(vectorDetalles[i]);
end;

procedure cerrarDetalles (var vectorDetalles : arrDetalles);
var
	i : integer;
begin
	for i := 1 to dimF do
		close(vectorDetalles[i]);
end;

procedure minimo (var vectorDetalles : arrDetalles; var registrosDetalle : arrRegistrosDetalle; var min : tArticulos_detalle);
var
	i, iMin : integer;
begin
	iMin := -1; min.cod := corte;
	
	for i := 1 to dimF do begin
		if ((registrosDetalle[i].cod <> corte) and (registrosDetalle[i].cod < min.cod)) then begin
			min := registrosDetalle[i];
			iMin := i;
		end;
	end;
	
	if (iMin <> -1) then
		leerArticulo(vectorDetalles[i], registrosDetalle[i]);
	
end;

procedure generarMaestro (var maestro : archivoMaestro; var vectorDetalles : arrDetalles);
var
	registrosDetalle : arrRegistrosDetalle;
	regM : tArticulos_maestro;
	min : tArticulos_detalle;
begin
	reset(maestro);
	abrirDetalles(vectorDetalles);
	leerArchivosDetalles(vectorDetalles, registrosDetalle);
	
	minimo(vectorDetalles, registrosDetalle, min);
	
	while (min.cod <> corte) do begin
		read(maestro, regM);
		
		while (regM.cod <> min.cod) do
			read(maestro, regM);
		
		while (regM.cod = min.cod) do begin
			regM.stockDisponible := regM.stockDisponible - min.cantVendida;
			minimo(vectorDetalles, registrosDetalle, min);
		end;
	
		seek(maestro, filepos(maestro) - 1);
		write(maestro, regM);
	end;
	
	cerrarDetalles(vectorDetalles);
	close(maestro);
end;

procedure generarTexto (var maestro : archivoMaestro; var texto : Text);
var
	regM : tArticulos_maestro;
begin
	reset(maestro);
	rewrite(texto);
	
	while (not eof(maestro)) do begin
		read(maestro, regM);
		with regM do begin
			if (stockDisponible < stockMinimo) then
				write(texto,' ',nombre,' ',descripcion,' ',stockDisponible,' ',precio);
		end;
	end;
	
	close(texto);
	close(maestro);
end;


var
	maestro : archivoMaestro;
	texto : Text;
	vectorDetalles : arrDetalles;
begin
	assign(maestro, 'maestro');
	asignarDetalles(vectorDetalles);
	assign(texto,'articulos.txt');
	
	generarMaestro(maestro, vectorDetalles);
	generarTexto(maestro, texto);
end.
