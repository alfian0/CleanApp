//
//  CharacterResponse.swift
//  DataLayer
//
//  Created by Alfian on 26/11/24.
//

struct CharacterResponse: Decodable {
  let id: Int
  let name: String
  let status: String
  let species: String
  let gender: String
  let image: String
}
