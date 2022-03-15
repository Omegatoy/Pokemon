//
//  PokemonNameCell.swift
//  Pokemon
//
//  Created by Jiradet Amornpimonkul on 3/9/22.
//

import UIKit

class PokemonNameCell: UITableViewCell {

    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var favImageView: UIImageView!
    
    var pokemonName: String = ""
    var isFav: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(favTapped))
        favImageView.addGestureRecognizer(tap)
        
        self.setupUI()
        self.layoutIfNeeded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupUI() {
        self.backgroundColor = .clear
    }
    
    func configure(pokemonName: String, isFav: Bool) {
        self.pokemonName = pokemonName
        self.isFav = isFav
        pokemonNameLabel.text = pokemonName.firstUppercased
        pokemonNameLabel.font = UIFont(name: "Helvetica Neue", size: 24)
        pokemonNameLabel.textColor = UIColor.black.withAlphaComponent(0.6)
        
        favImageView.image = !isFav ? UIImage(named: "star")?.withTintColor(UIColor.black.withAlphaComponent(0.6)) : UIImage(named: "starfav")?.withTintColor(UIColor.red.withAlphaComponent(0.6))
    }
    
    @objc private func favTapped() {
        var pokemonNameList: [Any] = []
        if let favPokemonName = UserDefaults.standard.array(forKey: "pokemonName") {
            pokemonNameList = favPokemonName
            if !favPokemonName.contains(where: { $0 as! String == self.pokemonName }) && !self.isFav {
                pokemonNameList.append(self.pokemonName)
                UserDefaults.standard.set(pokemonNameList, forKey: "pokemonName")
            } else {
                pokemonNameList = pokemonNameList.filter({ $0 as! String != self.pokemonName })
                UserDefaults.standard.set(pokemonNameList, forKey: "pokemonName")
                if pokemonNameList.count == 0 {
                    UserDefaults.standard.removeObject(forKey: "pokemonName")
                }
                favImageView.image = UIImage(named: "starfav")?.withTintColor(UIColor.red.withAlphaComponent(0.6))
            }
        } else {
            UserDefaults.standard.set([self.pokemonName], forKey: "pokemonName")
        }
        
        NotificationCenter.default.post(name: NSNotification.Name("favTapped"), object: nil)
    }
    
}
