#!/usr/bin/awk -f

function eval(funcion, x) {
    cmd = "awk 'function f(x) { return " funcion " } BEGIN { print f(" x "); }'";
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

    
    print "label" " " funcion
    print "height  40"
    print "width  60"
    print "offset x  0"
    print "range " xmin " " ymin " " xmax " " ymax
    print "left ticks " xmin " " xmax
    print "bottom ticks " ymin " " ymax

  
    for (x = xmin; x <= xmax; x += step) {
        print " " x " " points[x]
    }
}
