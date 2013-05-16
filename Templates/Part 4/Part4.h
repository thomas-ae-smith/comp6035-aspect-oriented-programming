//
//  Part4.h
//  Templates
//
//  Created by taes1g09 on 16/05/2013.
//  Copyright (c) 2013 taes1g09. All rights reserved.
//

#ifndef Templates_Header_h
#define Templates_Header_h

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

static int vIndex = 0;
static void resetVIndex() {
    vIndex = 0;
};

//0 to 255 is type: char
//0to 65535is type: unsignedint
//-32768 to 32767 is type: int
//any other integer value is type: long

// inspired by http://stackoverflow.com/questions/7651566/template-specialization-for-a-range-of-values
template<size_t N> struct select { typedef long type; };
template<> struct select<0> { typedef char type; };
template<> struct select<1> { typedef unsigned int type; };
template<> struct select<2> { typedef int type; };

template<int IN>
struct IntDecl {
    
    enum{ D = (IN >= 0)? ( (IN <= 255)?  0 : (IN <= 65535)? 1 : 3 ) : (IN >= -32767)? 2 : 3 };
    
    typedef typename select<D>::type TYPE;
    TYPE type;
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
    
	static inline int eval(int x[]) throw(bool) {
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

template<class L, class R>      //this assumes that different instances of x can take different values
struct MUL
{
    enum {
        LOWER = MIN<
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
        
	static inline int eval(int x[]) {
		return L::eval(x) * R::eval(x);
	};
};

template<class L, class R>      //see part 2
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






#endif  //Templates_Part4_h
