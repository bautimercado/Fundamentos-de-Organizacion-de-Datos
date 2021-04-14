program cuatro;

uses sysutils;

type
	tTitulo = String[50];
	
	tArchRevistas = file of tTitulo;
	
procedure darDeAlta (var a : tArchRevistas; titulo : String);
var
	unTitulo : String[50];
	cabecera, cod : integer;
begin
	reset(a);
	read(a, unTitulo);
	//casteo el valor del reg. cabecera de string a integer
	val(unTitulo, cabecera, cod);
	//no compruebo el valor de cod ya que el cabecera siempre tiene un digito numerico
	
	if (cabecera = 0) then begin
		seek(a, filesize(a));
		write(a, titulo);
	end
	else begin
		//voy a la pos indicada por el cabecera
		seek(a, cabecera);
		//leo el contenido del espacio libre
		read(a, unTitulo);
		//agrego el titulo en el espacio libre
		seek(a, filepos(a) - 1);
		write(a, titulo);
		//vuelvo y actualizo el reg cabecera
		seek(a, 0);
		write(a, unTitulo);
	end;
	
	close(a);
end;

procedure listarDatos (var archivo : tArchRevistas; var texto : Text);
var
	unTitulo : String[50];
begin
	reset(archivo); rewrite(texto);
	
	while (not eof(archivo)) do begin
		read(archivo, unTitulo);
		if (unTitulo > '9') then
			writeln(texto,' ',unTitulo);
	end;
	
	close(texto); close(archivo);
end;

//Programa principal
var
	archivo : tArchRevistas;
	texto : Text;
	titulo : String[50];
begin
	assign(archivo, 'revistas');
	assign(texto, 'revistas.txt');
	
	writeln('Ingrese un titulo para agregar al archivo'); readlN(titulo);
	darDeAlta(archivo, titulo);
	listarDatos(archivo, texto);
end.
