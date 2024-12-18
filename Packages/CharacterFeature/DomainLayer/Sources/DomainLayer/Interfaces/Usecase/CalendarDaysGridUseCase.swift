//
//  CalendarDaysGridUseCase.swift
//  DomainLayer
//
//  Created by Alfian on 03/12/24.
//

public protocol CalendarDaysGridUseCase {
  func execute(timeInterval: Double) -> [String]
}
