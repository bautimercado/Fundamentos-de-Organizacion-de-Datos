program ocho;

const
	corte = 32767;
	
type
	str15 = String[15];
	rMeses = 1..12;
	
	tCliente = record
		cod : integer;
		nombre : str15;
		apellido : str15;
	end;
	
	tVenta = record
		cliente : tCliente;
		anio : integer;
		mes: rMeses;
		monto : real;
	end;
	
	archivoMaestro = file of tVenta;
	
procedure leerVenta (var archivo : archivoMaestro; var registro : tVenta);
begin
	if (not eof(archivo)) then
		read(archivo, registro)
	else
		registro.cliente.cod := corte;
end;

procedure corteDeControl (var maestro : archivoMaestro);
var
	regM, aux : tVenta;
	montoMensual, montoAnual, montoTotal: real;
begin
	reset(maestro);	
	montoMensual := 0; montoAnual := 0; montoTotal := 0;
	leerVenta(maestro, regM);
	
	while (regM.cliente.cod <> corte) do begin
		aux := regM;
		
		while ((aux.cliente.cod = regM.cliente.cod) and (aux.anio = regM.anio) and (aux.mes = regM.mes)) do begin
			with aux do
				with cliente do
					writeln('Nombre: ',nombre,' apellido: ',apellido,' codigo: ',cod);
			montoMensual := montoMensual + regM.monto;
			leerVenta(maestro, regM);
		end;
		writeln('En el mes ',aux.mes,' el cliente gasto: ',montoMensual);
		montoAnual := montoAnual + montoMensual;
		montoMensual := 0;
		
		if (aux.anio <> regM.anio) then begin
			writeln('En el año ',aux.anio,' el cliente gasto: ',montoAnual);
			montoTotal := montoTotal + montoAnual;
			montoAnual := 0;
		end;
	end;
	writeln('El monto total obtenido por la empresa es: ',montoTotal);

end;

//Programa principal
var
	maestro : archivoMaestro;
begin
	
	assign(maestro, 'maestro');
	corteDeControl(maestro);
	
end.
