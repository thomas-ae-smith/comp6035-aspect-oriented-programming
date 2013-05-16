//
//  Part3.h
//  Templates
//
//  Created by taes1g09 on 16/05/2013.
//  Copyright (c) 2013 taes1g09. All rights reserved.
//

#ifndef Templates_Part3_h
#define Templates_Part3_h

static int vIndex = 0;
static void resetVIndex() {
    vIndex = 0;
};

template <int LOW, int UPP>
class BOUNDS {
public:
    enum {
        LOWER = LOW,
        UPPER = UPP
    };
};

template< class B >
struct X
{
    enum {
        LOWER = B::LOWER,
        UPPER = B::UPPER
    };
    
	static inline int eval(int x[]) throw (bool) {
        if ( x[vIndex] < B::LOWER ) {
            throw true;
        }
        if ( x[vIndex] > B::UPPER ) {
            throw false;
        }
        return x[vIndex++];
	};
};

template<int X>
struct LIT
{
    enum {
        LOWER = X,
        UPPER = X
    };
    
	static inline int eval(int x[]) {
		return (int)X;
	};
};

template<class L, class R>
struct ADD
{
    enum {
        LOWER = L::LOWER + R::LOWER,
        UPPER = L::UPPER + R::UPPER
    };
    
	static inline int eval(int x[]) {
		return L::eval(x) + R::eval(x);
	};
};

template<class L, class R>
struct SUB
{
    enum {
        LOWER = L::LOWER - R::UPPER,
        UPPER = L::UPPER - R::LOWER
    };
    
	static inline int eval(int x[]) {
		return L::eval(x) - R::eval(x);
	};
};

template<class L, class R>
struct MUL
{
    enum {
        LOWER = L::LOWER * R::LOWER,
        UPPER = L::UPPER * R::UPPER
    };
    
	static inline int eval(int x[]) {
		return L::eval(x) * R::eval(x);
	};
};

template<class L, class R>
struct DIV
{
    enum {
        LOWER = L::LOWER / R::UPPER,
        UPPER = L::UPPER / R::LOWER
    };
    
	static inline int eval(int x[]) {
		return L::eval(x) / R::eval(x);
	};
};





#endif  //Templates_Part3_h
