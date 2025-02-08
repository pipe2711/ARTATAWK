#!/usr/bin/awk -f

function eval(funcion, x) {
    gsub(/y[ ]*=*/, "", funcion)  # Elimina "y=" si está presente
    cmd = "awk 'function f(x) { return " funcion " } BEGIN { print f(" x ") }'"
    cmd | getline result;
    close(cmd);
    return result;
}

BEGIN {

    print "ARTATAWK"
    print "Ingrese la funcion (por ejemplo: y=x^2):"
    getline funcion

    xmin = -10
    xmax = 10
    step = 1  

    ymin = 99
    ymax = -99

    print "Calculando valores..."
    for (x = xmin; x <= xmax; x += step) {
        y = eval(funcion, x)  
        
        if (y < ymin) ymin = y
        if (y > ymax) ymax = y
        points[x] = y
    }

    
    print "label" " " funcion > "sample.graph"
    print "height  40" >> "sample.graph"
    print "width  60" >> "sample.graph"
    print "offset x  0" >> "sample.graph"
    print "range " xmin " " ymin " " xmax " " ymax >> "sample.graph"
    print "left ticks " xmin " " xmax >> "sample.graph"
    print "bottom ticks " ymin " " ymax >> "sample.graph"

  
    for (x = xmin; x <= xmax; x += step) {
        print " " x " " points[x] >> "sample.graph"
    }
}
