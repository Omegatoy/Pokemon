//
//  PokemonModel.swift
//  Pokemon
//
//  Created by Jiradet Amornpimonkul on 3/10/22.
//

import Foundation
import UIKit

struct PokemonModel: Codable {
    
    var results: [PokemonList] = []
    
}

struct PokemonList: Codable {
    
    var name: String = ""
    var url: String = ""
    
    init(name: String) {
        self.name = name
    }
    
}
