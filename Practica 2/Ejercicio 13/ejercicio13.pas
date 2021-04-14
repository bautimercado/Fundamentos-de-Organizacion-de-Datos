program trece;

const
	corte = 32767;
	
type
	str15 = String[15];
	
	tLogs_maestro = record
		nro_usuario : integer;
		nombreUsuario : str15;
		nombre : str15;
		apellido : str15;
		mailsEnviados : integer;
	end;
	
	archivoMaestro = file of tLogs_maestro;
	
	tLogs_detalle = record
		nro_usuario : integer;
		cuentaDestino : str15;
		cuerpoMensaje : String;
	end;
	
	archivoDetalle = file of tLogs_detalle;
	
procedure leerArchivo (var arc : archivoDetalle; var reg : tLogs_detalle);
begin
	if (not eof(arc)) then
		read(arc, reg)
	else
		reg.nro_usuario := corte;
end;

procedure actualizarMaestro (var maestro : archivoMaestro; var detalleFis : String);
var
	detalle : archivoDetalle;
	regM : tLogs_maestro;
	regD : tLogs_detalle;
begin
	reset(maestro);
	assign(detalle, detalleFis);
	reset(detalle);
	
	leerArchivo(detalle, regD);
	while (regD.nro_usuario <> corte) do begin
		read(maestro, regM);
		
		while (regM.nro_usuario <> regD.nro_usuario) do
			read(maestro, regM);
			
		while (regM.nro_usuario = regD.nro_usuario) do begin
			regM.mailsEnviados := regM.mailsEnviados + 1;
			leerArchivo(detalle, regD);
		end;
		
		seek(maestro, filepos(maestro) - 1);
		write(maestro, regM);
	end;
	
	close(maestro);
	close(detalle);
	
end;

procedure generarTexto (var maestro : archivoMaestro; var detalleFis : String; var texto : Text);
var
	detalle : archivoDetalle;
	regM : tLogs_maestro;
	regD : tLogs_detalle;
	total : integer;
begin
	reset(maestro); 
	
	assign(detalle, detalleFis);
	reset(detalle); 
	
	rewrite(texto);
	
	leerArchivo(detalle, regD);
	
	while (regD.nro_usuario <> corte) do begin
		writeln(texto, 'numero_usuario ',regD.nro_usuario,' cantidadMensajesEnviados');
		writeln('numero_usuario ',regD.nro_usuario,' cantidadMensajesEnviados');
		total := 0;
		read(maestro, regM);
		
		if (regD.nro_usuario = regM.nro_usuario) then begin
			while (regM.nro_usuario = regD.nro_usuario) do begin
				total := total + 1;
				leerArchivo(detalle, regD);
			end;
		end
		
		else
			leerArchivo(detalle, regD);
		
		writeln(texto, total);
		writeln(total);
	
	end;

	close(texto);
	close(detalle);
	close(maestro);

end;

procedure menu();
begin
	writeln('///////////////////////////////////////////////////////////////////////');
	writeln('	Menu de opciones');
	writeln('		a.- actualizar maestro');
	writeln('		b.- generar archivo de texto');
	writeln('		c.- salir');
	writeln('///////////////////////////////////////////////////////////////////////');
end;

//Programa principal
var
	maestro : archivoMaestro;
	detalleFis : String;
	texto : Text;
	opcion : char;
begin
	assign(maestro, '/var/log/logmail.dat');
	assign(texto, 'mensajes_por_usuario.txt');
	
	repeat
		writeln('Ingrese el nombre del detalle');
		readln(detalleFis);
		menu();
		readln(opcion);
		
		case opcion of
			'a':actualizarMaestro(maestro, detalleFis);
			'b':generarTexto(maestro,detalleFis, texto);
			
			else
				writeln('Saliendo. . .');
		end;
		
	until (opcion = 'c');
	
	
end.

