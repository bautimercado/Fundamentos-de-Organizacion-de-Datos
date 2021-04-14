program cuatro;

uses sysutils;

const
	corteCodigo = 32767;
	corteFecha = 'zzzzzzzzzz';
	dimF = 5;

type
	rangoComputadoras = 1..dimF;
	str10 = String[10];
	
	tSesion_Detalle = record
		codUsuario : integer;
		fecha : str10;
		tiempoSesion : integer;
	end;
	
	archivoDetalle = file of tSesion_detalle;
	
	arrDetalles = array[rangoComputadoras] of archivoDetalle;
	
	arrRegistrosDetalle = array[rangoComputadoras] of tSesion_Detalle;
	
	tSesion_Maestro = record
		codUsuario : integer;
		fecha : str10;
		tiempoTotal : integer;
	end;

	archivoMaestro = file of tSesion_Maestro;
	
procedure leerSesion (var detalle : archivoDetalle; var registro : tSesion_Detalle);
begin
	
	if (not eof(detalle)) then
		read(detalle, registro)
	else
		registro.codUsuario := corteCodigo;

end;

procedure leerDetalles (var vectorDetalles : arrDetalles; var vectorRegistrosDetalle : arrRegistrosDetalle);
var
	i : integer;
begin
	
	for i := 1 to dimF do
		leerSesion(vectorDetalles[i], vectorRegistrosDetalle[i]);
		
end;

procedure asignarDetalles (var vectorDetalles : arrDetalles);
var
	i : integer;
begin
	
	for i := 1 to dimF do begin
		assign(vectorDetalles[i], 'detalle'+ IntToStr(i));
		reset(vectorDetalles[i]);
	end;
end;



procedure cerrarDetalles (var vectorDetalles : arrDetalles);
var
	i : integer;
begin
	
	for i := 1 to dimF do
		close(vectorDetalles[i]);

end;

procedure minimo (var vectorDetalles : arrDetalles; var vectorRegistrosDetalle : arrRegistrosDetalle; var min : tSesion_Detalle);
var
	i, iMin : integer;
begin
	iMin := -1;
	min.codUsuario := corteCodigo;
	min.fecha := corteFecha;
	
	for i := 1 to dimF do begin
		if (vectorRegistrosDetalle[i].codUsuario <> corteCodigo) then begin 
			if ((vectorRegistrosDetalle[i].codUsuario < min.codUsuario) or ((vectorRegistrosDetalle[i].codUsuario = min.codUsuario) and (vectorRegistrosDetalle[i].fecha < min.fecha))) then begin
				iMin := i;
				min := vectorRegistrosDetalle[i];
			end;
		end;
	end;
	
	if (iMin <> -1) then
		leerSesion(vectorDetalles[i], vectorRegistrosDetalle[i]);

end;



procedure generarMaestro (var maestro : archivoMaestro; var vectorDetalles : arrDetalles);
var
	vectorRegistrosDetalle : arrRegistrosDetalle;
	min : tSesion_Detalle;
	regM : tSesion_Maestro;

begin
	rewrite(maestro);
	
	asignarDetalles(vectorDetalles);
	writeln('todo ok');
	
	
	leerDetalles(vectorDetalles, vectorRegistrosDetalle);
	minimo(vectorDetalles, vectorRegistrosDetalle, min);
	
	//mientras siga teniendo elementos
	while (min.codUsuario <> corteCodigo) do begin
		//inicio los datos para el corte de control
		regM.tiempoTotal := 0;
		regM.codUsuario := min.codUsuario;
		regM.fecha := min.fecha;
		
		//mientras el usuario y la fecha sean la misma, contabilizo
		while ((regM.codUsuario = min.codUsuario) and (regM.fecha = min.fecha))do begin
			regM.tiempoTotal := regM.tiempoTotal + min.tiempoSesion;
			minimo(vectorDetalles, vectorRegistrosDetalle, min);
		end;
		
		if (regM.codUsuario <> min.codUsuario) then
			write(maestro, regM);

	end;
	writeln('Maestro cargado');
	
	close(maestro);
	cerrarDetalles(vectorDetalles);
	
end;

//Programa Principal
var
	maestro : archivoMaestro;
	vectorDetalles : arrDetalles;
begin
	assign(maestro,'var\log\Maestro');

	writeln('invocando');
	generarMaestro(maestro, vectorDetalles);
end.
