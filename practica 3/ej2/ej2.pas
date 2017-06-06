program ej5;
const valoralto='ZZZZ';
Type
	persona = record
		apellido: string[25];
		nombre: string[25];
		fecNac: LongInt;
	end;
	
	archivo_personas = file of persona;

procedure leer(var mae:archivo_personas; var p:persona);
begin
	if not eof(mae) then
		read(mae,p)
	else
		p.apellido:=valoralto;
end;
	
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

procedure dardebaja(var mae:archivo_personas);
var
	p:persona; p_ultimo:persona; apellido:string;
begin
	reset(mae);
	seek(mae,filesize(mae)-1);{me posiciono en el final del archivo}
	leer(mae,p_ultimo);{copio a p_ultimo el contenido de ultimo registro del archivo}
	seek(mae,0);{vuelvo al inicio del archivo}
	write('Ingrese el apellido de la persona a eliminar: ');readln(apellido);
	leer(mae,p);
	while (p.apellido<>apellido) and (p.apellido<>valoralto) do
		leer(mae,p);
	if (p.apellido<>valoralto) then begin
		seek(mae,filepos(mae)-1);{vuelvo uno atras}
		write(mae,p_ultimo);{escribo en el espacio libre el contenido del ultimo registro}
		seek(mae,filesize(mae)-1); {voy al ultimo lugar}
		truncate(mae); {trunco el archivo}
		writeln('Registro borrado.');
	end
	else
		writeln('El apellido buscado no existe.');
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
	writeln;
	writeln('	*----------------- MENU -----------------*');
	writeln('# a: Crear archivo de personas.');
	writeln('# b: Listar datos de personas nacidas en el mes ', valor_mes,' o sin fecha de nac.');
	writeln('# c: Listado de personas.');
	writeln('# d: Dar de baja una persona.');
	writeln('# x: Finalizar programa.');
	writeln('	*----------------------------------------*');
	writeln;
	seguir:= true;
	while(seguir = true) do begin
		write('Ingrese la opcion deseada (a,b,c,d,x): ');
		readln(opcion);
		case opcion of
			'a': crearArchivo(a_personas, r_personas);
			'b': listarDatosFecha(a_personas, valor_mes);
			'c': listadoPersonas(a_personas);
			'd': dardebaja(a_personas);
			'x': seguir:=false
		else
			writeln('Esa opcion no existe.');
		end;
	end;
	writeln('Presione enter para continuar...');
	readln;
end.
 
