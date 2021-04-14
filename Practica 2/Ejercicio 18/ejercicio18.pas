program dieciocho;

const
	valor_alto = 'zzzzzz';
	
type
	str10 = String[10];
	
	tEvento = record
		nombre : str10;
		fecha : str10;
		sector : str10;
		entradas_vendidas : integer;
	end;
	
	tResultados = record
		entradas_nombre : integer;
		entradas_fecha : integer;
	end;
	
	archivo_maestro = file of tEvento;
	
procedure leer (var arc : archivo_maestro; var reg : tEvento);
begin
	if (not eof(arc)) then
		read(arc, reg)
	else
		reg.nombre := valor_alto;
end;

procedure corteDeControl (var maestro : archivo_maestro);
var
	regM, act : tEvento;
	res : tResultados;
begin
	reset(maestro);
	
	writeln('CANTIDAD DE ENTRADAS VENDIDAS POR FUNCIÓN Y POR EVENTO');
	writeln();
	
	leer(maestro, regM);
	while (regM.nombre <> valor_alto) do begin
		act.nombre := regM.nombre;
		writeln('NOMBRE Evento: ',act.nombre);
		res.entradas_nombre := 0;
		
		while (act.nombre = regM.nombre) do begin
			act.fecha := regM.fecha;
			writeln('  Fecha funcion: ',act.fecha);
			res.entradas_fecha := 0;
			
			while ((act.nombre = regM.nombre) and (act.fecha = regM.fecha)) do begin
				writeln('    Sector      Cantidad vendida');
				writeln('    ',regM.sector,'      ',regM.entradas_vendidas);
				res.entradas_fecha += regM.entradas_vendidas;
				leer(maestro, regM);
			end;// end de fecha
			
			writeln('  ----------------------------------------------------------------------------------------------');
			writeln('  Cantidad total de entradas vendidas por funcion ',act.fecha,': ',res.entradas_fecha);
			res.entradas_nombre += res.entradas_fecha;
			
		
		end;//end de nombre
		
		writeln('----------------------------------------------------------------------------------------------');
		writeln('Cantidad total vendidas por evento ',act.nombre,': ',res.entradas_nombre);
	end;//end del maestro

	close(maestro);
end;

//Programa principal
var
	maestro : archivo_maestro;
begin
	assign(maestro, 'maestro');
	corteDeControl(maestro);
end.

