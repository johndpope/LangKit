//
//  Functional.swift
//  LangKit
//
//  Created by Richard Wei on 4/15/16.
//
//

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
infix  operator >>§ {}
infix  operator <*> { associativity left  }
infix  operator <^> { associativity left  }
prefix operator !!  {                     }
prefix operator §   {                     }
infix  operator <++ {                     }

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

/* Invoke instance method */
public prefix func §<A, B>(f: A -> () -> B) -> A -> B {
    return {f($0)()}
}

/* Generate sequence */
public prefix func !!<A, B: Sequence where B.Iterator.Element == A>(sequence: B) -> [A] {
    return sequence.map{$0}
}

/* Increment dictionary key */
public func <++<K, V: Integer>(dictionary: inout [K: V], key: K) {
    dictionary[key] = (dictionary[key] ?? 0) + 1
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