//
//  CharacterListView.swift
//  PresentationLayer
//
//  Created by Alfian on 26/11/24.
//

import DomainLayer
import SwiftUI

public struct CharacterListView: View {
  @StateObject var viewModel: CharacterListViewModel

  public init(viewModel: CharacterListViewModel) {
    _viewModel = .init(wrappedValue: viewModel)
  }

  public var body: some View {
    ScrollView {
      LazyVGrid(columns: [.init(.flexible()), .init(.flexible()), .init(.flexible())]) {
        ForEach(viewModel.characters, id: \.id) { character in
          CharacterView(viewModel: character)
            .onAppear {
              if viewModel.hasReachEnd(of: character) {
                viewModel.fetchCharacters()
              }
            }
        }
      }
      .padding()
    }
    .onAppear {
      viewModel.fetchCharacters()
    }
  }
}

#Preview {
  CharacterListView(viewModel: CharacterListViewModel(characterListUseCase: CharacterListUsecaseMock()))
}
