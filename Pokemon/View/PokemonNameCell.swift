//
//  PokemonNameCell.swift
//  Pokemon
//
//  Created by Jiradet Amornpimonkul on 3/9/22.
//

import UIKit

class PokemonNameCell: UITableViewCell {

    @IBOutlet weak var pokemonNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupUI()
        self.layoutIfNeeded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupUI() {
        self.backgroundColor = .clear
    }
    
    func configure(pokemonName: String) {
        pokemonNameLabel.text = pokemonName.firstUppercased
    }
    
}
