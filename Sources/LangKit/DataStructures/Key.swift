//
//  Key.swift
//  LangKit
//
//  Created by Richard Wei on 4/13/16.
//
//

public func ==<Element>(lhs: ArrayKey<Element>, rhs: ArrayKey<Element>) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

public struct ArrayKey<Element> : Hashable, ArrayLiteralConvertible {

    private let elements: [Element]

    public init(arrayLiteral elements: Element...) {
        self.elements = elements
    }

    public var hashValue: Int {
        return "\(elements)".hashValue
    }

}
