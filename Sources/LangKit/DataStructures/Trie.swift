//
//  RedBlackTree.swift
//  LangKit
//
//  Created by Richard Wei on 4/3/16.
//
//

/**
 Trie data structure
 
 - Leaf: (key, count)
 - Node: (key, count, children)
 */
public enum Trie<K: Hashable> {
    
    case Leaf(K, Int)
    
    indirect case Node(K, Int, [K: Trie<K>])
    
}


/**
 Combine two tries
 
 - parameter lhs: Left trie
 - parameter rhs: Rigth trie
 
 - returns: New trie
 */
public func +<K>(lhs: Trie<K>, rhs: Trie<K>) -> Trie<K> {
    return lhs.unionLeft(rhs)
}

// MARK: - Insertion
public extension Trie {
    
    /**
     Return a new trie with an item sequence inserted
     
     - parameter item: item sequence
     
     - returns: New trie after insertion
     */
    public func insert(item: [K]) -> Trie<K> {
        switch self {
            
        // Base cases
        case .Leaf(let k, let v) where item.isEmpty:
            return .Leaf(k, v + 1)
            
        case .Node(let k, let v, let children) where item.isEmpty:
            return .Node(k, v + 1, children)
            
        // Leaf
        case .Leaf(let k, let v):
            let nk = item.first!
            let child = Trie.Leaf(nk, 1).insert(item.dropFirst().map{$0})
            return .Node(k, v, [nk : child])
            
        // Node
        case .Node(let k, let v, var children):
            let nk = item.first!
            let restItem = item.dropFirst().map{$0}
            // Child exists
            if let child = children[nk] {
                children[nk] = child.insert(restItem)
            }
            // Child does not exist. Call insert on a new leaf
            else {
                children[nk] = Trie.Leaf(nk, 1).insert(restItem)
            }
            return .Node(k, v, children)
        }
        
    }
    
}

// MARK: - Updating
public extension Trie {
    
}

// MARK: - Combination
public extension Trie {
    
    /**
     Returns a union of two tries
     
     - parameter other:            Other trie
     - parameter conflictResolver: Conflict resolving function
     
     - returns: New trie after union
     */
    public func union(other: Trie<K>, @noescape conflictResolver: (K, K) -> K?) -> Trie<K> {
        return self
    }
    
    /**
     Returns a union of two tries
     If there's a conflict, take the original (left)
     
     - parameter other: Other trie
     
     - returns: New trie after union
     */
    public func unionLeft(other: Trie<K>) -> Trie<K> {
        return union(other) {left, _ in left}
    }
    
    /**
     Returns a union of two tries
     If there's a conflict, take the new (right)
     
     - parameter other: Other trie
     
     - returns: New trie after union
     */
    public func unionRight(other: Trie<K>) -> Trie<K> {
        return union(other) {_, right in right}
    }
    
}

// MARK: - Predication
public extension Trie {
    
    /**
     Determine if the key exists in children
     
     - parameter key: Key
     
     - returns: Exists or not
     */
    public func hasChild(key: K) -> Bool {
        if case .Node(_, _, let children) = self {
            return children.keys.contains(key)
        }
        return false
    }
    
}

// MARK: - Calculation
public extension Trie {
    
    /**
     Count item sequence
     
     - parameter item: Item sequence
     
     - returns: Count of sequence
     */
    public func count(item: [K]) -> Int {
        if item.isEmpty {
            return 0
        }
        switch self {
        // Base case
        case .Leaf(_, let v):
            return item.count == 1 ? v : 0
        // Node
        case .Node(_, let v, let children):
            if item.count == 1 {
                return v
            }
            let nk = item.first!
            guard let child = children[nk] else {
                return 0
            }
            return child.count(item.dropFirst().map{$0})
        }
    }
    
    /* Potentially meaningless
    /**
     * Sum all values of self and children
     */
    public var sum: Int {
        switch self {
        case .Leaf(_, let v):
            return v
        case .Node(_, _, let children):
            let sums = children.values.map{$0.sum}
            return sums.reduce(sums.first!, combine: +)
        }
    }
    */
    
}
