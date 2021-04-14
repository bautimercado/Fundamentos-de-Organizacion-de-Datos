program quince;

uses sysutils;

const
	corte = 32767;
	N = 15; //15 como ejemplo

type
	rango = 1..N;
	
	tAlumnos = record
		dni_alumno : integer;
		cod_carrera : integer;
		monto_pagado : real;
	end;
	
	archivo_maestro = file of tAlumnos;
	
	tRapiPago = record
		dni_alumno : integer;
		cod_carrera : integer;
		monto_cuota : real;
	end;
	
	archivo_detalle = file of tRapiPago;
	
	arr_Detalles = array [rango] of archivo_detalle; 
	
	arr_registros_detalle = array [rango] of tRapiPago;
	
	tAlumnos_morosos = record
		dni_alumno : integer;
		cod_carrera : integer;
	end;
	
procedure leer (var arc : archivo_detalle; var reg : tRapiPago);
begin
	if (not eof(arc)) then
		read(arc, reg)
	else
		reg.dni_alumno := corte;
end;

procedure asignarDetalles (var detalles : arr_Detalles);
var
	i : integer;
begin
	for i := 1 to N do
		assign(detalles[i], 'detalle_' + IntToStr(i));
end;

procedure abrirDetalles (var detalles : arr_Detalles);
var
	i : integer;
begin
	for i := 1 to N do
		reset(detalles[i]);
end;

procedure iniciarRegistrosDetalle (var detalles : arr_Detalles; var registros_detalle : arr_registros_detalle);
var
	i : integer;
begin
	for i := 1 to N do
		leer(detalles[i], registros_detalle[i]);
end;

procedure cerrarDetalles (var detalles : arr_Detalles);
var
	i : integer;
begin
	for i := 1 to N do
		close(detalles[i]);
end;

procedure minimo (var detalles : arr_Detalles; var registros_detalle : arr_registros_detalle; var min : tRapiPago);
var
	i, iMin : integer;
begin
	iMin := -1;
	
	with min do begin
		dni_alumno := corte;
		cod_carrera := corte;
	end;
	
	for i := 1 to N do begin
		if (registros_detalle[i].dni_alumno <> corte) then begin
			if (registros_detalle[i].dni_alumno < min.dni_alumno) then begin
				iMin := i;
				min := registros_detalle[i];
			end
			else
				if ((registros_detalle[i].dni_alumno = min.dni_alumno) and (registros_detalle[i].cod_carrera < min.cod_carrera)) then begin
					iMin := i;
					min := registros_detalle[i]; 
				end;
		
		end;
	end;

	if (iMin <> -1) then
		leer(detalles[i], registros_detalle[i]);
end;

procedure actualizarMaestro (var maestro : archivo_maestro; var detalles : arr_Detalles);
var
	regM : tAlumnos;
	min : tRapiPago;
	registros_detalle : arr_registros_detalle;
begin
	reset(maestro);
	abrirDetalles(detalles);
	
	iniciarRegistrosDetalle(detalles, registros_detalle);
	minimo(detalles, registros_detalle, min);
	
	while (min.dni_alumno <> corte) do begin
		read(maestro, regM);
		
		while (regM.dni_alumno <> min.dni_alumno) do
			read(maestro, regM);
		
		while ((regM.dni_alumno = min.dni_alumno) and (regM.cod_carrera = min.cod_carrera)) do begin
			regM.monto_pagado += min.monto_cuota;
			minimo(detalles, registros_detalle, min);
		end;
		
		seek(maestro, filePos(maestro) - 1);
		write(maestro, regM);
			
	end;
	
	cerrarDetalles(detalles);
	close(maestro);
end;

procedure generarTexto (var maestro : archivo_maestro; var texto : Text);
var
	regM : tAlumnos;
	unAlumno : tAlumnos_morosos;
begin
	reset(maestro);
	rewrite(texto);
	read(maestro, regM);
	
	while (not eof(maestro)) do begin
		
		unAlumno.dni_alumno := regM.dni_alumno;
		
		while (unAlumno.dni_alumno = regM.dni_alumno) do begin
			unAlumno.cod_carrera := regM.cod_carrera;
			
			if (regM.monto_pagado <= 0) then
				with unAlumno do
					writeln(texto,' ',dni_alumno,' ',cod_carrera,' alumno moroso');
					
			read(maestro, regM);
			
		end;
		
	
	end;

end;

//Programa principal
var
	maestro : archivo_maestro;
	detalles : arr_Detalles;
	texto : Text;
begin
	assign(maestro,'maestro_alumnos');
	asignarDetalles(detalles);
	assign(texto, 'alumnos_morosos.txt');
	
	actualizarMaestro(maestro, detalles);
	generarTexto(maestro, texto);
end.
