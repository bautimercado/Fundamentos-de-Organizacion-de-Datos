program uno;

const
	corte = 'fin';

type
	empleado = record
		numero : integer;
		nombre : String;
		apellido : String;
		edad : integer;
		dni : String;
	end;
	
	archivoEmpleado = file of empleado;
	
procedure leerEmpleado (var unEmpleado : empleado);
begin
	with unEmpleado do begin
		writeln('Ingrese apellido: '); readln(apellido);
		if (apellido <> corte) then begin
			writeln('Ingrese nombre: '); readln(nombre);
			writeln('Ingrese numero de empleado: '); readln(numero);
			writeln('Ingrese edad: '); readln(edad);
			writeln('Ingrese DNI: '); readln(dni);
		end;
	end;
end;

procedure cargarArchivo (var archivo : archivoEmpleado);
var
	unEmpleado : empleado;
begin
	rewrite(archivo);
	leerEmpleado(unEmpleado);
	while (unEmpleado.apellido <> corte) do begin
		write(archivo,unEmpleado);
		leerEmpleado(unEmpleado);
	end;
	close(archivo);
end;

procedure listarPorNombre (var archivo : archivoEmpleado; unNombre, unApellido : String);
var
	unEmpleado : empleado;
begin
	reset(archivo);
	while (not eof(archivo)) do begin
		read(archivo,unEmpleado);
		if ((unEmpleado.nombre = unNombre) or (unEmpleado.apellido = unApellido)) then
			with unEmpleado do
				writeln('Nombre: ',nombre,' Apellido: ',apellido,' Edad: ',edad,' DNI: ',dni,' Nro de empleado: ',numero); 
	end;
	close(archivo);
end;

procedure listarEmpleados (var archivo : archivoEmpleado);
var
	unEmpleado : empleado;
begin
	reset(archivo);
	while (not eof(archivo)) do begin
		read(archivo,unEmpleado);
		with unEmpleado do
			writeln('Nombre: ',nombre,' Apellido: ',apellido,' Edad: ',edad,' DNI: ',dni,' Nro de empleado: ',numero);
	end;
	close(archivo);
end;

procedure listarMayores (var archivo : archivoEmpleado);
var
	unEmpleado : empleado;
begin
	reset(archivo);
	while (not eof(archivo)) do begin
		read(archivo,unEmpleado);
		if (unEmpleado.edad > 70) then
			with unEmpleado do
				writeln('Nombre: ',nombre,' Apellido: ',apellido,' Edad: ',edad,' DNI: ',dni,' Nro de empleado: ',numero);
	end;
	close(archivo);
end;

procedure subMenu (var archivo : archivoEmpleado);
var
	op : char;
	unNombre, unApellido : String;
begin
	writeln('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
	writeln('Usted eligio la opcion 2');
	writeln('		a.- Listar empleados por nombre/apellido determinados');
	writeln('		b.- Listar empleados');
	writeln('		c.- Listar empleados mayores de 70');
	writeln('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
	readln(op);
	case op of
		'a' :begin
				writeln('Ingrese un nombre'); 
				readln(unNombre); readln(unApellido);
				listarPorNombre(archivo,unNombre,unApellido);
			 end;
		'b' :listarEmpleados(archivo);
		'c' :listarMayores(archivo);
	end;
end;

var
	archivo : archivoEmpleado;
	op : integer;
    archivoFisico : String;
begin
	writeln('Ingrese el nombre del archivo'); readln(archivoFisico);
	assign(archivo,archivoFisico);
	repeat
		writeln('********************************************');
		writeln('Menu de opciones: ');
		writeln('		0.- Salir del programa');
		writeln('		1.- Cargar el archivo');
		writeln('		2.- Abrir el archivo');
		writeln('********************************************');
		readln(op);
		case op of
			1 : cargarArchivo(archivo);
			2 : subMenu(archivo);
			else
				writeln('Saliendo.');
		end;
	until (op = 0);
end.
