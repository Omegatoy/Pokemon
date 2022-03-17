//
//  PokemonAbilityModel.swift
//  Pokemon
//
//  Created by Jiradet Amornpimonkul on 3/10/22.
//

import Foundation
import ObjectMapper

struct PokemonInfoModel: Codable {
    
    var sprites: Sprites?
    var name: String = ""
    private var height: Int = 0
    private var weight: Int = 0
    var types: [PokemonTypes] = []
    
    var cmHeight: Int {
        return height * 10
    }
    
    var kgWeight: Int {
        return weight / 10
    }
    
//    init(sprites: Sprites, name: String, hegiht: Int, weight: Int, types: [PokemonTypes]) {
//        self.sprites = sprites
//        self.name = name
//        self.height = hegiht
//        self.weight = weight
//        self.types = types
//    }
    
}

struct PokemonTypes: Codable {
    
    var type: PokemonType?
    
}

struct PokemonType: Codable {
    
    var name: String = ""
    
}

struct Sprites: Codable {
    
    var other: Other? // Pokemon Picture
    
}

struct Other: Codable {
    
    var home: Home? // Pokemon Picture
    
}

struct Home: Codable {
    
    var front_default: String = "" // Pokemon Picture

}
