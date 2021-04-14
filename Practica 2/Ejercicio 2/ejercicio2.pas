program uno;

const
    valorAlto = 9999;

type
    rangoMateria = 0..1;
    
    tAlumno_Maestro = record
        codigoAlumno : integer;
        apellido : String;
        nombre : String;
        materiasSinFinal : integer;
        materiasConFinal : integer;
    end;

    tAlumno_Detalle = record
        codigoAlumno : integer;
        final_o_cursada : rangoMateria;
    end;

    archivoMaestro = file of tAlumno_Maestro;
    archivoDetalle = file of tAlumno_Detalle;

procedure cargarArchivoMaestro (var maestro : archivoMaestro; var alumnos : Text);
var
	unAlumno : tAlumno_Maestro;
begin
	reset(alumnos);
	rewrite(maestro);
	
	while (not eof(alumnos)) do begin
		readln(alumnos, unAlumno.codigoAlumno, unAlumno.apellido);
		readln(alumnos, unAlumno.nombre);
		readln(alumnos, unAlumno.materiasSinFinal, unAlumno.materiasConFinal);
		write(maestro, unAlumno);
		writeln('Se cargo un archivo');
	end;
	
	close(maestro);
	close(alumnos);
end;

procedure cargarArchivoDetalle (var detalle : archivoDetalle; var detalleTexto : Text);
var
    unAlumno : tAlumno_Detalle;
begin
    reset(detalleTexto); //abro el archivo de texto
    rewrite(detalle); //CREO el archivo binario

    while (not eof(detalleTexto)) do begin
        with unAlumno do
            readln(detalleTexto, codigoAlumno, final_o_cursada);
        write(detalle, unAlumno);
    end;

    close(detalle);
    close(detalleTexto);
end;

procedure reportarMaestro (var maestro : archivoMaestro; var reporteAlumnos : Text);
var
    unAlumno : tAlumno_Maestro;
begin
    reset(maestro);
    rewrite(reporteAlumnos);

    while (not eof(maestro)) do begin
        read(maestro, unAlumno);
        with unAlumno do
            writeln(reporteAlumnos, codigoAlumno, apellido, nombre, materiasSinFinal, materiasConFinal);
    end;

    close(reporteAlumnos);
    close(maestro);
end;

procedure reportarDetalle (var detalle : archivoDetalle; var reporteDetalle : Text);
var
    unAlumno : tAlumno_Detalle;
begin
    reset(detalle);
    rewrite(reporteDetalle);

    while (not eof(detalle)) do begin
        read(detalle, unAlumno);
        with unAlumno do
            writeln(reporteDetalle, codigoAlumno, final_o_cursada);
    end;

    close(reporteDetalle);
    close(detalle);
end;

procedure leer (var detalle : archivoDetalle; var unAlumno : tAlumno_Detalle);
begin
    if (not eof(detalle)) then
        read(detalle,unAlumno)
    else
        unAlumno.codigoAlumno := valorAlto;
end;

procedure actualizarMaestro (var maestro : archivoMaestro; var detalle : archivoDetalle);
var
    regM : tAlumno_Maestro;
    regD : tAlumno_Detalle;
begin
    reset(maestro);
    reset(detalle);

    leer(detalle,regD);
    while (regD.codigoAlumno <> valorAlto) do begin
        read(maestro, regM);
        
        while (regM.codigoAlumno <> regD.codigoAlumno) do
            read(maestro,regM);
        
        while (regM.codigoAlumno = regD.codigoAlumno) do begin
            if (regD.final_o_cursada = 1) then
                regM.materiasConFinal := regM.materiasConFinal + 1
            else
                regM.materiasSinFinal := regM.materiasSinFinal + 1;
            leer(detalle, regD); 
        end;

        seek(maestro, filepos(maestro) - 1);
        write(maestro, regM);
    end;
    close(detalle);
    close(maestro);
end;

procedure reportarAlumnosConMasDe4FinalesPendientes (var maestro : archivoMaestro; var texto : Text);
var
    unAlumno : tAlumno_Maestro;
begin
    reset(maestro);
    rewrite(texto);
    writeln;

    while (not eof(maestro)) do begin
        read(maestro, unAlumno);
        if (unAlumno.materiasSinFinal > 4) then begin
			writeln(texto,' ',unAlumno.codigoAlumno,' ',unAlumno.apellido,' ',unAlumno.nombre,' ',unAlumno.materiasConFinal,' ',unAlumno.materiasSinFinal);
        end;
    end;

    close(texto);
    close(maestro);
end;


procedure listarDatosMaestro (var maestro : archivoMaestro);
var
    unAlumno : tAlumno_Maestro;
begin
    reset(maestro);
    
    while (not eof(maestro)) do begin
        read(maestro, unAlumno);
        with unAlumno do begin
            write('Codigo de alumno: ',codigoAlumno,' apellido: ',apellido,' nombre :',nombre);
            writeln('Materias con final: ',materiasConFinal,' Materias sin final: ',materiasSinFinal);
        end;
    end;

    close(maestro);
end;

procedure listarDatosDetalle (var detalle : archivoDetalle);
var
    unAlumno : tAlumno_Detalle;
begin
    reset(detalle);
    
    while (not eof(detalle)) do begin
        read(detalle, unAlumno);
        with unAlumno do
            writeln('Codigo de alumno: ',codigoAlumno,' materia con final o sin: ',final_o_cursada); 
    end;

    close(detalle);
end;

procedure imprimirMenu();
begin
    writeln('   MENU DE OPCIONES  ');
    writeln('///////////////////////////////////////////////////');
    writeln('       a.- Generar archivo maestro (binario)');
    writeln('       b.- Generar archivo detalle (binario)');
    writeln('       c.- Mostrar datos del archivo maestro');
    writeln('       d.- Mostrar datos del archivo detalle');
    writeln('       e.- Actualizar archivo maestro');
    writeln('       f.- Resumir la informacion del archivo maestro');
    writeln('       g.- Resumir la informacion del archivo detalle');
    writeln('       h.- Generar un archivo de texto con aquellos alumnxs que tienen más de 4 cursadas sin final');
    writeln('       i.- Salir.');
    writeln('////////////////////////////////////////////////////');
    writeln;
end;


//Programa Principal
var
    maestro : archivoMaestro;
    detalle : archivoDetalle;
    maestroTexto, detalleTexto: Text; 
    reporteAlumnos, reporteDetalle, alumnosConMasCursadasSinFinal : Text;
    op : char;
begin
    
    assign(maestroTexto,'alumnos.txt');
    assign(detalleTexto,'detalle.txt');
    assign(maestro,'maestro_alumnos');
    assign(detalle,'detalle_alumnos');    
    assign(reporteAlumnos,'reporteAlumnos.txt');//reporte del archivo maestro :)
    assign(reporteDetalle,'reporteDetalle.txt');
    assign(alumnosConMasCursadasSinFinal,'alumnos_con_cursadas_sin_final.txt');

    repeat
        
        imprimirMenu();
        readln(op);
        case op of
            'a': cargarArchivoMaestro(maestro,maestroTexto); 
            'b': cargarArchivoDetalle(detalle,detalleTexto);
            'c': listarDatosMaestro(maestro);
            'd': listarDatosDetalle(detalle);
            'e': actualizarMaestro(maestro,detalle);
            'f': reportarMaestro(maestro,reporteAlumnos);
            'g': reportarDetalle(detalle,reporteDetalle);
            'h': reportarAlumnosConMasDe4FinalesPendientes(maestro,alumnosConMasCursadasSinFinal);
            else
                writeln('Saliendo. . .');
		end;
    
    until (op = 'i');
end.
