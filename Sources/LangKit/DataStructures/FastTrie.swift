//
//  FastTrie.swift
//  LangKit
//
//  Created by Richard Wei on 4/23/16.
//
//

public struct FastTrie<K: Hashable> {
    internal var key: K!
    internal var value: Int = 0
    internal var children: [K: FastTrie<K>]?
    internal var isLeaf: Bool = true

    /**
     Initialize leaf
     */
    public init(key: K? = nil, inserting initialItem: [K]? = nil, incrementingNodes incrementing: Bool = false) {
        self.key = key
        if let initialItem = initialItem {
            self.insert(initialItem, incrementingNodes: incrementing)
        }
    }
}

extension FastTrie : Equatable {}

private func ==<T>(lhs: [T: FastTrie<T>]?, rhs: [T: FastTrie<T>]?) -> Bool {
    return lhs == rhs
}

public func ==<T>(lhs: FastTrie<T>, rhs: FastTrie<T>) -> Bool {
    return lhs.key == rhs.key
        && lhs.value == rhs.value
        && lhs.children == rhs.children
        && lhs.isLeaf == rhs.isLeaf
}

public extension FastTrie {

    public mutating func insert(_ item: [K], incrementingNodes incrementing: Bool) {
        // Base case
        if item.isEmpty {
            value += 1
            return
        }

        let nk = item.first!
        let restItem = !!item.dropFirst()
        if incrementing { value += 1 }

        if isLeaf {
            self.isLeaf = false
            self.children = [nk: FastTrie(key: nk, inserting: restItem, incrementingNodes: incrementing)]
            return
        }

        // Node

        // Child exists
        if let _ = children?[nk] {
            children![nk]!.insert(restItem, incrementingNodes: incrementing)
        }

        // Child does not exist. Call insert on a new leaf
        else {
            children![nk] = FastTrie(key: nk, inserting: restItem, incrementingNodes: incrementing)
        }
    }

}

public extension FastTrie {

    public func search(_ item: [K]) -> Int {
        // Base case
        if item.isEmpty {
            return value
        }

        let nk = item.first!
        guard let child = children?[nk] else {
            return 0
        }
        return child.search(!!item.dropFirst())
    }

}
