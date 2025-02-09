#!/usr/bin/awk

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
    print "1.Graficador AWK nativo"
    print "2.GNUPLOT"
    print " "
    getline eleccion;
    print " "

    if (eleccion == 1) {
        print "Ingrese la funcion (por ejemplo: y=x^2):"
        getline funcion
        print "Ingrese el rango de el eje X (Minimo):"
        getline xmin
        print "Ingrese el rango de el eje X (Maximo):"
        getline xmax 
        print "Ingrese el paso del eje x :"
        getline paso 

        step = paso

        print " "

        #////////////////////////////////////////
        #Tabla para imprimir resultados

        print "x\tsin(x)\tcos(x)\ttan(x)"
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

        print "label " funcion > "sample.graph"
        print "height 30" >> "sample.graph"
        print "width 150" >> "sample.graph"
        print "offset x 0" >> "sample.graph"
        print "range " xmin " " ymin " " xmax " " ymax >> "sample.graph"
        
        # Ticks verticales
        printf "left ticks " >> "sample.graph"
        for (j = ymin; j <= ymax; j += (ymax - ymin) / 10) {
            printf j " " >> "sample.graph"
        }
        print "" >> "sample.graph"

        # Ticks horizontales
        printf "bottom ticks " >> "sample.graph"
        for (j = xmin; j <= xmax; j += (xmax - xmin) / 10) {
            printf j " " >> "sample.graph"
        }
        print "" >> "sample.graph"

        i = 0
        for (x = xmin; x <= xmax; x += step) {
            print " " x " " points[i] >> "sample.graph"
            i++
        }

        system ("awk -f graficador.awk sample.graph")
    }

    else if (eleccion == 2) {
        system ("awk -f gnuplot.awk")
    }

    system ("awk -f main.awk")
}