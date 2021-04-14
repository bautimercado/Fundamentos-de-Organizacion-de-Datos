program once;

uses sysutils;

const
	corte = 'zzzzz';
	dimF = 2;
	
type
	str20 = String[20];
	rango = 1..dimF;
	
	tCenso_Maestro = record
		provincia : str20;
		cantAlf : integer;
		totalEncuestados : integer;
	end;
	
	archivoMaestro = file of tCenso_Maestro;
	
	tCenso_Detalle = record	
		provincia : str20;
		codLocalidad : integer;
		cantAlf : integer;
		cantEncuestados : integer;
	end;
	
	archivoDetalle = file of tCenso_Detalle;
	
	arrDetalles = array [rango] of archivoDetalle;
	
	arrRegistrosDetalle = array [rango] of tCenso_Detalle;
	
procedure leerCenso (var archivo : archivoDetalle; var reg : tCenso_Detalle);
begin
	if (not eof(archivo)) then
		read(archivo, reg)
	else
		reg.provincia := corte;
end;

procedure iniciarRegistrosDetalle (var detalles : arrDetalles; var registrosDetalle : arrRegistrosDetalle);
var
	i : integer;
begin
	for i := 1 to dimF do
		leerCenso(detalles[i], registrosDetalle[i]);
end;

procedure asignarDetalles (var detalles : arrDetalles);
var
	i : integer;
begin
	for i := 1 to dimF do
		assign(detalles[i], 'detalle_' + IntToStr(i));
end;

procedure abrirDetalles (var detalles : arrDetalles);
var
	i : integer;
begin
	for i := 1 to dimF do
		reset(detalles[i]);
end;

procedure cerrarDetalles (var detalles : arrDetalles);
var
	i : integer;
begin
	for i := 1 to dimF do
		close(detalles[i]);
end;

procedure minimo (var detalles : arrDetalles; var registrosDetalle : arrRegistrosDetalle; var min : tCenso_Detalle);
var
	i, iMin : integer;
begin
	iMin := -1; min.provincia := corte;
	
	for i := 1 to dimF do begin
		
		if ((registrosDetalle[i].provincia <> corte) and (registrosDetalle[i].provincia < min.provincia)) then begin
			min := registrosDetalle[i];
			iMin := i;
		end;
	end;
	
	if (iMin <> -1) then begin
		leerCenso(detalles[iMin], registrosDetalle[i]);
	end;
end;

procedure actualizarMaestro (var maestro : archivoMaestro; var detalles : arrDetalles);
var
	regM : tCenso_Maestro;
	registrosDetalle : arrRegistrosDetalle;
	min : tCenso_Detalle;
begin
	reset(maestro);
	abrirDetalles(detalles);
	iniciarRegistrosDetalle(detalles, registrosDetalle);
	minimo(detalles, registrosDetalle, min);
	
	while (min.provincia <> corte) do begin
		read(maestro, regM);
		
		while (regM.provincia <> min.provincia) do
			read(maestro, regM);
			
		while (regM.provincia = min.provincia) do begin
			regM.cantAlf := min.cantAlf;
			regM.totalEncuestados := min.cantEncuestados;
			minimo(detalles, registrosDetalle, min);
		end;
		
		seek(maestro, filepos(maestro) - 1);
		write(maestro, regM);
	end;
	
	cerrarDetalles(detalles);
	close(maestro);
	
end;

//Programa Principal
var
	maestro : archivoMaestro;
	detalles : arrDetalles;
begin
	assign(maestro, 'maestro');
	asignarDetalles(detalles);
	
	actualizarMaestro(maestro, detalles);
	
end.
