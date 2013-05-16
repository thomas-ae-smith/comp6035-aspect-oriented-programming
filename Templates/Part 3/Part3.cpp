//
//  Part3.cpp
//  Templates
//
//  Created by taes1g09 on 16/05/2013.
//  Copyright (c) 2013 taes1g09. All rights reserved.
//


#include <iostream>
#include "Part3.h"

int main (int argc, const char * argv[])
{
    
    //  x+(x-2)*(x-3)
    typedef ADD< X< BOUNDS<0, 10> >, MUL< SUB< X< BOUNDS<0, 10> >, LIT<2> >, SUB< X<BOUNDS<0, 10>>, LIT<3> > > > EXP;
    EXP x;
    
    int low[] = {3, 4, 5};
    int high[] = {10, 9, 8};
    int toohigh[] = {100, 90, 80};
    
    int outputs[3];
    
    printf("Welcome to Part 4\n.");
    
    printf("With range 0-10, lower bound is %d and upper bound is %d\n", x.LOWER, x.UPPER );
    
    printf("Input {%d, %d, %d}, output %d\n", low[0], low[1], low[2], outputs[0] = x.eval(low) );
    resetVIndex();
    printf("Input {%d, %d, %d}, output %d\n", high[0], high[1], high[2], outputs[1] = x.eval(high) );
    resetVIndex();
    try {
        printf("Input {%d, %d, %d}, output %d\n", toohigh[0], toohigh[1], toohigh[2], outputs[2] = x.eval(toohigh) );
    } catch (bool e) {
        printf("%s\n", e? "A value for x is too small" : "A value for x is too large");
    }
    
    printf("outputs[] = {%d, %d, %d}\n", outputs[0], outputs[1], outputs[2]);
    
    
    return 0;
    
}
