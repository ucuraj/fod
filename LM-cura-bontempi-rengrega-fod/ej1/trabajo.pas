program trabajoPractico;
uses sysutils;
const valoralto=9999;
const x=30;

Type
	producto=record
		cod:integer;
		nombre:string[30];
		precio:integer;
		stockA:integer;
		stockM:integer;
	end;

	ventas=record
		cod:integer;
		cant:integer;
	end;

	maestro=file of producto;
	detalle=array[1..x] of file of ventas;
	reg_detalle=array[1..x] of ventas;
	textD=array[1..x] of textFile;

procedure leerD(var det:detalle; var regD:reg_detalle; pos:integer);
begin
	if not eof(det[pos]) then
		read(det[pos],regD[pos])
	else
		regD[pos].cod:=valoralto;
end;

procedure leerM(var mae:maestro; var p:producto);
begin
	if not eof(mae) then
		read(mae,p)
	else
		p.cod:=valoralto;
end;

procedure minimo(var det:detalle; var regD:reg_detalle; var min:ventas; tot:integer);
var
	i,pos:integer;
begin
	min.cod:=valoralto;
	for i:=1 to tot do begin
		if regD[i].cod < min.cod then begin
			min:=regD[i];
			pos:=i;
		end;
	end;
	leerD(det,regD,pos);
end;

procedure crearMaestro(var mae:maestro; var textIn:textFile);
var
   reg:producto;
begin
	rewrite(mae);
	assign(textIn,'productos.txt');
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
	assign(textOut,'reporte.txt');
	rewrite(textOut);
	leerM(mae,reg);
	while reg.cod<>valoralto do begin
		writeln(textOut,reg.nombre,' - Codigo: ',reg.cod,' - Precio: ',reg.precio,' - Stock acutal: ',reg.stockA,' - Stock Minimo: ',reg.stockM);
		leerM(mae,reg);
	end;
	close(textOut);
	close(mae);
	writeln('El archivo "reporte.txt" fue creado exitosamente.');
	writeln;
end;

procedure crearDetalle(var det:detalle; var textDet:textD; cant:integer);
var
	v:ventas; i:integer; numS:string; nombre:string;
begin

	for i:=1 to cant do begin
		rewrite(det[i]);
	end;
	
	for i:=1 to cant do begin
		str(i,numS);
		nombre:='ventas'+numS+'.txt';
		assign(textDet[i],nombre);
	end;

	for i:= 1 to cant do begin
		reset(textDet[i]);
		if not eof(textDet[i]) then
			read(textDet[i],v.cod,v.cant);
		while not eof(textDet[i]) do begin
			write(det[i],v);
			read(textDet[i],v.cod,v.cant);
		end;
		close(textDet[i]);
	end;

	for i:=1 to cant do
		close(det[i]);
	
	writeln('Archivos detalle creados exitosamente. Total de archivos creados: ',cant);
	writeln;
end;

procedure listarDet(var det:detalle);
var
	pos:integer; regD:reg_detalle;
begin
	write('Ingrese el numero del archivo detalle a mostar: '); readln(pos);

	reset(det[pos]);
	writeln('Contenido archivo detalle ',pos);
	leerD(det,regD,pos);
	while (regD[pos].cod<>valoralto) do begin
		writeln('Codigo: ',regD[pos].cod,' - Cantidad: ',regD[pos].cant);
		leerD(det,regD,pos);
	end;
	writeln('**Listado detalle',pos,' finalizado.**');
	writeln;
	close(det[pos]);
end;

procedure actualizarMaestro(var mae:maestro; var det:detalle; cantDet:integer);
var
	min:ventas; 
	rm:producto;
	i:integer;
	regDet:reg_detalle;
begin
	reset(mae);
	writeln('Actualizando archivo maestro...');
	for i:=1 to cantDet do
		reset(det[i]);		
	for i:=1 to cantDet do
		leerD(det,regDet,i);
	
	minimo(det,regDet,min,cantDet);
	while (min.cod<>valoralto) do begin
		leerM(mae,rm);
		while(rm.cod<>min.cod) and (rm.cod<>valoralto) do
			leerM(mae,rm);
		while(rm.cod=min.cod) do begin
			rm.stockA:=rm.stockA-min.cant;
			minimo(det,regDet,min,cantDet);
		end;
		seek(mae,filePos(mae)-1);
		write(mae,rm);
	end;
	
	close(mae);
	for i:=1 to cantDet do
		close(det[i]);
		
	writeln('Archivo maestro actualizado exitosamente.');
	writeln;
end;	
	
procedure listarStockMin(var mae:maestro; var textOut:textFile);
var
	p:producto;
begin
	reset(mae);
	assign(textOut,'stock_minimo.txt');
	rewrite(textOut);
	leerM(mae,p);
	while(p.cod<>valoralto) do begin
		if(p.stockA<p.stockM) then
			writeln(textOut,p.nombre,' - Codigo: ',p.cod,' - Precio: ',p.precio,' - Stock acutal: ',p.stockA,' - Stock Minimo: ',p.stockM);
		leerM(mae,p);
	end;
	writeln('Archivo "stock_minimo.txt" creado correctamente.');
	writeln;
	close(textOut);
	close(mae);
end;


//p.p
var
	mae:maestro; det:detalle;
	opcion:char; seguir:boolean; text:textFile;
	cantDet,i:integer; nombre,numS:string;
	textDet:textD;

begin
	write('Ingrese el nombre del archivo maestro: '); readln(nombre);
	write('Ingrese la cantidad de archivos detalle a utilizar: '); readln(cantDet);
	assign(mae,nombre);
	for i:=1 to cantDet do begin
		str(i,numS);
		nombre:='det'+numS+'.dat';
		assign(det[i],nombre);
	end;

	writeln('------------MENU TRABAJO PRACTICO------------');
	writeln('a. Crear archivo maestro a partir de "productos.txt"');
	writeln('b. Listar contenido archivo maestro en "reporte.txt"');
	writeln('c. Crear archivo detalle a partir de "ventasX.txt"');
	writeln('d. Listar en pantalla el contenido de un archivo detalle(1 a ',cantDet,')');
	writeln('e. Actualizar archivo maestro con ',cantDet,' archivos detalle');
	writeln('f. Listar en "stock_minimo.txt" los productos que estan por debajo del stock minimo');
	writeln('x. Finalizar programa');


	seguir:=true;
	while (seguir) do begin
		write('Ingrese la opcion deseada(a,b,c,d,e,f o x): ');readln(opcion);
		case opcion of
			'a': crearMaestro(mae,text);
			'b': listarMaestro(mae,text);
			'c': crearDetalle(det,textDet,cantDet);
			'd': listarDet(det);
			'e': actualizarMaestro(mae,det,cantDet);
			'f': listarStockMin(mae,text);
			'x': seguir:=false;
		else
			write('Opcion no valida. ');
        end;
	end;
	
	writeln('Programa finalizado');
	writeln('Presione enter para continuar...');
	readln;
end.
