//
//  Part1.h
//  Templates
//
//  Created by taes1g09 on 15/05/2013.
//  Copyright (c) 2013 taes1g09. All rights reserved.
//

#ifndef Templates_Part1_h
#define Templates_Part1_h

struct X
{
	static inline int eval(int x) {
        return x;
	};
};

template<int X>
struct LIT
{
	static inline int eval(int x) {
		return (int)X;
	};
};

template<class L, class R>
struct ADD
{
	static inline int eval(int x) {
		return L::eval(x) + R::eval(x);
	};
};

template<class L, class R>
struct SUB
{
	static inline int eval(int x) {
		return L::eval(x) - R::eval(x);
	};
};

template<class L, class R>
struct MUL
{
	static inline int eval(int x) {
		return L::eval(x) * R::eval(x);
	};
};

template<class L, class R>
struct DIV
{
	static inline int eval(int x) {
		return L::eval(x) / R::eval(x);
	};
};

#endif //Templates_Part1_h


