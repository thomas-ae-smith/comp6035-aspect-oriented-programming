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
struct BOUNDS {
    enum { LOWER = LOW, UPPER = UPP };
};

template<BOUNDS<1, 2> B>
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


template <class A>
struct POS
{
    enum { RET = true };
};

template <>
struct POS< P >
{
    enum { RET = true};
};

template <bool V>
struct POS< LIT<V> >
{
    enum { RET = true};
};


template <class A>
struct POS< NOT<A> >
{
    enum {RET = ! POS<A>::RET };
};


template <class A, class B>
struct POS< AND<A,B> > {
    enum {RET = POS<A>::RET && POS<B>::RET};
};


template <class A, class B>
struct POS< OR<A,B> > {
    enum {RET = POS<A>::RET && POS<B>::RET};
};

template <class A, class B>
struct POS< IMP<A,B> > {
    enum {RET = !POS<A>::RET && POS<B>::RET};
};













#endif //Templates_Part2_h