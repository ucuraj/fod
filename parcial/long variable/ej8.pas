program untitled;

uses sysutils;

Type

	persona=record
		nombre:string;
		apellido:string;
		fechaNac:longInt;
	end;
	
archivo=file;

procedure crearArchivo(var personas:archivo);
var
	apellido,nombre,fechaString:string;
	fechaNac:longInt;
	campo,registro:char;	
begin
	rewrite(personas,1);
	campo:='#';
	registro:='@';
	write('Ingrese el apellido: '); readln(apellido);
	while (apellido<>' ') do begin
		write('Ingrese el nombre: '); readln(nombre);
		write('Ingrese la fecha de nacimiento: '); readln(fechaNac);
		str(fechaNac,fechaString);
		blockwrite(personas,apellido,length(apellido)+1);
		BlockWrite(personas,campo,1);
		blockwrite(personas,nombre,length(nombre)+1);
		blockwrite(personas,campo,1);
		blockwrite(personas,fechaNac,sizeOf(fechaNac)+1);
		blockwrite(personas,registro,1);
		write('Ingrese el apellido: '); readln(apellido);
	end;
	writeln('Carga de datos finalizada');
	close(personas);
end;

procedure listarArchivo(var personas:archivo);
var
	buffer,campo:string;
begin
	reset(personas,1);
	while not eof(personas) do begin;
		blockread(personas,buffer,1);
		while (buffer<>'@') and (not eof(personas)) do begin
			campo:='';
			while (buffer<>'@') and (buffer<>'#') and (not eof(personas)) do begin
				campo:=campo+buffer;
				blockread(personas,buffer,1);
			end;
			writeln(campo,' ');
			if not eof(personas) then
				blockread(personas,buffer,1);
		end;
	end;
	close(personas);
	writeln;
end;

procedure buscarEnArchivo(var personas:archivo; var apellido:string);
var
	buffer,campo:string;
	p:persona; 
	i:integer;
begin
	reset(personas,1);
	while not eof(personas) do begin;
		blockread(personas,buffer,1);
		i:=1;
		while (buffer<>'@') and (not eof(personas)) do begin
			campo:='';
			while (buffer<>'@') and (buffer<>'#') and (not eof(personas)) do begin
				campo:=campo+buffer;
				blockread(personas,buffer,1);
				i:=i+1;
			end;
			case i of
				1: p.apellido:=campo;
				2: p.nombre:=campo;
				3: p.fechaNac:=StrToInt(campo);
			end;
			
			if i=1 then begin
				if p.apellido=apellido then
					writeln(p.apellido);
			end
			else writeln('No se encontro ',apellido);
			
			if not eof(personas) then
				blockread(personas,buffer,1);
		end;
	end;
	close(personas);
	writeln;
end;

var
	personas:archivo;
	nombre,apellido:string;
	opcion:char;
	seguir:boolean;
		
BEGIN
	write('Ingrese el nombre del archivo: '); readln(nombre);
	assign(personas,nombre);
	writeln('-------- MENU DE OPCIONES --------');
	writeln('a. Crear Archivo');
	writeln('b. Listar Archivo');
	writeln('c. Buscar persona por apellido');
	writeln('x. Salir');
	writeln('-------- **************** --------');
	seguir:=True;
	apellido:='Cura';
	while seguir do begin
		write('Ingrese opcion: ');readln(opcion);
		case opcion of
			'a': crearArchivo(personas);	
			'b': listarArchivo(personas);
			'c': buscarEnArchivo(personas,apellido);
			'x': begin seguir:=False; writeln('Ejecucion finalizada');end;
		end;
	end;
END.	

