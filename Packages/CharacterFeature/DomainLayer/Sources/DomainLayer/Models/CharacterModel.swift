//
//  CharacterModel.swift
//  DomainLayer
//
//  Created by Alfian on 26/11/24.
//

public struct CharacterModel: Sendable {
    public let id: Int
    public let name: String
    public let status: String
    public let species: String
    public let gender: String
    public let image: String

    public init(id: Int, name: String, status: String, species: String, gender: String, image: String) {
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.gender = gender
        self.image = image
    }
}
