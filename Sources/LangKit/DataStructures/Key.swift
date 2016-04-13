//
//  Key.swift
//  LangKit
//
//  Created by Richard Wei on 4/13/16.
//
//

internal func ==<Element>(lhs: ArrayKey<Element>, rhs: ArrayKey<Element>) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

internal struct ArrayKey<Element> : Hashable, ArrayLiteralConvertible {

    let elements: [Element]

    init(arrayLiteral elements: Element...) {
        self.elements = elements
    }

    var hashValue: Int {
        return "\(elements)".hashValue
    }

}