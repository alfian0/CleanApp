//
//  CharacterView.swift
//  PresentationLayer
//
//  Created by Alfian on 26/11/24.
//

import SwiftUI

struct CharacterView: View {
  @ObservedObject var viewModel: CharacterViewModel

  var body: some View {
    LazyVStack {
      if let image = viewModel.uiImage {
        Image(uiImage: image)
          .resizable()
          .frame(height: 120)
          .background(Color.gray.opacity(0.2))
          .clipShape(RoundedRectangle(cornerRadius: 8))
      }
      Text(viewModel.name)
        .font(.headline)
        .lineLimit(1)
      Text(viewModel.species)
        .font(.subheadline)
        .lineLimit(1)
    }
  }
}

#Preview {
  CharacterView(viewModel: CharacterViewModel(
    id: 1,
    name: "Rick Sanchez",
    species: "Human",
    image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg"
  ))
}
