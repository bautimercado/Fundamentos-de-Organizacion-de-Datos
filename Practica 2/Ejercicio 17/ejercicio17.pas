program diecisiete;

const
	valorAlto = 32767;
	
type
	str10 = String[10];
	str20 = String[20];
	
	tAutos = record
		cod : integer;
		nom : str10;
		descripcion : str20;
		modelo : str10;
		stock : integer;
	end;
	
	archivoMaestro = file of tAutos;
	
	tVentas = record
		cod : integer;
		fechaVenta : str10;
		precio : real;
	end;
	
	archivoDetalle = file of tVentas;
	
procedure leer (var det : archivoDetalle; var reg : tVentas);
begin
	if (not eof(det)) then
		read(det, reg)
	else
		reg.cod := valorAlto;
end;

procedure minimo (var min, regD1, regD2 : tVentas; var det1, det2 : archivoDetalle);
begin
	if (regD1.cod < regD2.cod) then begin
		min := regD1;
		leer(det1, regD1);
	end
	
	else begin
		min := regD2;
		leer(det2, regD2);
	end;
end;


//Programa principal
var
	det1, det2 : archivoDetalle;
	maestro : archivoMaestro;
	min, regD1, regD2 : tVentas;
	regM, max : tAutos;
	aux : integer;
begin
	assign(maestro, 'maestro');
	assign(det1, 'detalle1'); assign(det2, 'detalle2');
	
	reset(maestro); reset(det1); reset(det2);
	
	leer(det1, regD1); leer(det2, regD2);
	
	max.stock := -9999;
	minimo(min, regD1, regD2, det1, det2);
	
	while (min.cod <> valorAlto) do begin
		aux := 0;
		read(maestro, regM);
		
		while (regM.cod <> min.cod) do
			read(maestro, regM);
			
		while (regM.cod = min.cod) do begin
			//variable que contabiliza la cantidad de ventas por auto
			aux := aux + 1; 
			minimo(min, regD1, regD2, det1, det2);
		end;
		
		if (aux > max.stock) then
			max := regM;
			
		regM.stock := regM.stock - aux;
		seek(maestro, filepos(maestro) - 1);
		write(maestro, regM);
			
	end;
	
	writeln('El auto que mas ventas tuvo es: ');
	with max do
		writeln(nom,' ',descripcion,' ',modelo);
	
	close(det2); close(det1); close(maestro);
	
end.


