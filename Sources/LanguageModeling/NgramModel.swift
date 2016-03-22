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

extension NgramModel : LanguageModel {

    func train() {
        // TODO
    }

    func probability<T>(item: T) -> Float {
        return 0.0
    }

}
