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
public func argext<T, K: Comparable>(args: [T], @noescape compare: (K, K) -> Bool, @noescape keyFunc: T -> K) -> T? {
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
public func argext<T, K: Comparable>(compare compare: (K, K) -> Bool) -> ([T], T -> K) -> T? {
    return { args, keyFunc in argext(args, compare: compare, keyFunc: keyFunc) }
}

/**
 Argument maximum

 - parameter keyFunc: Key function
 - parameter args:    Arguments

 - returns: Argument maximum
 */
public func argmax<T, K : Comparable>(args: [T], keyFunc: T -> K) -> T? {
    return argext(args, compare: >, keyFunc: keyFunc)
}

/**
 Argument minimum

 - parameter keyFunc: Key function
 - parameter args:    Arguments

 - returns: Argument minimum
 */
public func argmin<T, K : Comparable>(args: [T], keyFunc: T -> K) -> T? {
    return argext(args, compare: <, keyFunc: keyFunc)
}

/**
 *  Classifier protocol which each classifier conforms to
 */
public protocol Classifier {

    associatedtype Input
    associatedtype Label

    func classify(input: Input) -> Label?

}
