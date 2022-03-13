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
    @IBOutlet weak var searchBar: UISearchBar!
    let refreshControl = UIRefreshControl()
    
    var offset = 0
    var isPagination = false
    var pokemonList: [PokemonList] = []
    var allPokemonList: [PokemonList] = []
    var isFav = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setComponent()
        callService()
        requestPokemonList(isAllPokemon: true) { pokemonModel in
            self.allPokemonList = pokemonModel.results.filter({ !$0.name.contains("-") })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(favTapped), name: NSNotification.Name("favTapped"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setComponent() {
        searchBar.delegate = self
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        setupUI()
        setTableView()
    }
    
    private func callService() {
        requestPokemonList { pokemonModel in
            self.pokemonList = pokemonModel.results
            self.tableView.reloadData()
        }
        self.refreshControl.endRefreshing()
    }
    
    private func setupUI() {
        self.view.backgroundColor = UIColor.systemGray6
        logoImage.image = UIImage.init(named: "logo")
        
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.textColor = UIColor.black.withAlphaComponent(0.6)
    }
    
    private func requestPokemonList(isAllPokemon: Bool = false, offset: Int = 0, completion: @escaping (_ pokemonModel: PokemonModel) -> Void) {
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
    
    private func requestPokemonInfo(pokemonName: String, completion: @escaping (_ pokemonModel: PokemonInfoModel) -> Void) {
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
    
    @objc private func refresh() {
        self.isPagination = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        callService()
    }
    
    @objc private func favTapped() {
        tableView.reloadData()
    }
}

extension PokemonListViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
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
        if let favPokemonName = UserDefaults.standard.array(forKey: "pokemonName") {
            self.isFav = favPokemonName.contains(where: { $0 as! String == self.pokemonList[indexPath.row].name }) ? true : false
        }
        cell.configure(pokemonName: self.pokemonList[indexPath.row].name, isFav: self.isFav)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height) && !isPagination {
            self.offset += 20
            self.isPagination = true
            self.requestPokemonList(offset: offset) { pokemonModel in
                self.pokemonList.append(contentsOf: pokemonModel.results)
                self.isPagination = false
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        requestPokemonInfo(pokemonName: self.pokemonList[indexPath.row].name) { pokemonModel in
            let vc = PokemonInfoViewController()
            vc.pokemonInfo = pokemonModel
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}

extension PokemonListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            self.pokemonList = self.allPokemonList.filter { pokemonList in
                return pokemonList.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            }
            self.isPagination = true
            self.tableView.reloadData()
        } else {
            refresh()
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

