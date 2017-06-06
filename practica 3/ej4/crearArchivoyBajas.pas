program ej4;

uses sysutils;

const valoralto='ZZZZ';

Type
	tNombre = String[50];
	tArchPersonas = file of tNombre;

procedure leer(var mae:tArchPersonas; var nombre:tNombre);
begin
	if not eof(mae) then
		read(mae,nombre)
	else
		nombre:=valoralto;
end;
	
	
procedure crearArchivo(var mae:tArchPersonas);
var
	cabecera:tNombre; nombre:tNombre;
begin
	rewrite(mae);
	cabecera:='0';
	write(mae,cabecera);
	write('Ingrese nombre: ');readln(nombre);
	while nombre<>'ZZZ' do begin
		write(mae,nombre);
		write('Ingrese nombre: ');readln(nombre);
	end;
	close(mae);
end;

procedure eliminar(var mae:tArchPersonas);
var
	nombre,nom,cabecera:string[50];
begin
	reset(mae);
	write('Ingrese el nombre de la persona a borrar: ');readln(nombre);
	read(mae,nom);
	cabecera:=nom;
	while (nom<>nombre) and (nom<>valoralto) do
		leer(mae,nom);
		
	if nom<>valoralto then begin
		seek(mae,filePos(mae)-1); {vuelvo una posicion atras porq lei antes}
		nom:=IntToStr(filePos(mae)*-1); {calculo la posicion para la cabecera}
		write(mae,cabecera); {escribo lo que habia en la cabecera en la posicion actual}
		seek(mae,0); {voy a la cabecera}
		write(mae,nom); {escribo nom, que contiene el numero donde se libero un espacio}
		writeln('La persona fue borrada correctamente.');
	end
	else
		writeln('EL nombre ingresado no existe.');
	close(mae);
end;
	
procedure listarArchivo(var mae:tArchPersonas);
var
	nombre:string[50];
begin
	reset(mae);
	leer(mae,nombre);
	while nombre<>valoralto do begin
		writeln(nombre);
		leer(mae,nombre);
	end;
	close(mae);
end;

var 
	mae:tArchPersonas;
	opcion:integer;
	
BEGIN	
	assign(mae,'maestro.dat');
	write('Ingresa 1 para crear archivo, 2 para eliminar un elemento del archivo, o 3 para listar el archivo');readln(opcion);
	case opcion of
		1: crearArchivo(mae);
		2: eliminar(mae);
		3: listarArchivo(mae);
	end;
END.

