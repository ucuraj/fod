program ej6;
Type
	mesa=record
		codP:integer;
		codL:integer;
		num:integer;
		cant:integer;
	end;
	
	votos = file of mesa;
	
const valoralto=999;

procedure leer(var mae:votos; var reg:mesa);
begin
	if not eof(mae) then
		read(mae,reg)
	else
		reg.codP:=valoralto;
end;
	
procedure leerReg(var m:mesa);
begin
	write('Ingrese el codigo de provincia: '); readln(m.codP);
	if (m.codP <> -1) then begin
		write('Ingrese el codigo de localidad: '); readln(m.codL);
		write('Ingrese el numero de mesa: '); readln(m.num);
		write('Ingrese la cantidad de votos: '); readln(m.cant);
	end;
end;
	
procedure crearArchivo(var mae:votos);
var 
	m:mesa;
begin
	rewrite(mae);
	writeln('Para finalizar ingrese codigo de pronvincia "-1"');
	leerReg(m);
	while (m.codP<>-1) do begin
		write(mae,m);
		leerReg(m);
	end;
	writeln('Archivo creado correctamente.');
	close(mae);
end;

// P.P

var 
	mae:votos; m:mesa; codProv,totGen,totProv:integer;  opcion:char;
begin
	assign(mae,'C:\Users\Ulises\Desktop\FOD\practica 2\datosej6.dat');
    write('Crear archivo de provincia?(s=si, n=no): '); readln(opcion);
    if opcion='s' then
		crearArchivo(mae);
    write('Listar archivo en pantalla?(s=si, n=no): '); readln(opcion);
	
    if opcion='n' then begin
		reset(mae);
		while not eof(mae) do begin
			read(mae,m);
			writeln('Codigo Provincia: ', m.codP, ' - Codigo de Localidad: ', m.codL, ' - Numero de Mesa: ', m.num, ' - Votos de la mesa: ', m.cant);
		end;
		close(mae);
	end;

	reset(mae);
	leer(mae,m);
	totGen:=0;
	while (m.codP<>valoralto) do begin
		totProv:=0;
        codProv:=m.codP;
		writeln('Cod Prov: ',codProv);
		while(codProv=m.codP) and (m.codP<>valoralto) do begin
			writeln('Codigo de Localidad: ', m.codL, ' Total de Votos: ', m.cant);
			totProv:=totProv+m.cant;
			codProv:=m.codP;
			leer(mae,m);
		end;
		totGen:=totGen+totProv;
		writeln('Total de Votos Provincia: ', totProv);
		codProv:=m.codP;
		writeln;
	end;
	writeln('Total general de votos: ', totGen);
	close(mae);
	readln;
end.
