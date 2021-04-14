program dieciseis;

uses sysutils;

const
	corte = 'zzzzz';
	dimF = 100;
	
type
	str10 = String[10];
	str20 = String[20];
	rango = 1..dimF;
	
	tEmision = record
		fecha : str10;
		cod : str10;
		nombre : str20;
		descripcion : str20;
		precio : real;
		totalEjemplares : integer;
		totalEjemplaresVendidos : integer;
	end;
	
	archivoMaestro = file of tEmision;
	
	tDetalle = record
		fecha : str10;
		cod : str10;
		ejemplaresVendidos : integer;
	end;
	
	archivoDetalle = file of tDetalle;
	
	arrDetalles = array [rango] of archivoDetalle;
	
	arrRegistrosDetalle = array [rango] of tDetalle;
	
	tSemanarioFinal = record
		fecha : str10;
		cod : str10;
		ventas : integer;
	end;

procedure leer (var arc : archivoDetalle; var reg : tDetalle);
begin
	if (not eof(arc)) then
		read(arc, reg)
	else
		reg.fecha := corte;
end;

procedure asignarDetalles (var detalles : arrDetalles);
var
	i : integer;
begin
	for i := 1 to dimF do
		assign(detalles[i], 'detalle' + IntToStr(i));
end;

procedure abrirDetalles (var detalles : arrDetalles);
var
	i : integer;
begin
	for i := 1 to dimF do
		reset(detalles[i]);
end;

procedure iniciarRegistrosDetalle (var detalles : arrDetalles; var registrosDetalle : arrRegistrosDetalle);
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

procedure minimo (var detalles : arrDetalles; var registrosDetalle : arrRegistrosDetalle; var min : tDetalle);
var
	i, iMin : integer;
begin
	iMin := -1;
	
	with min do begin
		fecha := corte;
		cod := corte;
	end;
	
	for i := 1 to dimF do begin
		
		if (registrosDetalle[i].fecha <> corte) then begin
			
			if (registrosDetalle[i].fecha < min.fecha) then begin
				iMin := i;
				min := registrosDetalle[i];
			end
			
			else
				if ((registrosDetalle[i].fecha = min.fecha) and (registrosDetalle[i].cod < min.cod)) then begin
					iMin := i;
					min := registrosDetalle[i];
				end;
		end;
	
	end;
	
	if (iMin <> -1) then
		leer(detalles[iMin], registrosDetalle[iMin]);
	
end;

procedure actualizarMaestro (var maestro : archivoMaestro; var detalles : arrDetalles);
var
	regM : tEmision;
	registrosDetalle : arrRegistrosDetalle;
	min : tDetalle;
begin
	reset(maestro);
	abrirDetalles(detalles);
	iniciarRegistrosDetalle(detalles, registrosDetalle);
	
	minimo(detalles, registrosDetalle, min);
	while (min.fecha <> corte) do begin
		read(maestro, regM);
		
		while (regM.fecha <> min.fecha) do
			read(maestro, regM);
		
		while ((regM.fecha = min.fecha) and (regM.cod = min.cod)) do begin
			regM.totalEjemplaresVendidos += min.ejemplaresVendidos;
			minimo(detalles, registrosDetalle, min);
		end;
		
		seek(maestro, filepos(maestro) - 1);
		write(maestro, regM);
		
	end;
	
	cerrarDetalles(detalles);
	close(maestro);
end;

procedure semanarioMaximo_Minimo (var maestro : archivoMaestro);
var
	min : tSemanarioFinal;
	max : tSemanarioFinal;
	regM : tEmision;
begin
	reset(maestro);
	
	with min do begin
		fecha := corte;
		cod := corte;
		ventas := 32767;
	end;
	
	with max do begin
		//el caracter espacio es un valor bajo en la tabla ascii
		fecha := ' ';
		cod := ' ';
		ventas := -32767;
	end;
	
	while (not eof(maestro)) do begin
		read(maestro, regM);
		if (regM.totalEjemplaresVendidos < max.ventas) then begin
			with max do begin
				fecha := regM.fecha;
				cod := regM.cod;
				ventas := regM.totalEjemplaresVendidos;
			end;
		end;
		
		if (regM.totalEjemplaresVendidos > min.ventas) then begin
			with min do begin
				fecha := regM.fecha;
				cod := regM.cod;
				ventas := regM.totalEjemplaresVendidos;
			end;
		end;
	end;
	
	writeln('El semanario que mas vendio: ');
	writeln('Fecha: ',max.fecha,' codigo de semanario: ',max.cod);
	writeln('El semanario que menos vendio: ');
	writeln('Fecha: ',min.fecha,' codigo de semanario: ',min.cod);


	close(maestro);
end;

//Programa principal
var
	maestro : archivoMaestro;
	detalles : arrDetalles;
begin
	assign(maestro, 'maestro');
	asignarDetalles(detalles);
	actualizarMaestro(maestro, detalles);
	semanarioMaximo_Minimo(maestro);
end.
