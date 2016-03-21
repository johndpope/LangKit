/**
 * Ngram.swift
 *
 */

class NgramModel<T> {

    var n: Int

    init(n: Int) {
        self.n = n
    }

}

extension NgramModel : Model {

    func train() {
        
    }

    func probability<T>(item: T) -> Float {
        return 0.0
    }

}
