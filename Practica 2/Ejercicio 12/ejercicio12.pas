program doce;

const
	corte = 32767;
	
type
	tActuales = record
		mes : integer;
		usuario : integer;
		dia : integer;
		anio : integer;
	end;
	
	tResultado = record
		tiempoPorUsuario : integer;
		tiempoPorDia : integer;
		tiempoPorMes : integer;
		tiempoPorAnio : integer;
	end;
	
	tAcceso = record
		anio : integer;
		mes : integer;
		dia : integer;
		idUsuario : integer;
		tiempo : integer;
	end;
	
	archivoAccesos = file of tAcceso;
	
procedure leerArchivo (var arc : archivoAccesos; var reg : tAcceso);
begin
	if (not eof(arc)) then
		read(arc, reg)
	else
		reg.anio := corte;
end;

var
	anioInformar : integer;
	reg : tAcceso;
	archivo : archivoAccesos;
	act : tActuales;
	result : tResultado;
begin
	assign(archivo, 'archivo_accesos_de_usuarios');
	reset(archivo);
	
	writeln('Ingrese un año: '); readln(anioInformar);
	leerArchivo(archivo, reg);
	while ((reg.anio <> corte) and (reg.anio <> anioInformar)) do
			leerArchivo(archivo, reg);
	if (not reg.anio = anioInformar) then
		writeln('Año no encontrado')
	
	else begin
		act.anio := reg.anio;
		writeln('Año: ',act.anio);
		result.tiempoPorAnio := 0;
		
		while (act.anio = reg.anio) do begin
			act.mes := reg.mes;
			writeln('  Mes: ',act.mes);
			result.tiempoPorMes := 0;
			
			while ((act.anio = reg.anio) and (act.mes = reg.mes)) do begin
				act.dia := reg.dia;
				writeln('    Dia: ',act.dia);
				result.tiempoPorDia := 0;
				
				while ((act.anio = reg.anio) and (act.mes = reg.mes) and (act.dia = reg.dia)) do begin
					act.usuario := reg.idUsuario;
					writeln('      idUsuario ',act.usuario,'    Tiempo total de acceso en el dia ',act.dia,' mes ',act.mes);
					//writeln('      idUsuario ',act.usuario,'    Tiempo Total de acceso en el dia ',act.dia,' mes '.act.mes);
					result.tiempoPorUsuario := 0;
					
					while ((act.anio = reg.anio) and (act.mes = reg.mes) and (act.dia = reg.dia) and (act.usuario = reg.idUsuario)) do begin
						result.tiempoPorUsuario := reg.tiempo;
						leerArchivo(archivo, reg);
					end; //end de usuario
					writeln('      ',result.tiempoPorUsuario);
					result.tiempoPorDia := result.tiempoPorDia + result.tiempoPorUsuario;
				
				end;//end de dia
				writeln('    Tiempo total del dia ',act.dia,' mes ',act.mes);
				result.tiempoPorMes := result.tiempoPorMes + result.tiempoPorDia;
				writeln('    ',result.tiempoPorDia);
			
			end;//end del mes
			writeln('  Total tiempo de acceso mes ',act.mes);
			result.tiempoPorAnio := result.tiempoPorAnio + result.tiempoPorMes;
			writeln('  ',result.tiempoPorMes);
			
		end;//end del año
		writeln('Tiempo total de acceso año', act.anio);
		writeln(result.tiempoPorAnio);
	
	end;//end del else
	close(archivo);

end.
