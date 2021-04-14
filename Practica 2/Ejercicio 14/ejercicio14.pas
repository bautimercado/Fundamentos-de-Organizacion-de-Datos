program catorce;

uses sysutils;

const
	corte = 'zzzzz';
	dimF = 2;

type
	str20 = String[20];
	str10 = String[10];
	str5 = String[5];
	rango = 1..dimF;
	
	tVuelos_maestro = record
		fecha : str10;
		destino : str20;
		horaSalida : str5;
		asientosDisponibles : integer;
	end;
	
	archivo_maestro = file of tVuelos_maestro;
	
	tVuelos_detalle = record
		destino : str20;
		fecha : str10;
		horaSalida : str5;
		asientosComprados : integer;
	end;
	
	archivo_detalle = file of tVuelos_detalle;
	
	arrDetalles = array [rango] of archivo_detalle;

	arrRegistrosDetalle = array [rango] of tVuelos_detalle;
	
	tVuelos_con_pocos_asientos_disponibles = record
		destino : str20;
		fecha : str10;
		horaSalida : str5;
	end;
	
	archivo_vuelos_pocos_asientos_disponibles = file of tVuelos_con_pocos_asientos_disponibles;
	
procedure leer (var detalle : archivo_detalle; var reg : tVuelos_detalle);
begin
	if (not eof(detalle)) then
		read(detalle, reg)
	else
		reg.destino := corte;
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

procedure leerRegistrosDetalle (var detalles : arrDetalles; var registrosDetalle : arrRegistrosDetalle);
var
	i : integer;
begin
	for i := 1 to dimF do
		leer(detalles[i], registrosDetalle[i]);
end;

procedure cerrarDetalles (var detalles : arrDetalles);
var
	i : integer;
begin
	for i := 1 to dimF do
		close(detalles[i]);
end;

procedure minimo (var detalles : arrDetalles; var registrosDetalle : arrRegistrosDetalle; var min : tVuelos_detalle);
var
	i, iMin : integer;
begin
	iMin := -1;
	with min do begin
		destino := corte;
		fecha := corte;
		horaSalida := corte;
	end;
	
	for i := 1 to dimF do begin
	
		if (registrosDetalle[i].destino <> corte) then
			if (registrosDetalle[i].destino < min.destino) then begin
				iMin := i;
				min := registrosDetalle[i];
			end
			else
				if ((registrosDetalle[i].destino = min.destino) and (registrosDetalle[i].fecha < min.fecha)) then begin
					iMin := i;
					min := registrosDetalle[i];
				end
				else
					if ((registrosDetalle[i].destino = min.destino) and (registrosDetalle[i].fecha = min.fecha) and (registrosDetalle[i].horaSalida = min.horaSalida)) then begin
						iMin := i;
						min := registrosDetalle[i];
					end;
	end;
	
	if (iMin <> -1) then 
		leer(detalles[iMin], registrosDetalle[iMin]);
end;

procedure actualizarMaestro (var maestro : archivo_maestro; var detalles : arrDetalles);
var
	min : tVuelos_detalle;
	registrosDetalle : arrRegistrosDetalle;
	regM : tVuelos_maestro;
begin
	reset(maestro);
	abrirDetalles(detalles);
	leerRegistrosDetalle(detalles, registrosDetalle);
	
	minimo(detalles, registrosDetalle, min);
	
	while (min.destino <> corte) do begin
		read(maestro, regM);
		
		while (regM.destino <> min.destino) do begin
			read(maestro, regM);
		end;
		
		while ((regM.destino = min.destino) and (regM.fecha = min.fecha) and (regM.horaSalida = min.horaSalida)) do begin
			regM.asientosDisponibles := regM.asientosDisponibles - min.asientosComprados;
			minimo(detalles, registrosDetalle, min);
		end;
		
		seek(maestro, filepos(maestro) - 1);
		write(maestro, regM);
		
	end;
	
	cerrarDetalles(detalles);
	close(maestro);
end;

procedure generarArchivoConAsientosPocoDisponibles (var maestro : archivo_maestro; var archivo : archivo_vuelos_pocos_asientos_disponibles; asientos : integer);
var
	regM : tVuelos_maestro;
	unVuelo : tVuelos_con_pocos_asientos_disponibles;
begin
	reset(maestro);
	rewrite(archivo);
	
	while (not eof(maestro)) do begin
		read(maestro, regM);
		
		if (regM.asientosDisponibles < asientos) then begin
			with unVuelo do begin
				destino := regM.destino;
				fecha := regM.fecha;
				horaSalida := regM.horaSalida;
			end;
			write(archivo, unVuelo);
		end;
	end;
	
	close(archivo);
	close(maestro);
end;
	

//programa principal
var
	maestro : archivo_maestro;
	detalles : arrDetalles;
	archivoConAsientosMinimos : archivo_vuelos_pocos_asientos_disponibles;
	asientos : integer;
begin
	assign(maestro, 'maestro');
	asignarDetalles(detalles);
	assign(archivoConAsientosMinimos,'vuelos_con_pocos_asientos_disponibles');
	actualizarMaestro(maestro, detalles);
	writeln('ingrese una cantidad de asientos especifica: '); readln(asientos);
	generarArchivoConAsientosPocoDisponibles(maestro, archivoConAsientosMinimos, asientos);
	
	
end.
