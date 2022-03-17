//
//  ServiceApi.swift
//  Pokemon
//
//  Created by Jiradet Amornpimonkul on 3/14/22.
//

import Foundation
import Alamofire
import Combine

class ServiceApi {
    
    func requestPokemonListCombine(isAllPokemon: Bool = false, offset: Int = 0) -> AnyPublisher<PokemonModel, Never> {
        guard let url = URL(string: !isAllPokemon ? "https://pokeapi.co/api/v2/pokemon?offset=\(offset)&limit=20" : "https://pokeapi.co/api/v2/pokemon?offset=0&limit=1500") else {
            return Just(PokemonModel()).eraseToAnyPublisher()
        }
        
        let publisher = URLSession.shared.dataTaskPublisher(for: url)
            .map({ $0.data })
            .decode(type: PokemonModel.self, decoder: JSONDecoder())
            .catch({ _ in
                Just(PokemonModel(results: []))
            })
            .eraseToAnyPublisher()
                    
        return publisher
    }
    
    func requestPokemonInfoCombine(pokemonName: String) -> AnyPublisher<PokemonInfoModel, Never> {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(pokemonName)") else {
            return Just(PokemonInfoModel()).eraseToAnyPublisher()
        }
        
        let publisher = URLSession.shared.dataTaskPublisher(for: url)
            .map({ $0.data })
            .decode(type: PokemonInfoModel.self, decoder: JSONDecoder())
            .catch({ _ in
                Just(PokemonInfoModel())
            })
            .eraseToAnyPublisher()
                    
        return publisher
    }
    
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
