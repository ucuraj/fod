program ej1p1;
Type
    numero = file of integer;
var
   nombreArch:string;
   nro:integer;
   arch_num: numero;

begin
	write('Ingrese el nombre del archivo: ');
	readln(nombreArch);
	assign(arch_num, nombreArch);
	rewrite(arch_num);
	write('Ingrese un numero: ');
	readln(nro);
	while (nro<>0) do begin
		write(arch_num, nro);
		write('Ingrese otro numero: ');
		readln(nro);
	end;
			
	writeln('Ingreso el numero 0, presione enter para finalizar. ');
	readln;
    close(arch_num);
end.



