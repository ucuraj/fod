program encuesta;

const valoralto=9999;

Type
	votoA=record
		codF:integer;
		codC:integer;
		anio:integer;
		agrup:1..5;
	end;
	
	maestro = file of votoA;
	agrupacion = array[1..5] of integer;
	anioA = array[1..6] of agrupacion;
	
procedure leer(var m:maestro; var r:votoA);
begin
	if not eof(m) then
		read(m,r)
	else
		r.codF:=valoralto;
end;

procedure exportar(var a_encuesta:maestro; var textOut:textFile);
var
	r:votoA;
begin
	reset(a_encuesta);
	rewrite(textOut);
	while(r.codF<>valoralto) do begin
		leer(a_encuesta,r);
		writeln(textOut,'Codigo Fac: ',r.codF,' Codigo Carrera: ',r.codC,' Año: ',r.anio,' Voto: ',r.agrup);
	end;
	close(textOut);
	writeln('datosencuesta.txt creado exitosamente.');
	writeln;
	close(a_encuesta);
end;

procedure ejecutar(var a_encuesta:maestro);
var
	r:votoA; totCar,totFac,totGen:integer;
	car,fac,anio:integer; vAgrup:agrupacion; vAnio:anioA; i:integer;
begin
	reset(a_encuesta);
	totGen:=0;
	leer(a_encuesta,r);
	while (r.codF<>valoralto) do begin
		writeln('Facultad: ',r.codF);
		totFac:=0;
		fac:=r.codF;
		while(fac=r.codF) do begin
			writeln('Carrera: ',r.codC);
			totCar:=0;
			car:=r.codC;
			while (fac=r.codF) and (car=r.codC) do begin
				anio:=r.anio;
				for i:= 1 to 5 do
					vAgrup[i]:=0;
				while (fac=r.codF) and (car=r.codC) and (anio=r.anio) do begin
					vAgrup[r.agrup]:=vAgrup[r.agrup]+1;
					totCar:=totCar+1; 
					leer(a_encuesta,r);
				end;

				vAnio[anio]:=vAgrup;
			end;
			writeln('Agrupacion 1	', 'Agrupacion 2	', 'Agrupacion 3	', 'Agrupacion 4	', 'Agrupacion 5');
			writeln('1er año: ', vAnio[1][1]:1, '1er año: ':16, vAnio[1][2]:1, '1er año: ':16, vAnio[1][3]:1, '1er año: ':16, vAnio[1][4]:1, '1er año: ':16, vAnio[1][5]:1);
			writeln('2do año: ', vAnio[2][1]:1, '2do año: ':16, vAnio[2][2]:1, '2do año: ':16, vAnio[2][3]:1, '2do año: ':16, vAnio[2][4]:1, '2do año: ':16, vAnio[2][5]:1);
			writeln('3er año: ', vAnio[3][1]:1, '3er año: ':16, vAnio[3][2]:1, '3er año: ':16, vAnio[3][3]:1, '3er año: ':16, vAnio[3][4]:1, '3er año: ':16, vAnio[3][5]:1);
			writeln('4to año: ', vAnio[4][1]:1, '4to año: ':16, vAnio[4][2]:1, '4to año: ':16, vAnio[4][3]:1, '4to año: ':16, vAnio[4][4]:1, '4to año: ':16, vAnio[4][5]:1);
			writeln('5to año: ', vAnio[5][1]:1, '5to año: ':16, vAnio[5][2]:1, '5to año: ':16, vAnio[5][3]:1, '5to año: ':16, vAnio[5][4]:1, '5to año: ':16, vAnio[5][5]:1);
			writeln('6to año: ', vAnio[6][1]:1, '6to año: ':16, vAnio[6][2]:1, '6to año: ':16, vAnio[6][3]:1, '6to año: ':16, vAnio[6][4]:1, '6to año: ':16, vAnio[6][5]:1);
			
			writeln;
			writeln('Total Carrera: ',totCar);
			totFac:=totFac+totCar;
			writeln;
		end;
		writeln('Total Facultad: ',totFac);
		totGen:=totGen+totFac;
		writeln;
	end;			
	write('Total General: ',totGen);
	writeln;
	close(a_encuesta);
end;

// P.P
var
	a_encuesta:maestro; 
	texto_encuesta:textFile;
	seguir:boolean; opcion:char;
begin
	assign(a_encuesta,'datosencuesta.dat');
	assign(texto_encuesta,'datosencuesta.txt');
	
	writeln('-------MENU DE OPCIONES-------');
	writeln('a. Listar datos de la encuesta en "datosencuesta.txt"');
	writeln('b. Ejecutar programa');
	writeln('x. Finalizar programa');
	
	seguir:=true;
	while (seguir) do begin
		write('Ingrese la opcion deseada(a,b o x): ');readln(opcion);
		case opcion of
			'a': exportar(a_encuesta,texto_encuesta);
			'b': ejecutar(a_encuesta);
			'x': seguir:=false;
		end;
	end;
	
	writeln('Programa finalizado');
	writeln('Presione enter para continuar...');
	readln;
end.
