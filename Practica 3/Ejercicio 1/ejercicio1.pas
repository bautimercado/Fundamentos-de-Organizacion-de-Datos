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

procedure agregarEmpleado (var archivo : archivoEmpleado);
var
    unEmpleado : empleado;
begin
    reset(archivo);
    seek(archivo, filesize(archivo));
    leerEmpleado(unEmpleado);
    while (unEmpleado.apellido <> corte) do begin
        write(archivo,unEmpleado);
        leerEmpleado(unEmpleado);
    end;
    close(archivo);
end;

//el proceso modifica la edad del empleado cuyo numero de empleado se corresponde con una variable
procedure modificarEdad (var archivo : archivoEmpleado; unNumero : integer);
var
    unEmpleado : empleado;
begin
    reset(archivo);
    while (not eof(archivo)) do begin
        read(archivo,unEmpleado);
        if (unEmpleado.numero = unNumero) then begin
            writeln('Ingrese una nueva edad: '); readln(unEmpleado.edad);
            seek(archivo,filepos(archivo) - 1);
            write(archivo,unEmpleado);
        end;
    end;
    close(archivo);
end;


procedure exportarContenido (var archivo : archivoEmpleado; var carga : Text);
var
    unEmpleado : empleado;
begin
    Rewrite(carga);
    reset(archivo);
    while (not eof(archivo)) do begin
        read(archivo,unEmpleado);
        with unEmpleado do begin
            writeln('Nombre: ',nombre,' Apellido: ',apellido,' Edad: ',edad,' DNI: ',dni,' Nro de empleado: ',numero);
            writeln(carga,' ',nombre,' ',apellido,' ',edad,' ',dni,' ',numero);
        end;
    end;
    close(archivo); close(carga);
end;


procedure exportarEmpleadosSinDNI (var archivo : archivoEmpleado; var empleadosSinDNI : Text);
var
    unEmpleado : empleado;
begin
    reset(archivo);
    rewrite(empleadosSinDNI);
    while (not eof(archivo)) do begin
        read(archivo,unEmpleado);
        if (unEmpleado.dni = '00') then begin
            with unEmpleado do begin
                writeln('Nombre: ',nombre,' Apellido: ',apellido,' Edad: ',edad,' DNI: ',dni,' Nro de empleado: ',numero);
                writeln(empleadosSinDNI,' ',nombre,' ',apellido,' ',edad,' ',dni,' ',numero);
			end;
        end;   
    end;
    close(archivo); close(empleadosSinDNI);
end;


//El registro que quiero eliminar puede no estar en el archivo
procedure darBajaPorDNI (var archivo : archivoEmpleado);
var
	unEmpleado : empleado;
	dniEliminar : String;
	pos : integer;
begin
	reset(archivo);
	writeln('Ingrese DNI a eliminar: '); readln(dniEliminar);
	read(archivo, unEmpleado);
	
	while ((not eof(archivo)) and (unEmpleado.dni <> dniEliminar)) do
		read(archivo, unEmpleado);
		
	if (not eof(archivo)) then begin
		//guardo la posicion donde se encontro el registro a eliminar
		pos := filepos(archivo) - 1;
		//voy al ultimo registro
		seek(archivo, filesize(archivo) - 1);
		//leo el ultimo registro
		read(archivo, unEmpleado);
		//me paro en la posicion donde estaba el registro a eliminar y lo piso
		seek(archivo, pos);
		write(archivo, unEmpleado);
		//trunco el archivo (desplazo la marca eof)
		seek(archivo, filesize(archivo) - 1);
		truncate(archivo);
		
	end
	else
		writeln('No se encontro al DNI ',dniEliminar);
	
end;



procedure subMenu (var archivo : archivoEmpleado; var carga, empleadosSinDNI : Text);
var
	op : char;
	unNombre, unApellido : String;
    unNumero : integer;
begin
	writeln('$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$');
	writeln('Usted eligio la opcion 2');
	writeln('		a.- Listar empleados por nombre/apellido determinados');
	writeln('		b.- Listar empleados');
	writeln('		c.- Listar empleados mayores de 70');
    writeln('		d.- Añadir empleado/s');
    writeln('		e.- Modificar edad');
    writeln('		f.- Exportar el contenido del archivo a un .txt');
    writeln('		g.- Exportar aquellos empleados cuyos dni sea 00 en un .txt');
    writeln('		h.- Dar de baja registros');
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
        'd' :agregarEmpleado(archivo);
        'e' :begin
                 writeln('Ingrese un numero de empleado: ');
                 readln(unNumero);
                 modificarEdad(archivo,unNumero);
             end;
        'f' :exportarContenido(archivo,carga);
        'g' :exportarEmpleadosSinDNI(archivo,empleadosSinDNI);
        'h' :darBajaPorDNI(archivo);
	end;
end;

var
	archivo : archivoEmpleado;
	op : integer;
    carga, empleadosSinDNI : Text;
begin
	assign(archivo,'archivoEmpleados');
    assign(carga,'todos_empleados');
    assign(empleadosSinDNI,'faltaDNIEmpleado');
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
			2 : subMenu(archivo,carga,empleadosSinDNI);
			else
				writeln('Saliendo.');
		end;
	until (op = 0);
end.
