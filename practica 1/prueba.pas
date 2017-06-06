program CreateFile;
 
uses
 Sysutils;
 
Type
    persona = record
		apellido: string[25];
		nombre: string[25];
		fecNac: LongInt;
	end;

const
  C_FNAME = 'textfile.txt';
 
var
  tfOut: TextFile; // tipo fichero de salida.
  p:persona;
 
begin
  // Establece el nombre del fichero que vamos a crear
  AssignFile(tfOut, C_FNAME);
  p.nombre:='Ulises';
  p.apellido:='Cura Jauregui';
  p.fecNac:=19971220;
 
  // Habilitamos el uso de excepciones para interceptar los errores (esto es como está por defecto por lo tanto no es absolutamente requerido)
 
  {$I+}
 
  // Embebe la creación del fichero en un bloque try/except para manejar los errores elegántemente.
 
  try
 
    //crea el fichero, escribe algo de texto y lo cierra.
    ReWrite(tfOut);
    WriteLn ('A continuación escribimos algo de texto al fichero ya que ponemos en WriteLn tfOut como salida');
    WriteLn(tfOut, '¡Hola textfile!');
    WriteLn(tfOut, 'Esto que se escribe directamente al fichero, no aparece por pantalla: ', 42);
    writeln(tfOut, 42,' ', 31,' ', 33, ' ', 32);
    writeln(tfOut, p.nombre, ' ', p.apellido, '. Fecha de nacimiento: ', p.fecNac);
 
    CloseFile(tfOut); // Hemos terminado de escribir el texto en el fichero, por tanto le cerramos.
 
  except
    // Si ocurre algún error podemos encontrar la razón en E: EInOutError
      WriteLn('A continuación imprimimos en pantalla mediante E.ClassName / E.Message:'); 
      WriteLn('Ha ocurrido un error en el manejo del fichero. Detalles: ');
      WriteLn ('Por otro lado podemos imprimir en pantalla el valor de la variable IOResult que es: ',IOResult);
 
    //  Tambien podemos ponerlo de la forma: 
    //  on E: EInOutError do
    //    begin
    //      Writeln('Ha ocurrido un error en el manejo del fichero. Detalle: '+E.ClassName,'/',E.Message);
    //    end;
 
  // Da información y espera por la pulsación de una tecla.
  writeln('Fichero ', C_FNAME, ' creado si todo fue bien. Presiona Enter para finalizar.');
  ReadLn;
end;
readln;
readln;
end.
