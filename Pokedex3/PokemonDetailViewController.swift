//
//  PokemonDetailViewController.swift
//  Pokedex3
//
//  Created by Alfonso, Hector I. on 12/9/16.
//  Copyright © 2016 Alfonso, Hector I. All rights reserved.
//

import UIKit
import Alamofire

class PokemonDetailViewController: UIViewController {

    var pokemon: Pokemon!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var evoLabel: UILabel!
    @IBOutlet weak var nextEvoImage: UIImageView!
    @IBOutlet weak var currentEvoImage: UIImageView!
    @IBOutlet weak var baseAttackLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var pokedexIdLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var pokemonDetailsSegment: UISegmentedControl!
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseAttackLabel.text = ""
        defenseLabel.text = ""
        heightLabel.text = ""
        weightLabel.text = ""
        descriptionLabel.text = ""
        typeLabel.text = ""
        nameLabel.text = ""
        pokedexIdLabel.text = ""
        
        let img = UIImage(named: "\(pokemon.pokedexId)")
        mainImage.image = img
        currentEvoImage.image = img
        pokedexIdLabel.text = "\(pokemon.pokedexId)"
        pokemonDetailsSegment.isUserInteractionEnabled = false
        
        pokemon.downloadPokemonDetails() {
            self.updateUI()
            self.pokemonDetailsSegment.isUserInteractionEnabled = true
            self.spinner.stopAnimating()
            self.spinner.isHidden = true
            self.pokemonDetailsSegment.alpha = 1.0
        }
        
    }
    
    func updateUI() {
        baseAttackLabel.text = pokemon.attack
        defenseLabel.text = pokemon.defense
        heightLabel.text = pokemon.height
        weightLabel.text = pokemon.weight
        typeLabel.text = pokemon.type
        descriptionLabel.text = pokemon.description
        nameLabel.text = pokemon.name.capitalized
        
        if pokemon.nextEvolutionId == "" {
            evoLabel.text = "No Evolutions"
            //nextEvoImage.isHidden = true
        }
        else {
           // nextEvoImage.isHidden = false
            nextEvoImage.image = UIImage(named: pokemon.nextEvolutionId)
            let st = "Next Evolution: \(pokemon.nextEvolutionName) - LVL \(pokemon.nextEvolutionLevel)"
            evoLabel.text = st
        }
       
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        pokemonDetailsSegment.selectedSegmentIndex = 0
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        print ("segment changed")
        if sender.selectedSegmentIndex == 1 {
            
            performSegue(withIdentifier: "showMoves", sender: pokemon)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showMoves" {
                
            if let destinationViewController = segue.destination as? MovesViewController {
                    
                destinationViewController.pokemon = sender as? Pokemon
                    
            }
            
        }
    }
    

}
