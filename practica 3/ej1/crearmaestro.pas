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

procedure cargarArchivo(var mae:a_prod);
var
	r:producto; textIn:textFile; p:producto;
begin
	assign(textIn,'productos.txt');
	reset(textIn);
	rewrite(mae);
	r.cod:=0;
	r.nombre:='';
	write(mae,r);
	while not eof(textIn) do begin
		read(textIn,p.cod);
		read(textIn,p.cantAct);
		read(textIn,p.cantMin);
		read(textIn,p.cantMax);
		read(textIn,p.precio);
		readln(textIn,p.nombre);
		
		write(mae,p);
	end;
	close(mae);
	close(textIn);
	writeln('Carga de datos finalizada');
end;

var
	mae:a_prod;
begin 
	assign(mae,'archProdEJ1.dat');
	cargarArchivo(mae);
	readln;
end.
