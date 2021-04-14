program cinco;

uses sysutils;

const
	corte = 32767;
	dimF = 50;
	
type
	rango = 1..dimF;
	str15 = String[15];
	
	tDireccion = record
		calle : integer;
		numero : integer;
		piso : integer;
		depto : integer;
		ciudad : str15;
	end;
	
	tPersona = record
		nombre : str15;
		apellido : str15;
		dni : str15;
	end;
	
	tNacimiento = record
		numeroPartida : integer;
		nombre : str15;
		apellido : str15;
		matriculaMedico : str15;
		madre : tPersona;
		padre : tPersona;
		direccion : tDireccion;
	end;
	
	archivoNacimiento = file of tNacimiento;
	
	arrNacimientos = array [rango] of archivoNacimiento;
	
	arrRegistrosNacimiento = array [rango] of tNacimiento;
	
	tDefuncion = record
		numeroPartida : integer;
		nombre : str15;
		apellido : str15;
		matriculaMedico : str15;
		fecha : str15;
		hora : str15;
		lugar : str15;
	end;
	
	archivoDefuncion = file of tDefuncion;

	arrDefunciones = array [rango] of archivoDefuncion;
	
	arrRegistrosDefuncion = array [rango] of tDefuncion;
	
	tMaestro = record
		partidaDeNacimiento : tNacimiento;
		vivo : boolean;
		matriculaMedicoDefuncion : str15;
		fecha : str15;
		hora : str15;
		lugar : str15;
	end;
	
	archivoMaestro = file of tMaestro;

//Procesos de archivos nacimiento
	
procedure leerNacimiento (var archivo : archivoNacimiento; var reg : tNacimiento);
begin
	if (not eof(archivo)) then
		read(archivo, reg)
	else
		reg.numeroPartida := corte;
end;

procedure asignarArchivosNacimiento (var vectorArchivosNacimientos : arrNacimientos);
var
	i : integer;
begin
	for i := 1 to dimF do
		assign(vectorArchivosNacimientos[i], 'detalle_nacimento_' + IntToStr(i));
end;

procedure abrirArchivosNacimiento(var vectorArchivosNacimientos : arrNacimientos);
var
	i : integer;
begin
	for i := 1 to dimF do
		reset(vectorArchivosNacimientos[i]);
end;

procedure cerrarArchivosNacimiento(var vectorArchivosNacimientos : arrNacimientos);
var
	i : integer;
begin
	for i := 1 to dimF do
		close(vectorArchivosNacimientos[i]);
end;

procedure leerArchivosNacimiento (var vectorArchivosNacimientos : arrNacimientos; var registrosNacimiento : arrRegistrosNacimiento);
var
	i : integer;
begin
	for i := 1 to dimF do;
		leerNacimiento(vectorArchivosNacimientos[i], registrosNacimiento[i]);
end;

procedure minimoDetallesNacimiento (var vectorArchivosNacimientos : arrNacimientos; var registrosNacimiento : arrRegistrosNacimiento; var min : tNacimiento);
var
	i, iMin : integer;
begin
	iMin := -1;
	min.numeroPartida := corte;
	
	for i := 1 to dimF do begin
		
		if ((registrosNacimiento[i].numeroPartida <> corte) and (registrosNacimiento[i].numeroPartida < min.numeroPartida)) then begin
			iMin := i;
			min := registrosNacimiento[i];
		end;
	end;
	
	if (iMin <> -1) then
		leerNacimiento(vectorArchivosNacimientos[iMin],registrosNacimiento[iMin]);
end;

procedure generarMaestroNacimientos (var maestroNacimientos : archivoNacimiento; var vectorArchivosNacimientos : arrNacimientos);
var
	registrosNacimiento : arrRegistrosNacimiento;
	min : tNacimiento;
begin

	rewrite(maestroNacimientos);
	abrirArchivosNacimiento(vectorArchivosNacimientos);
	leerArchivosNacimiento(vectorArchivosNacimientos, registrosNacimiento);
	minimoDetallesNacimiento(vectorArchivosNacimientos, registrosNacimiento, min);
	
	while (min.numeroPartida <> corte) do begin
		write(maestroNacimientos, min);
		minimoDetallesNacimiento(vectorArchivosNacimientos, registrosNacimiento, min);
	end;
	
	writeln('Archivo maestro de nacimientos cargado con exito');
	
	cerrarArchivosNacimiento(vectorArchivosNacimientos);
	close(maestroNacimientos);

end;

//Procesos de archivos de defuncion

procedure leerDefuncion (var archivo : archivoDefuncion; var reg : tDefuncion);
begin
	if (not eof(archivo)) then
		read(archivo, reg)
	else
		reg.numeroPartida := corte;
end;

procedure asignarArchivosDefuncion (var vectorArchivosDefuncion : arrDefunciones);
var
	i : integer;
begin
	for i := 1 to dimF do
		assign(vectorArchivosDefuncion[i], 'detalle_defuncion_' + IntToStr(i));
end;

procedure abrirArchivosDefuncion (var vectorArchivosDefuncion : arrDefunciones);
var
	i : integer;
begin
	for i := 1 to dimF do
		reset(vectorArchivosDefuncion[i]);
end;

procedure cerrarArchivosDefuncion (var vectorArchivosDefuncion : arrDefunciones);
var
	i : integer;
begin
	for i := 1 to dimF do
		close(vectorArchivosDefuncion[i]);
end;

procedure leerArchivosDefuncion (var vectorArchivosDefuncion : arrDefunciones; var registrosDefuncion : arrRegistrosDefuncion);
var
	i : integer;
begin
	for i := 1 to dimF do
		leerDefuncion(vectorArchivosDefuncion[i], registrosDefuncion[i]);
end;

procedure minimoDetallesDefuncion (var vectorArchivosDefuncion : arrDefunciones; var registrosDefuncion : arrRegistrosDefuncion; var min : tDefuncion);
var
	i, iMin : integer;
begin
	iMin := -1;
	min.numeroPartida := corte;
	
	for i := 1 to dimF do begin
		if ((registrosDefuncion[i].numeroPartida <> corte) and (registrosDefuncion[i].numeroPartida < min.numeroPartida)) then begin
			min := registrosDefuncion[i];
			iMin := i;
		end;
	end;
	
	if (iMin <> -1) then
		leerDefuncion(vectorArchivosDefuncion[iMin], registrosDefuncion[iMin]);
end;

procedure generarMaestroDefunciones (var maestroDefunciones : archivoDefuncion; var vectorArchivosDefuncion : arrDefunciones);
var
	registrosDefuncion : arrRegistrosDefuncion;
	min : tDefuncion;
begin
	rewrite(maestroDefunciones);
	abrirArchivosDefuncion(vectorArchivosDefuncion);
	leerArchivosDefuncion(vectorArchivosDefuncion, registrosDefuncion);
	
	minimoDetallesDefuncion(vectorArchivosDefuncion, registrosDefuncion, min);
	while (min.numeroPartida <> corte) do begin
		write(maestroDefunciones, min);
		minimoDetallesDefuncion(vectorArchivosDefuncion, registrosDefuncion, min);
	end;
	
	writeln('Archivo maestro de defunciones cargado con exito');
	
	cerrarArchivosDefuncion(vectorArchivosDefuncion);
	close(maestroDefunciones);
end;

function esLaMismaPersona (regD : tDefuncion; regN : tNacimiento):boolean;
begin
	if ((regD.numeroPartida = regN.numeroPartida) and (regD.nombre = regN.nombre) and (regD.apellido = regD.apellido)) then
		esLaMismaPersona := True
	else
		esLaMismaPersona := False;
end;


procedure generarMaestro (var maestro : archivoMaestro; var nacimientos : archivoNacimiento; var defunciones : archivoDefuncion);
var
	regN : tNacimiento;
	regD : tDefuncion;
	regM : tMaestro;
begin
	rewrite(maestro);
	reset(nacimientos);
	reset(defunciones);
	
	leerDefuncion(defunciones, regD);
	leerNacimiento(nacimientos, regN);
	
	while ((regN.numeroPartida <> corte) or (regD.numeroPartida <> corte)) do begin
		regM.partidaDeNacimiento := regN;
		//regM.partidaDeNacimiento es un registro de tipo tNacimiento
		if (esLaMismaPersona(regD, regN)) then begin
			regM.vivo := False;
			regM.fecha := regD.fecha;
			regM.hora := regD.hora;
			regM.lugar := regM.lugar;
		end
		else
			regM.vivo := True;
			
		write(maestro, regM);
		leerDefuncion(defunciones, regD);
		leerNacimiento(nacimientos, regN);
	end;
	
	writeln('Gran maestro cargado con exito');
	
	close(defunciones);
	close(nacimientos);
	close(maestro);
end;

procedure generarTexto (var maestro : archivoMaestro; var texto : Text);
var
	regM : tMaestro;
begin
	reset(maestro);
	rewrite(texto);
	
	while (not eof(maestro)) do begin
		read(maestro, regM);
		with regM do begin
			
			with partidaDeNacimiento do begin
				write(texto,' ',numeroPartida,' ',nombre,' ',apellido,' ',matriculaMedico);
				with madre do
					write(texto,' ',nombre,' ',apellido,' ',dni);
				with padre do
					write(texto,' ',nombre,' ',apellido,' ',dni);
				with direccion do
					write(texto,' ',calle,' ',numero,' ',piso,' ',depto,' ',ciudad);
			end;
			
			if (not vivo) then
				write(texto,' ',matriculaMedicoDefuncion,' ',fecha,' ',hora,' ',lugar);
			writeln(texto,'.');
			
		end;
	end;
	
	close(texto);
	close(maestro);
end;

//Programa Principal
var
	vectorArchivosDefuncion : arrDefunciones;
	vectorArchivosNacimientos : arrNacimientos;
	maestroDefunciones : archivoDefuncion;
	maestroNacimientos : archivoNacimiento;
	gMaestro : archivoMaestro;
	texto : Text;

begin
	asignarArchivosDefuncion(vectorArchivosDefuncion);
	asignarArchivosNacimiento(vectorArchivosNacimientos);
	assign(maestroDefunciones, 'maestro_defunciones');
	assign(maestroNacimientos, 'maestro_nacimientos');
	assign(gMaestro, 'maestro');
	assign(texto, 'texto.txt');
	
	generarMaestroNacimientos(maestroNacimientos, vectorArchivosNacimientos);
	generarMaestroDefunciones(maestroDefunciones, vectorArchivosDefuncion);
	generarMaestro(gMaestro, maestroNacimientos, maestroDefunciones);
	generarTexto(gMaestro, texto);
	
end.
