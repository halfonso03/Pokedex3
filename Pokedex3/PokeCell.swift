//
//  PokeCell.swift
//  Pokedex3
//
//  Created by Alfonso, Hector I. on 12/8/16.
//  Copyright © 2016 Alfonso, Hector I. All rights reserved.
//

import UIKit
import Foundation

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLabel : UILabel!
    
    var pokemon: Pokemon!
    
    
    func configureCell(_ pokemon: Pokemon) {
        
        self.pokemon = pokemon
        nameLabel.text = self.pokemon.name.capitalized
        thumbImg.image = UIImage(named: "\(self.pokemon.pokedexId).png")
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
    }
    
}
