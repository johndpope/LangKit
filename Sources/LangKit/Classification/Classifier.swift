//
//  Classifier.swift
//  LangKit
//
//  Created by Richard Wei on 3/22/16.
//
//

/**
 Argument extremum by comparison on keys

 - parameter compare: Comparison function
 - parameter keyFunc: Key function
 - parameter args:    Arguments

 - returns: Extremum
 */
public func argext<T, K: Comparable>(@noescape compare compare: (K, K) -> Bool, @noescape keyFunc: T -> K, args: [T]) -> T? {
    guard let first = args.first else {
        return nil
    }
    return args.reduce(first, combine: { compare(keyFunc($0), keyFunc($1)) ? $0 : $1 } )
}

/**
 Argument extremum function provider

 - parameter compFunc: Comparison function

 - returns: Argument extremum function that uses comparison function
 */
public func argext<T, K: Comparable>(compare compare: (K, K) -> Bool) -> (T -> K, [T]) -> T? {
    return { keyFunc, args in argext(compare: compare, keyFunc: keyFunc, args: args) }
}

/**
 Argument maximum

 - parameter keyFunc: Key function
 - parameter args:    Arguments

 - returns: Argument maximum
 */
public func argmax<T, K : Comparable>(keyFunc: T -> K, args: [T]) -> T? {
    return argext(compare: >)(keyFunc, args)
}

/**
 Argument minimum

 - parameter keyFunc: Key function
 - parameter args:    Arguments

 - returns: Argument minimum
 */
public func argmin<T, K : Comparable>(keyFunc: T -> K, args: [T]) -> T? {
    return argext(compare: <)(keyFunc, args)
}

/**
 *  Classifier protocol which each classifier conforms to
 */
public protocol Classifier {

    associatedtype Input
    associatedtype Label

    func classify(input: Input) -> Label?

}
