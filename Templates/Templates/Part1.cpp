//
//  Part1.cpp
//  Templates
//
//  Created by taes1g09 on 15/05/2013.
//  Copyright (c) 2013 taes1g09. All rights reserved.
//


#include <iostream>
#include "Part1.h"

int main (int argc, const char * argv[])
{
    
    //  x+(x-2)*(x-3)
    typedef ADD< X, MUL< SUB< X, LIT<2> >, SUB< X, LIT<3> > > > EXP;
    EXP x;
    
    int low = 3;
    int high = 10;
    
    printf("Welcome to Part 1\n");
    
    printf("Input %d, output %d\n", low, x.eval(low) );
    printf("Input %d, output %d\n", high, x.eval(high) );
    
    
    return 0;
    
}
