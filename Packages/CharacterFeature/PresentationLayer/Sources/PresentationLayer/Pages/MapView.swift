//
//  MapView.swift
//  PresentationLayer
//
//  Created by Alfian on 29/11/24.
//

import SwiftUI
import MapKit
import DomainLayer
import InfrastructureLayer

public struct MapView: View {
    @StateObject var viewModel: MapViewModel = MapViewModel(usecase: GetCurrentRegionUsecaseImpl(locationManager: LocationManagerImpl()))

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
    @Published var region: MKCoordinateRegion = MKCoordinateRegion(
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
                region = try await usecase.execute()
            } catch {
                print(error)
            }
        }
    }
}
