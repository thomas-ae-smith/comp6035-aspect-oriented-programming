//
//  Part1.h
//  Templates
//
//  Created by taes1g09 on 15/05/2013.
//  Copyright (c) 2013 taes1g09. All rights reserved.
//

#ifndef Templates_Part1_h
#define Templates_Part1_h

//terminal
struct X
{
	static inline int eval(int x) {
        return x;
	};
};

//literal
template<int X>
struct LIT
{
	static inline int eval(int x) {
		return (int)X;
	};
};

//addition (preferred notation of L-value and R-value, semantically clearer than A & B)
template<class L, class R>
struct ADD
{
	static inline int eval(int x) {
		return L::eval(x) + R::eval(x);
	};
};

//subtraction
template<class L, class R>
struct SUB
{
	static inline int eval(int x) {
		return L::eval(x) - R::eval(x);
	};
};

//multiplication
template<class L, class R>
struct MUL
{
	static inline int eval(int x) {
		return L::eval(x) * R::eval(x);
	};
};

//division
template<class L, class R>
struct DIV
{
	static inline int eval(int x) {
		return L::eval(x) / R::eval(x);
	};
};

#endif //Templates_Part1_h


