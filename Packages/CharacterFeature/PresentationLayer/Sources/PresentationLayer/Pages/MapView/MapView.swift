//
//  MapView.swift
//  PresentationLayer
//
//  Created by Alfian on 29/11/24.
//

import DomainLayer
import InfrastructureLayer
import MapKit
import SwiftUI

public struct MapView: View {
  @StateObject var viewModel: MapViewModel

  public init(viewModel: MapViewModel) {
    _viewModel = .init(wrappedValue: viewModel)
  }

  public var body: some View {
    Map(coordinateRegion: $viewModel.region)
      .ignoresSafeArea()
      .onAppear {
        viewModel.fetchAddress()
      }
  }
}

#Preview {
  MapView(viewModel: MapViewModel(usecase: GetCurrentRegionUsecaseImpl(locationManager: LocationManagerImpl())))
}
