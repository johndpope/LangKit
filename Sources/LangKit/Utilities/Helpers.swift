//
//  Helpers.swift
//  LangKit
//
//  Created by Richard Wei on 4/16/16.
//
//

prefix operator !!  {}
prefix operator §   {}
infix  operator <++ {}

/**
 Instance method invoker

 - parameter f: Uninstantiated instance method (A -> () -> B)

 - returns: Uninstantiated method with auto invocation (A -> B)
 */
public prefix func §<A, B>(f: A -> () -> B) -> A -> B {
    return {f($0)()}
}

/**
 Generate an array from a sequence

 - parameter sequence: Sequence

 - returns: Array
 */
public prefix func !!<A, B: Sequence where B.Iterator.Element == A>(sequence: B) -> [A] {
    return sequence.map{$0}
}

/* Increment dictionary key */
/**
 Increment ductionary key by 1

 - parameter dictionary: Dictionary<_, Int>
 - parameter key:        Key

 - returns: New value
 */
public func <++<K, V: Integer>(dictionary: inout [K: V], key: K) -> V {
    let value = (dictionary[key] ?? 0) + 1
    dictionary[key] = value
    return value
}