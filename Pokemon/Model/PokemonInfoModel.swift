//
//  PokemonAbilityModel.swift
//  Pokemon
//
//  Created by Jiradet Amornpimonkul on 3/10/22.
//

import Foundation
import ObjectMapper

class PokemonInfoModel: Mappable, Codable {
    
    var abilities: [Abilities] = []
    var other: [Other] = [] // Pokemon Picture
    
    required init?(map: Map) { }
        
    func mapping(map: Map) {
        self.abilities <- map["abilities"]
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

class Abilities: Mappable, Codable {
    
    var ability: Ability?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        self.ability <- map["ability"]
    }
    
}

class Ability : Mappable, Codable {
    
    var name: String = ""
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        self.name <- map["name"]
    }
    
}
