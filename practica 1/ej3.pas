program ej3p1;
Type
    numero = file of integer;
var
   nombreArch:string;
   nro:integer;
   arch_num: numero;
   totPares, totImp: integer;

begin
	write('Ingrese el nombre del archivo: ');
	readln(nombreArch);
	assign(arch_num, nombreArch);
	reset(arch_num);
	
	while not eof(arch_num) do begin
		read(arch_num, nro);
		writeln(nro);
	end;
	
	writeln('Presione enter para finalizar. ');
	readln;
	close(arch_num)
end.


