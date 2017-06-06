program ej2p1;
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
	totPares:=0; totImp:=0;
	
	while not eof(arch_num) do begin
		read(arch_num, nro); {se obtiene elemento desde archivo }
        if ((nro MOD 2)=0) then
			totPares:=totPares+1
		else
			totImp:=totImp+1;
	end;
	
	write('El total de numeros pares es: ');
	writeln(totPares);
	write('El total de numeros impares es: ');
	writeln(totImp);
	writeln('Presione enter para finalizar. ');
	readln;
	close(arch_num)
end.


