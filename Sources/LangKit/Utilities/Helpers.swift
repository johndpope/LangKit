//
//  Helpers.swift
//  LangKit
//
//  Created by Richard Wei on 4/16/16.
//
//

prefix operator !!  {                     }
prefix operator §   {                     }
infix  operator <++ {                     }

/* Invoke instance method */
public prefix func §<A, B>(f: A -> () -> B) -> A -> B {
    return {f($0)()}
}

/* Generate sequence */
public prefix func !!<A, B: Sequence where B.Iterator.Element == A>(sequence: B) -> [A] {
    return sequence.map{$0}
}

/* Increment dictionary key */
public func <++<K, V: Integer>(dictionary: inout [K: V], key: K) -> V {
    let value = (dictionary[key] ?? 0) + 1
    dictionary[key] = value
    return value
}