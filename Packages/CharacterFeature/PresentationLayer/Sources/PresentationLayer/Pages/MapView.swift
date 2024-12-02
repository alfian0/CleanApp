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
  @StateObject var viewModel: MapViewModel =
    .init(usecase: GetCurrentRegionUsecaseImpl(locationManager: LocationManagerImpl()))

  public init() {}

  public var body: some View {
    Map(coordinateRegion: $viewModel.region)
      .ignoresSafeArea()
      .onAppear {
        viewModel.fetchAddress()
      }
  }
}

#Preview {
  MapView()
}

@MainActor
public class MapViewModel: ObservableObject {
  @Published var region: MKCoordinateRegion = .init(
    center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
  )
  private let usecase: GetCurrentRegionUsecase

  public init(usecase: GetCurrentRegionUsecase) {
    self.usecase = usecase
  }

  func fetchAddress() {
    let usecase = usecase
    Task {
      do {
        let region = try await usecase.execute()
        self.region.center.latitude = region.latitude
        self.region.center.longitude = region.longitude
      } catch {
        print(error)
      }
    }
  }
}
