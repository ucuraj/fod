program ej3;
const valoralto='ZZZZZ';
Type
	profesor=record
		nombreC:string;
		edad:integer;
	end;
	
	a_prof = file of profesor;
	
procedure leer(var mae:a_prof; var p:profesor);
begin
	if not eof(mae) then
		read(mae,p)
	else
		p.nombreC:=valoralto;
end;		

procedure cargarArchivo(var mae:a_prof; var textIn:textFile);
var
	p:profesor;
begin
	rewrite(mae);
	writeln('Cargando datos en archivo...');
	reset(textIn);
	read(textIn,p.edad,p.nombreC);
	while not eof(textIn) do begin
		write(mae,p);
		read(textIn,p.edad,p.nombreC);
	end;
	close(textIn);
	close(mae);
	writeln('Archivo cargado...');
	writeln;
end;

procedure listarArchivoCompleto(var mae:a_prof);
var
	p:profesor; i:integer;
begin
	reset(mae);
	i:=1;
	writeln('Listado de registros del archivo maestro.');
	leer(mae,p);
	while (p.nombreC<>valoralto) do begin
		writeln(i,'.',p.nombreC,'. Edad: ',p.edad);
		leer(mae,p);
		i:=i+1;
	end;
	writeln;
	close(mae);
end;

procedure listarArchivo(var mae:a_prof);
var
	p:profesor; i:integer;
begin
	reset(mae);
	i:=1;
	writeln('Listado de registros del archivo maestro.');
	leer(mae,p);
	while (p.nombreC<>valoralto) do begin
		if p.nombreC[1]<>'*' then begin
			writeln(i,'.',p.nombreC,'. Edad: ',p.edad);
			i:=i+1;
		end;
		leer(mae,p);
	end;
	writeln;
	close(mae);
end;

procedure bajaLogica(var mae:a_prof);
var
	p:profesor;
begin
	reset(mae);
	leer(mae,p);
	while p.nombreC<>valoralto do begin
		if p.edad>65 then begin
			p.nombreC:='***'+p.nombreC;
			seek(mae,filePos(mae)-1);
			write(mae,p);
		end;
		leer(mae,p);
	end;
	close(mae);
	writeln('Los profesores de más de 65 fueron eliminados.');
	writeln;
end;

var
	mae:a_prof; textIn:textFile; seguir:boolean; opcion:char; opcion2:integer;
begin
	assign(mae,'a_profesores.dat');
	assign(textIn,'t_profesores.txt');
	writeln('--------MENU--------');
	writeln('.a Crear archivo a partir de "a_profesores.dat"');
	writeln('.b Listar datos del archivo');
	writeln('.c Jubilar abuelos.');
	writeln('.x Finalizar programa.');
	seguir:=True;
	while seguir do begin
		write('Opcion: ');readln(opcion);
		case opcion of
			'a': cargarArchivo(mae,textIn);
			'b': begin
					writeln('	1. Listar archivo');
					writeln('	2. Listar archivo completo(incluyendo bajas logicas');
					write('Opcion(1,2): '); readln(opcion2);
					case opcion2 of
						1: listarArchivo(mae);
						2: listarArchivoCompleto(mae)
					else
						writeln('La opcion no existe.');
					end;
				end;
			'c': bajaLogica(mae); 
			'x': begin 
					writeln('Ejecución detenida.');
					seguir:=false;
				end;
		else
			writeln('La opcion ingresa no es valida.');
		end;
	end;
	readln;
end.
