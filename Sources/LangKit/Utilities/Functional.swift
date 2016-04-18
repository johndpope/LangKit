//
//  Functional.swift
//  LangKit
//
//  Created by Richard Wei on 4/15/16.
//
//
/*
 * This is a micro functional toolset that does not expect too much abstraction
 */

public func identity<T>(x: T) -> T {
    return x
}

// Curry
// ((a, b) -> c) -> a -> b -> c
public func curry<A, B, C>(f: (A, B) -> C) -> A -> B -> C {
    return { x in { y in f(x, y) } }
}
// ((a, b, c) -> d) -> a -> b -> c -> d
public func curry<A, B, C, D>(f: (A, B, C) -> D) -> A -> B -> C -> D {
    return { x in { y in { z in f(x, y, z) } } }
}

// Uncurry
// (a -> b -> c) -> (a, b) -> c
public func curry<A, B, C>(f: A -> B -> C) -> (A, B) -> C {
    return { (x, y) in f(x)(y) }
}
// (a -> b -> c -> d) -> (a, b, c) -> d
public func curry<A, B, C, D>(f: A -> B -> C -> D) -> (A, B, C) -> D {
    return { (x, y, z) in f(x)(y)(z) }
}

/*************
 * Operators *
 *************/

infix  operator |>  { associativity left  }
infix  operator <|  { associativity left  }
infix  operator •   { associativity right }
infix  operator >>- { associativity left  }
infix  operator -<< { associativity right }
infix  operator >-> { associativity left  }
infix  operator >>§ {                     }
infix  operator <*> { associativity left  }
infix  operator <^> { associativity left  }

/* Pipeline */
// Reverse function application
public func |><A, B>(lhs: A, rhs: A -> B) -> B {
    return rhs(lhs)
}
// Function application
public func <|<A, B>(lhs: A -> B, rhs: A) -> B {
    return lhs(rhs)
}

/* Compose */
// f(x) • g(x) = f(g(x))
public func •<A, B, C>(f: B -> C, g: A -> B) -> A -> C {
    return { f(g($0)) }
}
// f(x, y) • g(x) = f(g(x), g(y))
public func •<A, B, C>(f: (B, B) -> C, g: A -> B) -> (A, A) -> C {
    return { f(g($0), g($1)) }
}
// f(x, y) • g(x) = f(x, g(y))
public func •<A, B, C>(f: (B, B) -> C, g: A -> B) -> (B, A) -> C {
    return { f($0, g($1)) }
}
// f(x, y) • g(x) = f(g(x), y)
public func •<A, B, C>(f: (B, B) -> C, g: A -> B) -> (A, B) -> C {
    return { f(g($0), $1) }
}

/* Monad - Compose */
// Optional
public func >-><A, B, C>(f: A -> B?, g: B -> C?) -> A -> C? {
    return { x in f(x) >>- g }
}
// Sequence
public func >-><A, B, C, MB: Sequence, MC: Sequence where MB.Iterator.Element == B, MC.Iterator.Element == C> (f: A -> MB, g: B -> MC) -> A -> [C] {
    return { x in f(x).flatMap(g) }
}

/* Monad - Bind */
// Optional
public func >>-<A, B>(lhs: A?, rhs: A -> B?) -> B? {
    return lhs.flatMap(rhs)
}
public func -<<<A, B>(lhs: A -> B?, rhs: A?) -> B? {
    return rhs.flatMap(lhs)
}
// Sequence
public func >>-<A, B, MA: Sequence where MA.Iterator.Element == A>(lhs: MA, rhs: A -> [B]) -> [B] {
    return lhs.flatMap(rhs)
}
public func -<<<A, B, MA: Sequence where MA.Iterator.Element == A>(lhs: A -> [B], rhs: MA) -> [B] {
    return rhs.flatMap(lhs)
}

/* Applicative - Apply */
// Optional
public func <*><A, B>(lhs: (A -> B)?, rhs: A?) -> B? {
    return lhs.flatMap{f in rhs.map(f)}
}
// Sequence
public func <*><A, B, FAB: Sequence, FA: Sequence where FAB.Iterator.Element == (A -> B), FA.Iterator.Element == A>(lhs: FAB, rhs: FA) -> [B] {
    return lhs.flatMap{f in rhs.map(f)}
}

/* Functor - Map */
// Optional
public func <^><A, B>(lhs: A -> B, rhs: A?) -> B? {
    return rhs.map(lhs)
}
// Sequence
public func <^><A, B, FA: Sequence where FA.Iterator.Element == A>(lhs: A -> B, rhs: FA) -> [B] {
    return rhs.map(lhs)
}

/* Monad - Bind and invoke instance method */
// Optional
public func >>§<A, B>(a: A?, b: A -> () -> B?) -> B?  {
    return a >>- §b
}
// Array
public func >>§<A, B, MA: Sequence where MA.Iterator.Element == A>(a: MA, b: A -> () -> [B]) -> [B]  {
    return a >>- §b
}

