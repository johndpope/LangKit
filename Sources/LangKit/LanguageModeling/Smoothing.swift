//
//  Smoothing.swift
//  LangKit
//
//  Created by Richard Wei on 4/17/16.
//
//

import Foundation

public enum SmoothingMode : NilLiteralConvertible {
    case none
    case laplace(Float)
    case goodTuring
    case linearInterpolation
    case absoluteDiscounting
    
    public init(nilLiteral: ()) {
        self = .none
    }
}