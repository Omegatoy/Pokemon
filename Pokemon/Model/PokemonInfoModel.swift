//
//  PokemonAbilityModel.swift
//  Pokemon
//
//  Created by Jiradet Amornpimonkul on 3/10/22.
//

import Foundation
import ObjectMapper

class PokemonInfoModel: Mappable, Codable {
    
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
    
    required init?(map: Map) { }
        
    func mapping(map: Map) {
        self.sprites <- map["sprites"]
        self.name <- map["name"]
        self.height <- map["height"]
        self.weight <- map["weight"]
        self.types <- map["types"]
    }
    
}

class PokemonTypes: Mappable, Codable {
    
    var type: PokemonType?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
//        self.slot <- map["type"]
//        self.pokemonType <- map["slot"]
    }
    
}

class PokemonType: Mappable, Codable {
    
    var name: String = ""
    
    required init?(map: Map) { }
    
    func mapping(map: Map) { }
    
}

class Sprites: Mappable, Codable {
    
    var other: Other? // Pokemon Picture
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        self.other <- map["other"]
    }
    
}

class Other: Mappable, Codable {
    
    var home: Home? // Pokemon Picture
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        self.home <- map["home"]
    }
    
}

class Home: Mappable, Codable {
    
    var front_default: String = "" // Pokemon Picture
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        self.front_default <- map["front_default"]
    }

}
