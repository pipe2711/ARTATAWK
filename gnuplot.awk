!/usr/bin/awk

function eval(funcion, x) {
    gsub(/y[ ]=/, "", funcion)  # Elimina "y=" si está presente
    cmd = "awk 'function f(x) { return " funcion " } BEGIN { print f(" x ") }'"
    cmd | getline result;
    close(cmd);
    return result;
}

BEGIN {
    print "ARTATAWK"
    print "Ingrese la funcion (por ejemplo: y = x^2):"
    getline funcion
    print "Ingrese el rango de el eje X (Mínimo):"
    getline xmin
    print "Ingrese el rango de el eje X (Máximo):"
    getline xmax 
    print "Ingrese el paso del eje x :"
    getline paso

    step = paso

    ymin = eval(funcion, xmin)
    ymax = eval(funcion, xmin)

    i=0
    for (x = xmin; x <= xmax; x += step) {
        y = eval(funcion, x)

        if (y < ymin) ymin = y
        if (y > ymax) ymax = y
        points[i] = y
        i++
    }

    ymin-=step
    ymax+=step

    print "set title '" funcion "'" > "instructions.plot"
    print "set xlabel 'X'" >> "instructions.plot"
    print "set ylabel 'Y'" >> "instructions.plot"
    print "plot '-' using 1:2 with lines title '" funcion "'" >> "instructions.plot"

    i=0
    for (x = xmin; x <= xmax; x += step) {
        print x " " points[i] >> "instructions.plot"
        i++
    }

    system("gnuplot -persist instructions.plot")

    system ("awk -f main.awk")
}