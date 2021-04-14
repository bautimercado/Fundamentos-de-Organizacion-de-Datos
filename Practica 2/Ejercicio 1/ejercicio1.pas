program uno;
const
    valorAlto = 999;

type
    comision = record  
        nombre:String;
        cod:integer;
        monto:real;
    end;

    archivoComision = file of comision;

procedure leerDato (var arc : archivoComision; var dat:comision);
begin
    if (not eof(arc)) then
        read(arc,dat)
    else
        dat.cod := valorAlto;
end;

procedure generarArchivoBinario (var archivo : archivoComision; var texto : Text);
var
	unaComision : comision;
begin
	reset(texto);
	rewrite(archivo);
	
	while (not eof(texto)) do begin
		readln(texto, unaComision.cod, unaComision.nombre);
		readln(texto, unaComision.monto);
		write(archivo, unaComision);
	end;
	
	close(archivo);
	close(texto);

end;

procedure compactarArchivo (var archivo : archivoComision; var compacto : archivoComision);
var
    regDet, regMae : comision;
    codActual : integer;
begin
    reset(archivo);
    rewrite(compacto);
    
    leerDato(archivo,regDet);
    while (regDet.cod <> valorAlto) do begin
        codActual := regDet.cod;
        regMae.monto := 0;
        regMae.nombre := regDet.nombre;

        while (codActual = regDet.cod) do begin
            regMae.monto := regMae.monto + regDet.monto;
            leerDato(archivo,regDet);
        end;

        regMae.cod := codActual;
        write(compacto,regMae);

    end;

    close(archivo);
    close(compacto);    
end;

{Deberia quedar:
    1 Marcelo 2450
    2 Angeles 2500
    3 Fabian  4600
    4 Carlos  5000
    5 Lucia   3600
}

procedure listarDatos (var archivo : archivoComision);
var
    unaComision : comision;
begin
    reset(archivo);
    while (not eof(archivo)) do begin
        
        read(archivo,unaComision);
        with unaComision do
            writeln('Codigo: ',cod,' Nombre: ',nombre,' Monto: ',monto:4:2);
        
    end;
    close(archivo);
end;


//Programa Principal
var
    archivoComisionTexto : Text;
    compacto, archivoBinario : archivoComision;

begin
    assign(archivoComisionTexto,'comisiones.txt');
    assign(archivoBinario,'archivo_comision');
    assign(compacto,'archivo_comisiones_compactos');

    generarArchivoBinario(archivoBinario,archivoComisionTexto);
    writeln('Archivo binario');
    listarDatos(archivoBinario);
    compactarArchivo(archivoBinario,compacto);
    writeln('Archivo compacto');
    listarDatos(compacto);
end.



