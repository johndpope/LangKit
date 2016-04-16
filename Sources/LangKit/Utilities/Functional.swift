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

public func uncurry<A, B, C>(f: (A, B) -> C) -> A -> B -> C {
    return { x in { y in f(x, y) } }
}

public func uncurry<A, B, C, D>(f: (A, B, C) -> D) -> A -> B -> C -> D {
    return { x in { y in { z in f(x, y, z) } } }
}

infix operator >>> { associativity left }
infix operator • { associativity right }
infix operator >>- { associativity left }
infix operator <*> { associativity left }
infix operator <^> { associativity left }
prefix operator !! {}
prefix operator § {}
infix operator <++ {}

/* Flat apply */

public func >>><T, U>(lhs: T, rhs: T -> U) -> U {
    return rhs(lhs)
}

/* Compose */
// f(g(x))
public func •<A, B, C>(f: B -> C, g: A -> B) -> A -> C {
    return { f(g($0)) }
}
// f(g(x), g(y))
public func •<A, B, C>(f: (B, B) -> C, g: A -> B) -> (A, A) -> C {
    return { f(g($0), g($1)) }
}

/* Monad - Bind */
// Optional
public func >>-<A, B>(lhs: A?, rhs: A -> B?) -> B? {
    return lhs.flatMap(rhs)
}
// Sequence
public func >>-<A, B, MA: Sequence where MA.Iterator.Element == A>(lhs: MA, rhs: A -> [B]) -> [B] {
    return lhs.flatMap(rhs)
}

/* Functor - Map */
// Optional
public func <^><A, B>(lhs: A -> B, rhs: A?) -> B? {
    return rhs.map(lhs)
}
// Sequence
public func <^><A, B, S: Sequence where S.Iterator.Element == A>(lhs: A -> B, rhs: S) -> [B] {
    return rhs.map(lhs)
}


/* Applicative - Apply */
// Optional
public func <*><A, B>(lhs: (A -> B)?, rhs: A?) -> B? {
    return lhs.flatMap{f in rhs.map(f)}
}
// Array
public func <*><A, B, FAB: Sequence, FA: Sequence where FAB.Iterator.Element == (A -> B), FA.Iterator.Element == A>(lhs: FAB, rhs: FA) -> [B] {
    return lhs.flatMap{f in rhs.map(f)}
}

/* Invoke instance method */
public prefix func §<T, U>(f: T -> () -> U) -> T -> U {
    return {f($0)()}
}

/* Generate sequence */
public prefix func !!<T, U: Sequence where U.Iterator.Element == T>(sequence: U) -> [T] {
    return sequence.map{$0}
}

/* Increment dictionary key */
public func <++<K, V: Integer>(dictionary: inout [K: V], key: K) {
    dictionary[key] = (dictionary[key] ?? 0) + 1
}
