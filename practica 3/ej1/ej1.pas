program asd;
const valor_alto = 9999;
Type
	producto = record
		cod:integer;
		nombre:string[20];
		cantAct:integer;
		cantMin:integer;
		cantMax:integer;
		precio:real;
	end;
	
	a_prod = file of producto;
	
procedure leer(var mae:a_prod; var p:producto);
begin
	if not eof(mae) then
		read(mae,p)
	else
		p.cod:=valor_alto;
end;
	
	

procedure leerReg(var r:producto; leoCod:boolean);
begin
	if leoCod=True then begin
		write('Ingrese el codigo del producto: '); readln(r.cod);
	end;
	if (r.cod<>-1) then begin
		write('Ingrese el nombre: '); readln(r.nombre);
		write('Ingrese la cantidad actual: '); readln(r.cantAct);
		write('Ingrese la cantidad minima: '); readln(r.cantMin);
		write('Ingrese la cantidad maxima: '); readln(r.cantMax);
		write
		('Ingrese el precio: '); readln(r.precio);
	end;
end;

procedure cargarArchivo(var mae:a_prod);
var
	r:producto;
begin
	rewrite(mae);
	r.cod:=0;
	write(mae,r);
	writeln('Para finalizar la carga de datos ingrese codigo -1');
	leerReg(r,True);
	while r.cod<>-1 do begin
		write(mae,r);
		leerReg(r,True);
	end;
	close(mae);
	writeln('Carga de datos finalizada');
end;

procedure darAlta(var mae:a_prod);
var
	p:producto;
	p_nuevo:producto;
begin
	reset(mae);
	read(mae,p);
	leerReg(p_nuevo,True);
	if p.cod<=-1 then begin
		seek(mae,p.cod*-1); {Me posiciono en donde dice la cabecera que hay lugar}
		leer(mae,p); {Cargo en p el contenido de esa pos}
		seek(mae,filePos(mae)-1); {Voy uno para atras xq lei el contenido}
		write(mae,p_nuevo); {Escribo el nuevo registro en esa posicion} 
		seek(mae,0);{Voy a la cabecera}
		write(mae,p);{Guardo en la cabecera el contenido del registro anterior.}
	end
	else begin
		seek(mae,fileSize(mae));
		write(mae,p_nuevo);
	end;
	writeln('Producto agregado.');
	writeln;
	close(mae);
end;

procedure eliminar(var mae:a_prod);
var
	p,cabecera:producto; cod:integer;
begin
	reset(mae);
	write('Ingrese el codigo del producto a borrar: ');readln(cod);
	leer(mae,p);
	cabecera:=p;
	while (p.cod<>cod) and (p.cod<>valor_alto) do
		leer(mae,p);
		
	if p.cod<>valor_alto then begin
		seek(mae,filePos(mae)-1); {vuelvo una posicion atras porq lei antes}
		p.cod:=filePos(mae)*-1; {calculo la posicion para la cabecera}
		write(mae,cabecera); {escribo lo que habia en la cabecera en la posicion actual}
		seek(mae,0); {voy a la cabecera}
		write(mae,p); {escribo p, que contiene el numero donde se libero un espacio}
		writeln('El producto fue borrado correctamente.');
	end
	else
		writeln('El codigo ingresado no existe.');
	close(mae);
end;

procedure modificar(var mae:a_prod);
var
	p:producto; cod:integer;
begin
	reset(mae);
	write('Ingrese el codigo del archivo a modificar: '); readln(cod);
	leer(mae,p);
	while (p.cod<>cod) and (p.cod<>valor_alto) do
		leer(mae,p);
	if p.cod<>valor_alto then begin
		writeln('Ingrese los nuevos datos.');
		leerReg(p,False);
		seek(mae,filePos(mae)-1);
		write(mae,p);
		writeln('Producto modificado.');
	end
	else 
		writeln('El codigo ',cod,' no existe.');
end;
		
procedure reporte(var mae:a_prod);
var
	p:producto; textOut:textFile;
begin
	assign(textOut,'reporte_productos.txt');
	rewrite(textOut);
	reset(mae);
	leer(mae,p);
	while p.cod<>valor_alto do begin
		write(textOut,'Cod: ',p.cod);
		write(textOut,' Nombre:',p.nombre);
		write(textOut,' Cant actual: ',p.cantAct);
		write(textOut,' Cant minima: ',p.cantMin);
		write(textOut,' Cant maxima: ',p.cantMax);
		writeln(textOut,' Precio: ',p.precio:0:2);
		leer(mae,p);
	end;
	writeln('reporte_productos.txt creado exitosamente...');
	writeln;
	close(textOut);
	close(mae);
end;


var
	mae:a_prod; opcion:char; seguir:boolean; nombre:string;
begin 
	write('Ingrese el nombre del archivo: ');readln(nombre);
	assign(mae,nombre);
	writeln('--------MENU DE OPCIONES-------');
	writeln('a. Cargar Archivo de productos');
	writeln('b. Mantenimiento del archivo');
	writeln('c: Crear reporte archivo de productos');
	writeln('x: Finalizar programa');       
	seguir:=True;
	while seguir=True do begin
		write('Opcion: ');readln(opcion);
		case opcion of
			'a': cargarArchivo(mae);
			'b': begin
					writeln('	b.1 Dar de alta un producto');
					writeln('	b.2 Modificar producto');
					writeln('	b.3 Eliminar producto');
					write('Opcion (1,2,3): '); readln(opcion);
					case opcion of
						'1': darAlta(mae);
						'2': modificar(mae);
						'3': eliminar(mae);
					end;
					writeln;
				end;
			'c': reporte(mae);
			'x': seguir:=False;
		else
			writeln('Esa opcion no existe!!!');
		end;
	end;
	writeln('Presione enter para finalizar...');
	readln;
end.
