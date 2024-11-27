//
//  LocationView.swift
//  PresentationLayer
//
//  Created by Alfian on 27/11/24.
//

import SwiftUI
import InfrastructureLayer

struct LocationView: View {
    @StateObject private var viewModel = LocationManagerImpl()

    var body: some View {
        VStack {
            Text("Authorization Status: \(viewModel.authorizationStatus.rawValue)")
            Text("Location: \(viewModel.location?.description ?? "Unknown")")
            
            if let error = viewModel.error {
                Text("Error: \(error.localizedDescription)").foregroundColor(.red)
            }

            Button("Request Location Authorization") {
                viewModel.requestAuthorization()
            }

            Button("Start Updating Location") {
                viewModel.startUpdatingLocation()
            }
            
            Button("Stop Updating Location") {
                viewModel.stopUpdatingLocation()
            }
        }
        .onAppear {
            viewModel.startUpdatingLocation()
        }
        .onDisappear {
            viewModel.stopUpdatingLocation()
        }
    }
}

#Preview {
    LocationView()
}
