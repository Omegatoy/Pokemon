//
//  PokemonInfoViewController.swift
//  Pokemon
//
//  Created by Jiradet Amornpimonkul on 3/10/22.
//

import UIKit

class PokemonInfoViewController: UIViewController {
    
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var pokemonInfoView: UIView!
    @IBOutlet weak var pokemonName: UILabel!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var separateLine: UIView!
    @IBOutlet weak var heightNumLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightNumLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var typeNameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    var pokemonInfo: PokemonInfoModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.systemGray6
        logoImageView.image = UIImage(named: "pngwing.com")
        
        pokemonInfoView.layer.borderColor = UIColor.systemGray3.cgColor
        pokemonInfoView.layer.borderWidth = 1.5
        pokemonInfoView.layer.cornerRadius = 7
         
        separateLine.backgroundColor = UIColor.systemGray3
        separateLine.layer.cornerRadius = 3
        
        shadowView.layer.shadowColor = UIColor.systemGray3.cgColor
        shadowView.layer.shadowOpacity = 1
        shadowView.layer.shadowOffset = CGSize.zero
        shadowView.layer.shadowRadius = 7
        shadowView.layer.cornerRadius = 7
        shadowView.backgroundColor = UIColor.systemGray6

        if let imageUrl = pokemonInfo?.sprites?.other?.home?.front_default,
           let url = URL(string: imageUrl),
           let data = try? Data(contentsOf: url) {
            pokemonImageView.image = UIImage(data: data)
        }
        
        setupUI()
        setFontStyle()
    }
    
    private func setupUI() {
        guard let pokemonInfo = self.pokemonInfo else { return }
        pokemonName.text = pokemonInfo.name.firstUppercased
        heightLabel.text = "Height (cm)"
        weightLabel.text = "Weight (kg)"
        typeLabel.text = "Type"
        typeNameLabel.text = ""
        
        heightNumLabel.text = "\(pokemonInfo.cmHeight)"
        weightNumLabel.text = "\(pokemonInfo.kgWeight)"
        
        if pokemonInfo.types.count > 1 {
            pokemonInfo.types.forEach { types in
                guard let typeName = types.type?.name.firstUppercased else { return }
                if typeNameLabel.text == "" {
                    typeNameLabel.text = typeName
                } else {
                    if let firstType = typeNameLabel.text {
                        typeNameLabel.text = firstType + "," + typeName
                    }
                }
            }
        } else {
            guard let typeName = pokemonInfo.types.first?.type?.name.firstUppercased else { return }
            typeNameLabel.text = typeName
        }
        
    }
    
    private func setFontStyle() {
        pokemonName.font = UIFont(name: "Helvetica Neue", size: 28)
        heightLabel.font = UIFont(name: "Helvetica Neue", size: 14)
        weightLabel.font = UIFont(name: "Helvetica Neue", size: 14)
        typeLabel.font = UIFont(name: "Helvetica Neue", size: 14)
        
        heightNumLabel.font = UIFont(name: "Helvetica Neue", size: 24)
        weightNumLabel.font = UIFont(name: "Helvetica Neue", size: 24)
        typeNameLabel.font = UIFont(name: "Helvetica Neue", size: 24)
        
        pokemonName.textColor = UIColor.black.withAlphaComponent(0.6)
        heightLabel.textColor = UIColor.black.withAlphaComponent(0.4)
        weightLabel.textColor = UIColor.black.withAlphaComponent(0.4)
        typeLabel.textColor = UIColor.black.withAlphaComponent(0.4)
        heightNumLabel.textColor = UIColor.black.withAlphaComponent(0.6)
        weightNumLabel.textColor = UIColor.black.withAlphaComponent(0.6)
        typeNameLabel.textColor = UIColor.black.withAlphaComponent(0.6)
    }
}
