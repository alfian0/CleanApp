//
//  CharacterViewModel.swift
//  PresentationLayer
//
//  Created by Alfian on 26/11/24.
//

import SwiftUI

@MainActor
final class CharacterViewModel: ObservableObject {
    @Published private(set) var id: Int
    @Published private(set) var name: String
    @Published private(set) var species: String
    @Published private(set) var uiImage: UIImage?
    
    public init(id: Int, name: String, species: String, image: String) {
        self.id = id
        self.name = name
        self.species = species
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: URL(string: image)!)
                uiImage = UIImage(data: data)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
