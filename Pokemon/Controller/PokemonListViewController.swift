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
    @IBOutlet weak var showFavImageView: UIImageView!
    let refreshControl = UIRefreshControl()
    
    var offset = 0
    var isPagination = false
    var pokemonList: [PokemonList] = []
    var allPokemonList: [PokemonList] = []
    var isFav = false
    var isShowFav = false
    
    let service = ServiceApi()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setComponent()
        callService()
        service.requestPokemonList(isAllPokemon: true) { pokemonModel in
            self.allPokemonList = pokemonModel.results
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(favTapped), name: NSNotification.Name("favTapped"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setComponent() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(showFavTapped))
        showFavImageView.addGestureRecognizer(tap)
        
        searchBar.delegate = self
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        setupUI()
        setTableView()
    }
    
    private func callService() {
        service.requestPokemonList { pokemonModel in
            self.pokemonList = pokemonModel.results
            self.tableView.reloadData()
        }
        self.refreshControl.endRefreshing()
    }
    
    private func setupUI() {
        self.view.backgroundColor = UIColor.systemGray6
        logoImage.image = UIImage.init(named: "logo")
        
        showFavImageView.image = UIImage(named: "starfav")?.withTintColor(UIColor.red.withAlphaComponent(0.6))
        
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.textColor = UIColor.black.withAlphaComponent(0.6)
    }
    
    @objc private func refresh() {
        self.isShowFav = false
        self.isPagination = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        callService()
    }
    
    @objc private func favTapped() {
        if let _ = UserDefaults.standard.array(forKey: "pokemonName") {
            tableView.reloadData()
        } else {
            refresh()
        }
    }
    
    @objc private func showFavTapped() {
        if let _ = UserDefaults.standard.array(forKey: "pokemonName") ,!self.isShowFav {
            self.pokemonList = []
            self.isShowFav = !self.isShowFav
            tableView.reloadData()
        } else {
            refresh()
        }
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
        if let favPokemon = UserDefaults.standard.array(forKey: "pokemonName") {
            return !isShowFav ? self.pokemonList.count : favPokemon.count
        } else {
            return self.pokemonList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !isShowFav {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonNameCell", for: indexPath) as! PokemonNameCell
            if let favPokemonName = UserDefaults.standard.array(forKey: "pokemonName") {
                self.isFav = favPokemonName.contains(where: { $0 as! String == self.pokemonList[indexPath.row].name }) ? true : false
            }
            cell.configure(pokemonName: self.pokemonList[indexPath.row].name, isFav: self.isFav)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonNameCell", for: indexPath) as! PokemonNameCell
            if let favPokemonName = UserDefaults.standard.array(forKey: "pokemonName") {
                self.pokemonList.append(PokemonList(name: favPokemonName[indexPath.row] as! String))
                cell.configure(pokemonName: favPokemonName[indexPath.row] as! String, isFav: true)
            }
            return cell
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height) && !isPagination {
            self.offset += 20
            self.isPagination = true
            self.service.requestPokemonList(offset: offset) { pokemonModel in
                self.pokemonList.append(contentsOf: pokemonModel.results)
                self.isPagination = false
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        service.requestPokemonInfo(pokemonName: self.pokemonList[indexPath.row].name) { pokemonModel in
            let vc = PokemonInfoViewController()
            vc.pokemonInfo = pokemonModel
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}

extension PokemonListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.isShowFav = false
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

