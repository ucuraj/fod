program p;
var
	i:integer;
 a,b,c:longInt;
begin
 for i:=1 to 10 do begin
			writeln('NRO ', i, ' : ');
	end;
 a:=((19971220 MOD 10000) DIV 100);
 writeln(a);
 b:=(19971220 div 10000);
 writeln(b);
 c:=(19971220 MOD 10000) MOD 100;
 writeln(c);
     readln;
end.
