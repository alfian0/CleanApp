//
//  LocationModel.swift
//  DomainLayer
//
//  Created by Alfian on 30/11/24.
//

public struct LocationModel: Sendable {
    public let coordinate: CoordinateModel
    
    public init(coordinate: CoordinateModel) {
        self.coordinate = coordinate
    }
}
