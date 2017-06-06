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



//////////EJ6


procedure anadirPer(var a_per:archivo_personas);
var	
	p:persona;
begin
	reset(a_per);
	writeln('La carga finaliza cuando se ingresa el apellido nulo.');
	leerDatos(p);
	while (p.apellido <> '') do begin
		seek(a_per,fileSize(a_per));
		write(a_per,p);
		leerDatos(p);
	end;
	writeln;
	writeln('Carga de datos finalazada.');
	writeln;
	close(a_per);
end;

procedure modificarDatos(var a_per:archivo_personas);
var
	fecha:integer; apellido,nombre:string[25];
	p:persona; encontre:boolean;
begin
	reset(a_per);
	writeln('*-*-*-* PARA FINALIZAR INGRESE APELLIDO NULO *-*-*-*');
	write('Ingrese apellido: '); readln(apellido);
    write('Ingrese nombre: '); readln(nombre);
	write('Ingrese nueva fecha de nacimiento ("aaaammdd"): '); readln(fecha);
	while (apellido <> '') and (not eof(a_per)) do begin
		encontre:=false;
		read(a_per, p);
		if(p.apellido=apellido) then begin
			if(p.nombre=nombre) then begin
				p.fecNac:=fecha;
				seek(a_per, filePos(a_per)-1);
				write(a_per,p);
				encontre:=true;
				close(a_per);
			end;
		end;
		
		if(encontre=true) then begin
			write('Ingrese apellido: '); readln(apellido);
			if(apellido<>'') then begin
				write('Ingrese nombre: '); readln(nombre);
				write('Ingrese nueva fecha de nacimiento ("aaaammdd"): '); readln(fecha);
				reset(a_per);
			end;
		end;
	end;
	if(encontre=false) then begin
		writeln('El apellido y nombre ingresados no existen.');
		close(a_per);
	end;
	writeln;
	writeln('Modificacion finalizada.');
	writeln;
end;

procedure exportar(var a_per:archivo_personas);
var
	p:persona;
	nombreTexto:string;
	textOut:TextFile;
	i:integer;
begin
	reset(a_per);
	nombreTexto:= 'C:/users/ulises/desktop/fod/ej-prac1/personas.txt';
	assign(textOut, nombreTexto);
	rewrite(textOut);
	i:=0;
	while not eof(a_per) do begin
        i:=i+1;
		read(a_per,p);
		writeln(textOut, i, '. ', p.nombre, ' ', p.apellido, '. Fecha de nacimiento: ', p.fecNac);
	end;
	writeln(textOut, 'Total de personas: ', i);
    writeln('Total de personas: ', i);
	close(textOut);
	close(a_per);
	writeln;
	writeln('Exportacion finalizada con exito.');
	writeln;
end;
	

///////////FIN EJ6;

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
	writeln;
	writeln('	################## MENU ##################*');
	writeln('	# ~a: Crear archivo de personas          #*');
	writeln('	# ~b: Listar datos de personas nacidas   #*');
	writeln('        #     en el mes ', valor_mes,' o sin fecha de nac.   #*');
	writeln('	# ~c: Listado de personas.               #*');
	writeln('	# ~d: Agregar personas.                  #*');
	writeln('	# ~e: Modificar fecha de nacimiento.     #*');
    writeln('	# ~f: Exportar archivo a texto           #*');	 
	writeln('	# ~x: Finalizar programa.                #*');
	writeln('	##########################################*');
	writeln('	#       FOD - REGISTRO DE PERSONAS       #*');
	writeln('	##########################################*');
	writeln;
	seguir:= true;
	while(seguir = true) do begin
		write('Ingrese la opcion deseada ("a","b","c","d","e","f" o "x"): ');
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
					if(opcion='d') then
						anadirPer(a_personas)
					else
						if(opcion='e') then
							modificarDatos(a_personas)
                        else
                            if(opcion='f') then
								exportar(a_personas)
							else
								if(opcion='x') then
								seguir:=false;
	end;
	writeln('Presione enter para continuar...');
    readln;
end.
 
