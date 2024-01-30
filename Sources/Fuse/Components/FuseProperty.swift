//
//  FuseProperty.swift
//
//
//  Created by Kristóf Kálai on 30/01/2024.
//

public struct FuseProperty {
    let name: String
    let weight: Double

    public init(name: String, weight: Double = 1) {
        self.name = name
        self.weight = weight
    }
}
