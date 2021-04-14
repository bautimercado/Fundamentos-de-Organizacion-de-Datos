program siete;

const
	corte = 32767;
	
type
	str20 = String[20];
	
	tProducto = record
		cod : integer;
		nombre : str20;
		precio : real;
		stockActual : integer;
		stockMinimo : integer;
	end;
	
	archivoMaestro = file of tProducto;
	
	tVentas = record
		cod : integer;
		cantVendida : integer;
	end;
	
	archivoDetalle = file of tVentas;
	
procedure cargarMaestro (var maestro : archivoMaestro; var productos : Text);
var
	unProducto : tProducto;
begin
	reset(productos);
	rewrite(maestro);
	
	while (not eof(productos)) do begin
		
		with unProducto do begin
			readln(productos, cod, nombre);
			readln(productos, precio, stockActual, stockMinimo); 
		end;
		
		write(maestro, unProducto);
	end;
	
	close(maestro);
	close(productos);
end;

procedure listarMaestroEnTexto (var maestro : archivoMaestro; var reporte : Text);
var
	unProducto : tProducto;
begin
	reset(maestro);
	rewrite(reporte);
	
	while (not eof(maestro)) do begin
		read(maestro, unProducto);
		
		with unProducto do
			writeln(reporte,' ',cod,' ',nombre,' ',precio:4:2,' ',stockActual,' ',stockMinimo);
	end;
	
	close(reporte);
	close(maestro);
end;

procedure cargarDetalle (var detalle : archivoDetalle; var ventas : Text);
var
	unaVenta : tVentas;
begin
	reset(ventas);
	rewrite(detalle);
	
	while (not eof(ventas)) do begin
		
		with unaVenta do
			readln(ventas, cod, cantVendida);
		write(detalle, unaVenta);
	end;
	
	close(detalle);
	close(ventas);
end;

procedure imprimirDetalle (var detalle : archivoDetalle);
var
	unaVenta : tVentas;
begin
	reset(detalle);
	
	while (not eof(detalle)) do begin
	
		read(detalle, unaVenta);
		with unaVenta do
			writeln('Codigo de producto: ',cod,' cantidad vendida: ',cantVendida);
	end;
	
	close(detalle);
end;


procedure leerVenta (var archivo : archivoDetalle; var reg : tVentas);
begin
	if (not eof(archivo)) then
		read(archivo, reg)
	else
		reg.cod := corte;
end;

procedure actualizarMaestro (var maestro : archivoMaestro; var detalle : archivoDetalle);
var
	unProducto : tProducto;
	unaVenta : tVentas;
begin
	reset(maestro);
	reset(detalle);
	leerVenta(detalle, unaVenta);
	
	while (unaVenta.cod <> corte) do begin
		read(maestro, unProducto);
		
		while (unProducto.cod <> unaVenta.cod) do
			read(maestro, unProducto);
			
		while (unProducto.cod = unaVenta.cod) do begin
			unProducto.stockActual := unProducto.stockActual - unaVenta.cantVendida;
			leerVenta(detalle, unaVenta);
		end;
		
		seek(maestro, filepos(maestro) - 1);
		write(maestro, unProducto);
	end;
	
	close(detalle);
	close(maestro);
	
end;

procedure listarProductosConPocoStock (var maestro : archivoMaestro; var stockMin : Text);
var
	unProducto : tProducto;
begin
	reset(maestro);
	rewrite(stockMin);
	
	while (not eof(maestro)) do begin
		read(maestro, unProducto);
		
		with unProducto do
			
			if (stockActual < stockMinimo) then
				writeln(stockMin,' ',cod,' ',nombre,' ',precio:4:2,' ',stockActual,' ',stockMinimo);
				
	end;
	
	close(stockMin);
	close(maestro);
end;

procedure menu ();
begin
	writeln('/////////////////////////////////////////////////////////////////////');
	writeln('		a.- Crear archivo maestro');
	writeln('		b.- Crear archivo de texto en base al maestro');
	writeln('		c.- Crear archivo detalle');
	writeln('		d.- Imprimir datos del archivo detalle');
	writeln('		e.- Actualizar archivo maestro');
	writeln('		f.- Crear archivo de productos cuyo stock es menor al minimo');
	writeln('		g.- Salir');
	writeln('/////////////////////////////////////////////////////////////////////');
end;

//Programa Principal
var
	maestro : archivoMaestro;
	detalle : archivoDetalle;
	productos, ventas, reporte, stockMin : Text;
	op : char;
begin
	assign(maestro, 'maestro');
	assign(detalle, 'detalle');
	
	assign(productos, 'productos.txt');
	assign(reporte, 'reporte.txt');
	assign(ventas, 'ventas.txt');
	assign(stockMin, 'stock_minimo.txt');

	repeat
		menu();
		readln(op);
		case op of
			'a': cargarMaestro(maestro, productos);
			'b': listarMaestroEnTexto(maestro, reporte);
			'c': cargarDetalle(detalle, ventas);
			'd': imprimirDetalle(detalle);
			'e': actualizarMaestro(maestro, detalle);
			'f': listarProductosConPocoStock(maestro, stockMin);
			else
				writeln('Saliendo. . .');
		end;
	until (op = 'g');
end.
