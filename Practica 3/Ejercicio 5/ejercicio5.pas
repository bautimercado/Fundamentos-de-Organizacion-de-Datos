program cinco;

uses sysutils;

const
	valorAlto = 'zzzzzzzzzzzzz';

type
	tTitulo = String[50];
	
	tArchRevistas = file of tTitulo;

procedure leerRegistro (var arc : tArchRevistas; var reg : tTitulo);
begin
	if (not eof(arc)) then
		read(arc, reg)
	else
		reg := valorAlto;
end;
	
procedure darDeAlta (var a : tArchRevistas; titulo : String);
var
	unTitulo : tTitulo;
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
	unTitulo : tTitulo;
begin
	reset(archivo); rewrite(texto);

	leerRegistro(archivo, unTitulo);
	
	while (unTitulo <> valorAlto) do begin
		if (unTitulo > '9') then
			writeln(texto,' ',unTitulo);
		leerRegistro(archivo, unTitulo);
	end;
	
	close(texto); close(archivo);
end;

procedure eliminar (var a: tArchRevistas ; titulo: string);
var
	unTitulo, cabecera, aux : tTitulo;
	pos, cod : integer;
begin
	reset(a);
	read(a, cabecera);

	leerRegistro(a, unTitulo);
	
	while ((unTitulo <> valorAlto) and (unTitulo <> titulo)) do
		read(a, unTitulo);
		
	if (unTitulo <> titulo) then
		writeln('No se encontro a una revista con el titulo ',titulo)

	else begin
		//guardo el nrr
		pos := filepos(a) - 1;
		//escribo en el lugar encontrado el contenido del cabecera
		seek(a, pos);
		write(a, cabecera);
		//escribo en la cabecera la posicion del nuevo elemento borrado
		seek(a, 0);
		write(a, IntToStr(pos));
	end;
	
	close(a);
end;

//Programa principal
var
	archivo : tArchRevistas;
	texto : Text;
	titulo : tTitulo;
begin
	assign(archivo, 'revistas');
	assign(texto, 'revistas.txt');
	
	writeln('Ingrese un titulo para agregar al archivo'); readln(titulo);
	darDeAlta(archivo, titulo);
	writeln('Ingrese un titulo para agregar al archivo'); readln(titulo);
	eliminar(archivo, titulo);
	writeln('Ingrese un titulo para agregar al archivo'); readln(titulo);
	darDeAlta(archivo, titulo);
	listarDatos(archivo, texto);
end.
