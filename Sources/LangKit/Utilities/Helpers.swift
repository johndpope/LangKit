//
//  Helpers.swift
//  LangKit
//
//  Created by Richard Wei on 4/16/16.
//
//

prefix operator !!  {}
prefix operator §   {}
infix operator ?+= {
    associativity right
    precedence 90
    assignment
}
infix operator !+= {
    associativity right
    precedence 90
    assignment
}

/**
 Instance method invoker

 - parameter f: Uninstantiated instance method (A -> () -> B)

 - returns: Uninstantiated method with auto invocation (A -> B)
 */
@inline(__always)
public prefix func §<A, B>(f: A -> () -> B) -> A -> B {
    return {f($0)()}
}

/**
 Generate an array from a sequence

 - parameter sequence: Sequence

 - returns: Array
 */
@inline(__always)
public prefix func !!<A, B: Sequence where B.Iterator.Element == A>(sequence: B) -> [A] {
    return sequence.map{$0}
}

@inline(__always)
public func ?+=<T: Integer>(lhs: inout T?, rhs: T) -> T {
    lhs = rhs + (lhs ?? 0)
    return lhs!
}

@inline(__always)
public func ?+=(lhs: inout Float?, rhs: Float) -> Float {
    lhs = rhs + (lhs ?? 0.0)
    return lhs!
}

@inline(__always)
public func ?+=(lhs: inout Double?, rhs: Double) -> Double {
    lhs = rhs + (lhs ?? 0.0)
    return lhs!
}

@inline(__always)
public func !+=<T: Integer>(lhs: inout T?, rhs: T) -> T {
    lhs = rhs + lhs!
    return lhs!
}

@inline(__always)
public func !+=(lhs: inout Float?, rhs: Float) -> Float {
    lhs = rhs + lhs!
    return lhs!
}

@inline(__always)
public func !+=(lhs: inout Double?, rhs: Double) -> Double {
    lhs = rhs + lhs!
    return lhs!
}