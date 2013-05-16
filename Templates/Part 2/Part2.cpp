//
//  Part2.cpp
//  Templates
//
//  Created by taes1g09 on 15/05/2013.
//  Copyright (c) 2013 taes1g09. All rights reserved.
//


#include <iostream>
#include "Part2.h"

int main (int argc, const char * argv[])
{
    
    //  x+(x-2)*(x-3)
    typedef ADD< X< BOUNDS<0, 10> >, MUL< SUB< X< BOUNDS<0, 10> >, LIT<2> >, SUB< X<BOUNDS<0, 10>>, LIT<3> > > > EXP;
    EXP x;
    
    int low = 3;
    int high = 10;
    int toohigh = 100;
    
    printf("Welcome to Part 4\n.");
    
    printf("With range 0-10, lower bound is %d and upper bound is %d\n", x.LOWER, x.UPPER );
    
    printf("Input %d, output %d\n", low, x.eval(low) );
    printf("Input %d, output %d\n", high, x.eval(high) );
    try {
        printf("Input %d, output %d\n", toohigh, x.eval(toohigh) );
    } catch (bool e) {
        printf("%s\n", e? "Value for x is too small" : "Value for x is too large");
    }

    
    
    return 0;
    
}
