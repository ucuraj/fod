program ej4;
Type 
	reales = file of real;

procedure agregarNumeros(var arc_logico:reales);
var 
	nro: real;
	tot: integer;
	i:integer;

begin
	rewrite(arc_logico);
	writeln;
	write('Total de numeros a ingresar: ');
	readln(tot);
	
	for i:=1 to tot do begin
		write('NRO ', i, ' : ');
		read(nro);
		write(arc_logico, nro);
    end;
	close(arc_logico);
end;
	
procedure listarNum(var arc_logico: reales);
var
	i:integer;
	nro:real;
begin

	reset(arc_logico);
	writeln;
	while not eof(arc_logico) do begin
        i:=0;
		write('Lista: ');
		while (not eof(arc_logico)) and (i<10) do begin
			read(arc_logico, nro);
			i:=i+1;
			if(i<10) then
				write(nro:0:2, ', ')
			else
				writeln(nro:0:2);
		end;
	end;
	close(arc_logico);
end;

procedure listarDatos(var arc_logico: reales);
var
	totPos, totNeg, tot: integer;
	promPos, promNeg, neg, pos, nro, promGen, totGen: real;
begin
	reset(arc_logico);
	writeln;
	totNeg:= 0; totPos:=0; totGen:= 0; tot:=0; neg:=0; pos:=0;
    while not eof( arc_logico) do begin
		read(arc_logico, nro);
		if (nro<0) then begin
			totNeg:= totNeg+1;
			neg:= neg + nro;
		end
		else begin
			totPos:= totPos+1;
			pos:= pos + nro;
		end;
		
		tot:=tot+1;
		totGen:= totGen + nro;
	end;
	
	promNeg:= neg/totNeg;
	promPos:= pos/totPos;
	promGen:= totGen/tot;
	
	writeln('Total de numeros negativos: ', totNeg, ' - Promedio numeros negativos: ', promNeg:0:2);
	writeln('Total de numeros positivos: ', totPos, ' - Promedio numeros positivos: ', promPos:0:2);
	writeln('Promedio general: ', promGen:0:2);
	close(arc_logico);
end;

var
	arch_nros : reales;
	seguir: boolean;
	opcion: char;
    nombre: string;
	
begin
	write('Ingrese el nombre del archivo: ');
	readln(nombre);
	assign(arch_nros, nombre);
	seguir:= true;
	while (seguir = true) do begin
		writeln;
		writeln('--------------- MENU ---------------');
		writeln('.a: Crear archivo con numeros decimales.');
		writeln('.b: Listar numeros del archivo.');
		writeln('.c: Listar datos de los elementos del archivo.');
		writeln('.x: Terminar programa (teclee x)');
		writeln;
		write('Ingrese opcion (a,b,c o x): '); readln(opcion);
		
		if (opcion = 'a') then
			agregarNumeros(arch_nros)
		else
			if (opcion = 'b') then
				listarNum(arch_nros)
			else
				if(opcion = 'c') then
					listarDatos(arch_nros)
				else
					seguir:= false;
		writeln;
	end;
	writeln('Presione enter para continuar');
	readln;
end.


