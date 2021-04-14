program dos;

const
	valorAlto = 'zzz';

type
	str10 = String[10];
	
	tEmpleado = record
		nombre : str10;
		apellido : str10;
		dni : longint;
		fechaNacimiento : str10; 
	end;
	
	archivo_empleados = file of tEmpleado;
	
procedure leerEmpleado (var unEmpleado : tEmpleado);
begin
	with unEmpleado do begin
		writeln('Ingrese nombre del empleado'); readln(nombre);
		if (nombre <> valorAlto) then begin
			writeln('Ingrese apellido del empleado'); readln(apellido);
			writeln('Ingrese DNI del empleado'); readln(dni);
			writeln('Ingrese fecha de nacimiento del empleado'); readln(fechaNacimiento);
		end;
	end;
end;

procedure crearArchivo (var archivo : archivo_empleados);
var
	un_empleado : tEmpleado;
begin
	rewrite(archivo);
	leerEmpleado(un_empleado);
	while (un_empleado.nombre <> valorAlto) do begin
		write(archivo, un_empleado);
		leerEmpleado(un_empleado);
	end;
	
	close(archivo);
end;

procedure leerRegistro (var archivo : archivo_empleados; var reg : tEmpleado);
begin
	if (not eof(archivo)) then
		read(archivo, reg)
	else
		reg.nombre := valorAlto;
end;

procedure bajasLogicas (var archivo : archivo_empleados);
var
	un_empleado : tEmpleado;
begin
	reset(archivo);
	leerRegistro(archivo, un_empleado);
	
	while (un_empleado.nombre <> valorAlto) do begin
		
		if (un_empleado.dni < 8000000) then begin
			un_empleado.nombre := '*'+un_empleado.nombre;
			seek(archivo, filepos(archivo) - 1);
			write(archivo, un_empleado);
		end;
		
		leerRegistro(archivo, un_empleado);
	end;
	
	close(archivo);
end;

procedure listarDatos (var archivo : archivo_empleados);
var
	reg : tEmpleado;
begin
	reset(archivo);
	while (not eof(archivo)) do begin
		read(archivo, reg);
		with reg do
			writeln(nombre,' ',apellido,' ',dni,' ',fechaNacimiento);
	end;
	
	close(archivo);
end;


//Programa principal
var
	archivo : archivo_empleados;
begin
	assign(archivo, 'archivo_empleados');
	crearArchivo(archivo);
	bajasLogicas(archivo);
	listarDatos(archivo);
end.
