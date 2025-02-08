function eval(funcion, x) {
	if (funcion ~ "^y[ ]*=*") { 
		# Evitar vulnerabilidades
		cmd = "awk 'function f(x) { return " funcion " } BEGIN { print f(" x "); }'";
		cmd | getline line;
		close(cmd);
		return line;
	}
}

BEGIN {
	print "ARTATAWK";
	print "Ingrese la funcion que quiere graficar : ";
	getline x_inicial x_final;
	getline funcion;
}
