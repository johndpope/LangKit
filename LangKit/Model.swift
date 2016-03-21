/**
 * Model.swift
 *
 */

protocol Model {

    func train()

    func probability<T: Probable>(item: T) -> Float

}
