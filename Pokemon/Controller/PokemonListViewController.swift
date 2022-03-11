//
//  ViewController.swift
//  Pokemon
//
//  Created by Jiradet Amornpimonkul on 3/9/22.
//

import UIKit
import Alamofire
import ObjectMapper

class PokemonListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoImage: UIImageView!
    
    let refreshControl = UIRefreshControl()
    var pokemonList: [PokemonList] = []
    var pokemonInfo: PokemonInfoModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setComponent()
        callService()
    }
    
    private func setComponent() {
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        setupUI()
        setTableView()
    }
    
    private func callService() {
        requestPokemonList { pokemonModel in
            self.pokemonList = pokemonModel.results.sorted(by: { $0.name < $1.name })
            self.tableView.reloadData()
        }
        self.refreshControl.endRefreshing()
    }
    
    private func setupUI() {
        logoImage.image = UIImage.init(named: "logo")
    }
    
    @objc private func refresh() {
        callService()
    }
    
    private func requestPokemonList(completionHandler: @escaping (_ pokemonModel: PokemonModel) -> ()) {
        guard let urlString = URL(string: "https://pokeapi.co/api/v2/pokemon") else { return }
        AF.request(urlString).responseDecodable(of: PokemonModel.self) { response in
            switch response.result {
            case .success(let value):
                completionHandler(value)
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
    
    private func requestPokemonInfo(pokemonName: String, completionHandler: @escaping (_ pokemonModel: PokemonInfoModel) -> ()) {
        let url = "https://pokeapi.co/api/v2/pokemon/\(pokemonName)"
        guard let urlString = URL(string: url) else { return }
        AF.request(urlString).responseDecodable(of: PokemonInfoModel.self) { response in
            switch response.result {
            case .success(let value):
                completionHandler(value)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension PokemonListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        
        tableView.register(UINib(nibName: "PokemonNameCell", bundle: nil), forCellReuseIdentifier: "PokemonNameCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pokemonList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonNameCell", for: indexPath) as! PokemonNameCell
        cell.configure(pokemonName: self.pokemonList[indexPath.row].name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        requestPokemonInfo(pokemonName: self.pokemonList[indexPath.row].name) { pokemonModel in
            self.pokemonInfo = pokemonModel
            print(self.pokemonInfo?.sprites?.other?.home?.front_default)
        }
    }
    
}

extension String {
    
    var firstUppercased: String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    var firstCapitalized: String {
        return prefix(1).capitalized + dropFirst()
    }
    
}

