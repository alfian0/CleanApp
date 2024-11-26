//
//  InfoResponse.swift
//  DataLayer
//
//  Created by Alfian on 26/11/24.
//

struct InfoResponse: Decodable {
    let count: Int
    let pages: Int
    let next: String?
    let pre: String?
}
