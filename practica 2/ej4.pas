program ej4;
const valor_alto = 9999;
Type
	producto=record
		cod:integer;
		nombre:string[20];
		precio:integer;
		stockA:integer;
		stockM:integer;
	end;
	
	venta=record
		cod:integer;
		cant:integer;
	end;

	maestro=file of producto;
	detalle=file of venta;

procedure leer(var det:detalle; var v:venta);
begin
	if not eof(det) then
		read(det,v)
	else
		v.cod:=valor_alto;
end;
		
	
procedure crearMaestro(var mae:maestro; var textIn:textFile);
var
   reg:producto;
begin
	rewrite(mae);
	assign(textIn,'./productos.txt');
	reset(textIn);
	while(not eof(textIn)) do begin
		readln(textIn,reg.cod,reg.nombre);
		readln(textIn,reg.precio,reg.stockA,reg.stockM);
		write(mae,reg);
	end;
	close(textIn);
	close(mae);
	writeln('Archivo maestro creado a partir de archivo "productos.txt" exitosamente.');
    writeln;
end;

procedure listarMaestro(var mae:maestro; var textOut:textFile);
var
	reg:producto;
begin
	reset(mae);
	assign(textOut,'./reporte.txt');
	rewrite(textOut);
	while (not eof(mae)) do begin
		read(mae,reg);
		writeln(textOut,reg.nombre,' - Codigo: ',reg.cod,' - Precio: ',reg.precio,' - Stock acutal: ',reg.stockA,' - Stock Minimo: ',reg.stockM);
	end;
	close(textOut);
	close(mae);
	writeln('El archivo "reporte.txt" fue creado exitosamente.');
	writeln;
end;

procedure crearDetalle(var det:detalle; var textIn:textFile);
var
	v:venta;
begin
	rewrite(det);
	assign(textIn,'./ventas.txt');
	reset(textIn);
	while not eof(textIn) do begin
		read(textIn,v.cod,v.cant);
		write(det,v);
	end;
	writeln('Archivo ventas creado correctamente.');
	writeln;
	close(textIn);
	close(det);
end;

procedure listarDetalle(var det:detalle);
var
	v:venta;
begin
	reset(det);
	writeln('Contenido archivo detalle: ');
	while not eof(det) do begin
		read(det,v);
		writeln('Codigo: ',v.cod,' - Cantidad: ',v.cant);
	end;
	writeln('Listado finalizado.');
	writeln;
	close(det);
end;

procedure listarMaestroPantalla(var mae:maestro);
var
	p:producto;
begin
	reset(mae);
	writeln('Contenido archivo maestro: ');
	while not eof(mae) do begin
		read(mae,p);
		writeln('Nombre: ',p.nombre,' - Codigo: ',p.cod, ' - Precio: ', p.precio, ' - Stock Acutal: ', p.stockA, ' - Stock Minimo: ', p.stockM );
	end;
	writeln('Listado finalizado.');
	writeln;
	close(mae);
end;

procedure actualizarMaestro(var mae:maestro; var det:detalle);
var
	p:producto; v:venta;
begin
	reset(mae);
	reset(det);
	leer(det, v);
	while (v.cod<>valor_alto) do begin  // mientras no se termine el detalle
		read(mae,p);
		while(p.cod<>v.cod) do 
			read(mae,p);
		while(v.cod=p.cod) do begin
			p.stockA:=p.stockA-v.cant;  //actualizo registro maestro
			leer(det,v);
		end;
		seek(mae,filePos(mae)-1); //actualizo el puntero del archivo maestro
		write(mae,p);  //actualizo archivo maestro
	end;
	writeln('Archivo maestro actualizado exitosamente.');
	writeln;
	close(mae);
	close(det);
end;
		
procedure listarStockMin(var mae:maestro; var textOut:textFile);
var
	p:producto;
begin
	reset(mae);
	assign(textOut,'./stockminimo.txt');
	rewrite(textOut);
	while not eof(mae) do begin
		read(mae,p);
		if (p.stockA<p.stockM) then
			writeln(textOut,p.cod,' ',p.precio,' ',p.stockA,' ',p.stockM,' ',p.nombre);
	end;
	close(mae);
	close(textOut);
	writeln('Listado de productos por debajo del stock minimo creado exitosamente.');
	writeln;
end;
	

//p.p
var
	mae:maestro; det:detalle;
	nombre:string[20]; ok:boolean; opcion:char;
	text:textFile;
begin
	write('Ingrese el nombre del archivo maestro:  '); readln(nombre);
	assign(mae,nombre);
	assign(det,'./detalle.dat');
	
	writeln('------MENU DE OPCIONES-------');
	writeln('a. Crear archivo maestro de productos desde de archivo de texto');
	writeln('b. Lista archivo maestro de productos en archivo de texto');
	writeln('c. Crear archivo detalle de ventas desde de archivo de texto');
	writeln('d. Listar en pantalla contenido del archivo detalle de ventas');
	writeln('e. Actualizar maestro con archivo detalle');
	writeln('f. Listar en archivo "stockminimo.txt" productos con stock debajo del stock minimo');
	writeln('g. Listar maestro en pantalla');
	writeln('x. Finalizar programa');
	
	ok:=true;
	while (ok) do begin
		write('Ingrese la opcion deseada(a,b,c,d,e,f o x): ');readln(opcion);
		case opcion of
			'a': crearMaestro(mae,text);
			'b': listarMaestro(mae,text);
			'c': crearDetalle(det,text);
			'd': listarDetalle(det);
			'e': actualizarMaestro(mae,det);
			'f': listarStockMin(mae,text);
			'g': listarMaestroPantalla(mae);
			'x': ok:=false;
		else
			write('Opcion no valida. ');
        end;
	end;
end.


