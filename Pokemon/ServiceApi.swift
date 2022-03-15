//
//  ServiceApi.swift
//  Pokemon
//
//  Created by Jiradet Amornpimonkul on 3/14/22.
//

import Foundation
import Alamofire

class ServiceApi {
    
    func requestPokemonList(isAllPokemon: Bool = false, offset: Int = 0, completion: @escaping (_ pokemonModel: PokemonModel) -> Void) {
        let url = !isAllPokemon ? "https://pokeapi.co/api/v2/pokemon?offset=\(offset)&limit=20" : "https://pokeapi.co/api/v2/pokemon?offset=0&limit=1500"
        guard let urlString = URL(string: url) else { return }
        AF.request(urlString).responseDecodable(of: PokemonModel.self) { response in
            switch response.result {
            case .success(let value):
                completion(value)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
//        AF.request(urlString).responseJSON { response in
//            switch response.result {
//            case .success(let value):
//                guard let castingValue = value as? [String: Any] else { return }
//                guard let pokemonModel = Mapper<PokemonModel>().map(JSON: castingValue) else { return }
//                completionHandler(pokemonModel)
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
    }
    
    func requestPokemonInfo(pokemonName: String, completion: @escaping (_ pokemonModel: PokemonInfoModel) -> Void) {
        let url = "https://pokeapi.co/api/v2/pokemon/\(pokemonName)"
        guard let urlString = URL(string: url) else { return }
        AF.request(urlString).responseDecodable(of: PokemonInfoModel.self) { response in
            switch response.result {
            case .success(let value):
                completion(value)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
