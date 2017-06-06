program ej5;
Type
	persona = record
		apellido: string[25];
		nombre: string[25];
		fecNac: LongInt;
	end;
	
	archivo_personas = file of persona;
	
procedure leerDatos(var p:persona);
begin
	write('Ingrese apellido: ');
	readln(p.apellido);
	if (p.apellido <> '') then begin
		write('Ingrese nombre: ');
		readln(p.nombre);
		write('Ingrese fecha de nacimiento(formato "aaaammdd"): ');
		readln(p.fecNac);
	end;
end;
	
procedure crearArchivo(var a_personas:archivo_personas; var r_personas:persona);
begin
	rewrite(a_personas);
	leerDatos(r_personas);
	while (r_personas.apellido <> '') do begin
		write(a_personas,r_personas);
		leerDatos(r_personas);
	end;
	writeln('Carga de datos finalazada.');
	writeln;
	close(a_personas);
end;

procedure listarDatosFecha(var a_personas:archivo_personas; valor_mes:integer);
var
	dia,mes,ano:LongInt;
    p:persona;
begin
	reset(a_personas);
	writeln;
	writeln('Personas que cumplen en el mes ', valor_mes, ' o poseen fecha de nacimiento nula: ');
	writeln;
	while not eof(a_personas) do begin
		read(a_personas,p);
		if (((p.fecNac MOD 10000) DIV 100) = valor_mes) OR (p.fecNac = 0) then begin
			dia:=((p.fecNac MOD 10000) MOD 100);
			mes:=((p.fecNac MOD 10000) DIV 100);
			ano:=(p.fecNac DIV 10000);
			writeln('** ', p.nombre, ' ', p.apellido, ' - Fecha de nacimiento: ', dia, '-', mes, '-', ano, ' **');
		end;
	end;
	writeln;
	close(a_personas);	
end;

procedure listadoPersonas(var a_personas:archivo_personas);
var
	dia,mes,ano:longInt;
	p:persona;
begin
	reset(a_personas);
	writeln;
	while not eof(a_personas) do begin
		read(a_personas, p);
		dia:=((p.fecNac MOD 10000) MOD 100);
		mes:=((p.fecNac MOD 10000) DIV 100);
		ano:=(p.fecNac DIV 10000);
		writeln('** ', p.nombre, ' ', p.apellido, ' - Fecha de nacimiento: ', dia, '-', mes, '-', ano, ' **');
	end;
	writeln('Listado finalizado.');
	writeln;
	close(a_personas);
end;

//p.p
	
var
	seguir:boolean;
	nombre:string;
	a_personas: archivo_personas;
	r_personas: persona;
	opcion:char;
	valor_mes:integer;
begin
	
	write('Ingrese el nombre del archivo: '); readln(nombre);
	assign(a_personas,nombre);
	valor_mes:=12;
	seguir:= true;
	while(seguir = true) do begin
		writeln;
		writeln('	*----------------- MENU -----------------*');
		writeln('# a: Crear archivo de personas.');
		writeln('# b: Listar datos de personas nacidas en el mes ', valor_mes,' o sin fecha de nac.');
		writeln('# c: Listado de personas.');
		writeln('# x: Finalizar programa.');
		writeln('	*----------------------------------------*');
		writeln;
		
		write('Ingrese la opcion deseada (a,b,c o x): ');
		readln(opcion);
		
		if(opcion='a') then
			crearArchivo(a_personas, r_personas)
		else
			if (opcion='b') then
				listarDatosFecha(a_personas, valor_mes)
			else
				if(opcion='c') then
					listadoPersonas(a_personas)
				else
					if(opcion='x') then
						seguir:=false;
	end;
	writeln('Presione enter para continuar...');
    readln;
end.
 