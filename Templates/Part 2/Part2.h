//
//  Part2.h
//  Templates
//
//  Created by taes1g09 on 15/05/2013.
//  Copyright (c) 2013 taes1g09. All rights reserved.
//

#ifndef Templates_Part2_h
#define Templates_Part2_h

template <int LOW, int UPP>
class BOUNDS {
    enum {
        LOWER = LOW,
        UPPER = UPP
    };
};

template< template <int,int> class BOUNDS >
struct X
{
//    enum {
//        LOWER = BOUNDS::LOWER,
//        UPPER = BOUNDS::UPPER
//    };

	static inline int eval(int x) {
//        if ( (x < BOUNDS::LOWER ) || (x > BOUNDS::UPPER) ) {    //TODO: separate
//            throw "Value for x lies outside bounds";
//        }
        return x;
	};
};

template<int X>
struct LIT
{
    enum {
        LOWER = X,
        UPPER = X
    };
    
	static inline int eval(int x) {
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
    
	static inline int eval(int x) {
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

	static inline int eval(int x) {
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

	static inline int eval(int x) {
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

	static inline int eval(int x) {
		return L::eval(x) / R::eval(x);
	};
};



#endif //Templates_Part2_h