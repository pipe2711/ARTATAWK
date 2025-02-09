#! /usr/bin/awk

function eval(funcion, x) {
    gsub(/y[ ]=/, "", funcion)  # Elimina "y=" si está presente
    cmd = "awk 'function f(x) { return " funcion " } BEGIN { print f(" x ") }'"
    cmd | getline result;
    close(cmd);
    return result;
}

BEGIN {
    print "======== Bienvenido a ARTATAWK ========"
    print " "
    print "~ ~ ~ Herramienta para graficar ~ ~ ~" 
    print " "
    print "Ingrese la funcion (por ejemplo: y=x^2):"
    getline funcion
    print "Ingrese el rango de el eje X (Minimo):"
    getline xmin
    print "Ingrese el rango de el eje X (Maximo):"
    getline xmax
    print "Ingrese el paso del eje x:"
    getline step

    print " "
    print "Seleccione el tipo de graficador"
    print "1.Graficador AWK nativo"
    print "2.GNUPLOT"
    getline eleccion;
    print " "

    #////////////////////////////////////////
    #Tabla para imprimir resultados

    print "x\tsin(x)\tcos(x)\ttan(x)"
    for (x = xmin; x <= xmax; x+=step)
        printf("%0.3f\t%0.3f\t%0.3f\t%0.3f\n", x, eval("sin(x)", x), eval("cos(x)", x), eval("sin(x)/cos(x)", x))
    print " "

    #////////////////////////////////////////

    ymin = eval(funcion, xmin)
    ymax = eval(funcion, xmin)

    i = 0
    for (x = xmin; x <= xmax; x += step) {
        y = eval(funcion, x)

        if (y < ymin) ymin = y
        if (y > ymax) ymax = y
        points[i] = y
        i++
    }

    ymin -= step
    ymax += step

    if (eleccion == 1) {
        print "label " funcion > "sample.graph"
        print "height 30" >> "sample.graph"
        print "width 100" >> "sample.graph"
        print "offset x 0" >> "sample.graph"
        print "range " xmin " " ymin " " xmax " " ymax >> "sample.graph"

        # Ticks verticales
        printf "left ticks " >> "sample.graph"
        for (j = ymin; j <= ymax; j += (ymax - ymin) / 10)
            printf ("%.1f ", j) >> "sample.graph"
        print "" >> "sample.graph"

        # Ticks horizontales
        printf "bottom ticks " >> "sample.graph"
        for (j = xmin; j <= xmax; j += (xmax - xmin) / 10)
            printf j " " >> "sample.graph"
        print "" >> "sample.graph"

        i = 0
        for (x = xmin; x <= xmax; x += step) {
            print " " x " " points[i] >> "sample.graph"
            i++
        }

        system ("awk -f graficador.awk sample.graph")
        print "\n"
    }

    else if (eleccion == 2) {
        print "set title '" funcion "'" > "instructions.plot"
        print "set xlabel 'X'" >> "instructions.plot"
        print "set ylabel 'Y'" >> "instructions.plot"
        print "plot '-' using 1:2 with lines title '" funcion "'" >> "instructions.plot"

        i=0
        for (x = xmin; x <= xmax; x += step) {
            print x " " points[i] >> "instructions.plot"
            i++
        }

        system("cat instructions.plot | gnuplot -persist")
    }
}
