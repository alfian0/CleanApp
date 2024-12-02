//
//  CoordinateModel.swift
//  DomainLayer
//
//  Created by Alfian on 30/11/24.
//

public struct CoordinateModel: Sendable {
  public let latitude: Double
  public let longitude: Double

  public init(latitude: Double, longitude: Double) {
    self.latitude = latitude
    self.longitude = longitude
  }
}
