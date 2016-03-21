/**
 * Model.swift
 *
 */

protocol Model {

    func train()

    func probability<T>(item: T) -> Float

}
