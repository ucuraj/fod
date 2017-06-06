program ej4;

uses sysutils;

Type
	tNombre = String[50];
	tArchPersonas = file of tNombre;

	
procedure agregar (var a: tArchPersonas; nombre: string);
var
	cabecera:tNombre; pos:integer;
begin
	reset(a);
	read(a,cabecera); {leo el contenido de la cabecera}
	pos:=StrToInt(cabecera); {convierto la cabecera a integer}
	if (pos<=-1) then begin
		seek(a,pos*-1); {voy a donde mi indica la cabecera}
		read(a,cabecera); {guardo en cabecera el contenido de esa posicion}
		seek(a,filepos(a)-1); {vuelvo uno atras xq avance al leer}
		write(a,nombre); {escribo el nuevo nombre}
		seek(a,0); {voy a la cabecera}
		write(a,cabecera); {escribo lo que habia en la posicion donde agregue el nuevo registro}
	end
	else 
		writeln('No hay espacio disponible para realizar la alta');
end;

procedure listarArchivo(var mae:tArchPersonas);
var
	nombre:string[50];
begin
	reset(mae);
	while not eof(mae) do begin
		read(mae,nombre);
		if (nombre[1]<>'0') and (nombre[1]<>'-') then
			writeln(nombre);
	end;
	close(mae);
end;
	
var
	mae:tArchPersonas; nombre:string; opcion:char;
begin
	assign(mae,'maestro.dat');
	write('Agregar persona al archivo?(S/n)'); readln(opcion);
	if opcion='s' then begin
		write('Ingrese nombre y apellido de la persona a agregar: '); readln(nombre);
	end;
		agregar(mae,nombre);
	write('Listar datos en archivo?(S/n)'); readln(opcion);
	case opcion of 
		's','S': listarArchivo(mae);
		'n','N': writeln('Se detendrá la ejecucion, presione enter para continuar.');
	end;
	readln;
end.
