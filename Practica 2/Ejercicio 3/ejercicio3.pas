program tres;

Uses sysutils;

const
	dimF = 30;
	corte = 32767;
	
type
	rango = 1..dimF;
	
	str20 = String[20];
	
	tProducto = record
		cod:integer;
		nombre:str20;
		descripcion:str20;
		stockDisponible:integer;
		stockMinimo:integer;
		precio:real;
	end;
	
	tVentas = record
		cod:integer;
		cantVendida:integer;
	end;
	
	archivoMaestro = file of tProducto;
	
	registrosDetalles = array[rango] of tVentas;
	
	archivoDetalle = file of tVentas;
	
	arrDetalles = array[rango] of archivoDetalle;
	
procedure leerVenta (var archivo : archivoDetalle; var registro : tVentas);
begin
	if (not eof(archivo)) then
		read(archivo,registro)
	else
		registro.cod := corte;
end;
			
procedure iniciarArchivosDetalle (var vectorDetalles : arrDetalles; var vectorVentas : registrosDetalles);
var
	i : integer;
begin
	for i := 1 to dimF do
		leerVenta(vectorDetalles[i],vectorVentas[i]);
end;

procedure asignarDetalles (var vectorDetalles : arrDetalles);
var
	i : integer;
begin
	for i := 1 to dimF do
		assign(vectorDetalles[i], 'detalle_'+IntToStr(i));
end;

procedure abrirDetalles (var vectorDetalles : arrDetalles);
var
	i : integer;
begin
	for i := 1 to dimF do
		reset(vectorDetalles[i]);
end;


procedure cerrarDetalles (var vectorDetalles : arrDetalles);
var
	i : integer;
begin
	for i := 1 to dimF do
		close(vectorDetalles[i]);
end;

procedure minimo (var vectorDetalles : arrDetalles; var vectorVentas : registrosDetalles; var ventaMin : tVentas);
var
	i, iMin : integer;
begin
	iMin := -1;
	ventaMin.cod := corte;
	
	for i := 1 to dimF do begin
		if ((vectorVentas[i].cod <> corte) and (vectorVentas[i].cod <= ventaMin.cod)) then begin
			iMin := i;
			ventaMin := vectorVentas[i];
		end;
	end;
	
	if (iMin <> -1) then
		leerVenta(vectorDetalles[iMin], vectorVentas[iMin]);
end;

procedure actualizarMaestro (var maestro : archivoMaestro; var vectorDetalles : arrDetalles);
var
	vectorVentas : registrosDetalles;
	ventasMin : tVentas;
	regMaestro : tProducto;
begin
	reset(maestro);
	abrirDetalles(vectorDetalles);
	
	iniciarArchivosDetalle(vectorDetalles, vectorVentas);
	minimo(vectorDetalles,vectorVentas,ventasMin);
	
	while (ventasMin.cod <> corte) do begin
		read(maestro, regMaestro);
		
		while (regMaestro.cod <> ventasMin.cod) do
			read(maestro,regMaestro);
		
		while (regMaestro.cod = ventasMin.cod) do begin
			regMaestro.stockDisponible := regMaestro.stockDisponible - ventasMin.cantVendida;
			minimo(vectorDetalles,vectorVentas,ventasMin);
		end;
		
		seek(maestro, filepos(maestro) - 1);
		write(maestro, regMaestro);
	end;
	
	cerrarDetalles(vectorDetalles);
end;

procedure informarProductosConPocoStock (var maestro : archivoMaestro; var texto : Text);
var
	unProducto : tProducto;
begin
	reset(maestro);
	rewrite(texto);
	
	while (not eof(maestro)) do begin
		read(maestro, unProducto);
		with unProducto do
			writeln(texto,' ',nombre,' ',descripcion,' ',stockDisponible);
	end;
	
	close(texto);
	close(maestro);
end;


//Programa Principal
var
	maestro : archivoMaestro;
	vectorDetalles : arrDetalles;
	productosConPocoStock : Text;
	
begin
	assign(maestro,'maestro.txt');
	assign(productosConPocoStock, 'productos_con_poco_stock');
	asignarDetalles(vectorDetalles);
	actualizarMaestro(maestro,vectorDetalles);
	informarProductosConPocoStock(maestro,productosConPocoStock);
end.



