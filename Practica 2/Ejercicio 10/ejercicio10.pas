program diez;

const
	corte = 'zzzzzz';
	dimF = 15;
	
type
	rango = 1..dimF;
	
	arrValores = array [rango] of real;
	
	tEmpleado = record
		departamento : String;
		division : String;
		numEmpleado : integer;
		categoria : rango;
		horasExtras : integer;
	end;
	
	tResultado = record
		montoTotalDepartamento : real;
		horasTotalDepartamento : integer;
		montoTotalDivision : real;
		horasTotalDivision : integer;
		montoPorEmpleado : real;
		horasPorEmpleado : integer;
	end;
	
	
	archivoEmpleados = file of tEmpleado;
	
procedure leerArchivo (var arc : archivoEmpleados; var reg : tEmpleado);
begin
	if (not eof(arc)) then
		read(arc, reg)
	else
		reg.departamento := corte;
end;

procedure cargarVectorDeValores (var texto : Text; var vectorValores : arrValores);
var
	valor : real;
	categoria : rango;
begin
	reset(texto);
	
	while (not eof (texto)) do begin
		readln(texto, categoria, valor);
		vectorValores[categoria] := valor;	
	end;
	
	close(texto);
end;

procedure corteDeControl (var archivo : archivoEmpleados; vectorValores : arrValores);
var
	resultados : tResultado;
	empleadoActual : integer;
	categ : rango;
	divisionActual, departamentoActual : String;
	regM : tEmpleado;
begin
	reset(archivo);
	
	leerArchivo(archivo, regM);
	
	while (regM.departamento <> corte) do begin
		//asigno el departamento actual
		departamentoActual := regM.departamento;
		
		writeln('Departamento: ',departamentoActual);
		//inicializo los valore del departamento actual (horas y monto total)
		resultados.montoTotalDepartamento := 0;
		resultados.horasTotalDepartamento := 0;
		
		while (departamentoActual = regM.departamento) do begin
			//asigno la division actual
			divisionActual := regM.division;
			
			writeln('Division: ',divisionActual);
				
			//inicializo los valore de la division actual (horas y monto total)
			resultados.montoTotalDivision := 0;
			resultados.horasTotalDivision := 0;
			
			writeln('Numero de empleado     Total de hs.     Importe a cobrar');
			while ((departamentoActual = regM.departamento) and (divisionActual = regM.division)) do begin
				//asigno el empleado actual
				empleadoActual := regM.numEmpleado;
				//guardo la categoria actual para poder acceder al vector
				categ := regM.categoria;
				
				//inicializo los valore del empleado actual (horas y monto total)
				resultados.montoPorEmpleado := 0;
				resultados.horasPorEmpleado := 0;
				
				while ((departamentoActual = regM.departamento) and (divisionActual = regM.division) and (empleadoActual = regM.numEmpleado)) do begin
					{mientras el empleado sea igual al actual
					contabilizo las horas}
					resultados.horasPorEmpleado := resultados.horasPorEmpleado + regM.horasExtras;
					leerArchivo(archivo, regM);
				end;//end de empleados
				
				//el monto es igual al monto segun la categoria multiplicado por las horas extras
				resultados.montoPorEmpleado := (resultados.horasPorEmpleado * vectorValores[categ]);
				writeln(empleadoActual,'     ',resultados.horasPorEmpleado,'     ',resultados.montoPorEmpleado);
				
				//contabilizo los datos del empleado con los de la division actual
				resultados.horasTotalDivision := resultados.horasTotalDivision + resultados.horasPorEmpleado;
				resultados.montoTotalDivision := resultados.montoTotalDivision + resultados.montoPorEmpleado;
				
			end; //end de division
		
			writeln('Total de horas division: ',resultados.horasTotalDivision);
			writeln('Monto total por division: ',resultados.montoTotalDivision);
			
			//contabilizo los datos de la division con los del departamento actual
			resultados.montoTotalDepartamento := resultados.montoTotalDepartamento + resultados.montoTotalDivision;
			resultados.horasTotalDepartamento := resultados.horasTotalDepartamento + resultados.horasTotalDivision;
			
		
		end; //end de departamento
		
		writeln('Total horas departamento: ',resultados.horasTotalDepartamento);
		writeln('Monto total departamento: ',resultados.montoTotalDepartamento);
		
		
	end; //end del archivo
	
	close(archivo);
end;

//Programa principal
var
	archivo : archivoEmpleados;
	vectorValores : arrValores;
	textoConLosMontosPorHora : Text;
begin
	assign(textoConLosMontosPorHora,'montos_por_hora_segun_categoria.txt');
	assign(archivo,'archivo_empleados');
	
	cargarVectorDeValores(textoConLosMontosPorHora, vectorValores);
	corteDeControl(archivo, vectorValores);
end.
