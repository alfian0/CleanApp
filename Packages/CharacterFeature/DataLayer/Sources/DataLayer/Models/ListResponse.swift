//
//  ListResponse.swift
//  DataLayer
//
//  Created by Alfian on 26/11/24.
//

struct ListResponse: Decodable {
  let info: InfoResponse
  let results: [CharacterResponse]
}
