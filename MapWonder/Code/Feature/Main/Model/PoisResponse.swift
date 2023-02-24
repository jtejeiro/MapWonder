//
//  PoisResponse.swift
//  MapWonder
//
//  Created by Jaime Tejeiro on 22/2/23.
//

import Foundation

// MARK: - PoisResponse
struct PoisResponse: Codable {
    let list: [PoisList]
}

// MARK: - List
struct PoisList: Codable {
    let id, title, geocoordinates: String
    let image: String
}

