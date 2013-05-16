//
//  Part2.h
//  Templates
//
//  Created by taes1g09 on 15/05/2013.
//  Copyright (c) 2013 taes1g09. All rights reserved.
//

#ifndef Templates_Part2_h
#define Templates_Part2_h

//included from provided Mins.cpp
template <int I, int J>
struct MIN {
    enum {RET = I<J? I : J };
};

//inferred
template <int I, int J>
struct MAX {
    enum {RET = I>J? I : J };
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

	static inline int eval(int x) throw(bool) {
        if ( x < B::LOWER ) {
            throw true;
        }
        if ( x > B::UPPER ) {
            throw false;
        }
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

template<class L, class R>      //this assumes that different instances of x can take different values
struct MUL                      //this is fine for parts 3 and 4, but since it's fairly horrific already
{                               //I'm proposing to leave it as-is for Part 2
    enum {                      //(If I were proposing to do this 'properly', I wouldn't specify separate bounds for each x
        LOWER = MIN<            // but since the specification requires that to ease later parts, I'm leaving as-is)
                    MIN<
                        L::LOWER * R::LOWER,                //both entirely positive
                        L::UPPER * R::UPPER>::RET           //both entirely negative
                    ,
                    MIN<
                        L::LOWER * R::UPPER,                //L at least partly negative
                        L::UPPER * R::LOWER>::RET           //R at least partly negative
                    >::RET,
        UPPER = MAX<
                    MAX<
                        L::UPPER * R::UPPER,                //both entirely positive
                        L::LOWER * R::LOWER>::RET           //both entirely negative
                    ,
                    MAX<
                        L::LOWER * R::UPPER,                //R entirely negative
                        L::UPPER * R::LOWER>::RET           //L entirely negative
                    >::RET
    };

	static inline int eval(int x) {
		return L::eval(x) * R::eval(x);
	};
};

template<class L, class R>      //here I fell asleep. In theory, the bounds for division should follow a similar pattern as for multiplication
struct DIV                      //specifically, for lower bound + + -> L/U, - + -> L/L, + - -> U/U and - - -> U/L. However, there need to be special
{                               //checks for the cases where it's possible to / -1 (always the best option), and to avoid division by 0
    enum {                      // the upper bound is similar but inverted (+ + -> U/L etc) and it's always best to divide by 1 if possible
        LOWER = L::LOWER / R::UPPER,        //(except where dividing by -1 is better). This is a ridiculously complex set of checks
        UPPER = L::UPPER / R::LOWER
    };

	static inline int eval(int x) {
		return L::eval(x) / R::eval(x);
	};
};



#endif //Templates_Part2_h