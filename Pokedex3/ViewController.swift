//
//  ViewController.swift
//  Pokedex3
//
//  Created by Alfonso, Hector I. on 12/7/16.
//  Copyright © 2016 Alfonso, Hector I. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collection: UICollectionView!
    
    var pokemon = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var filteredPokemon = [Pokemon]()
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.dataSource = self
        collection.delegate = self
        searchBar.delegate = self
        parsePokemonCSV()
        initAudio()
        searchBar.returnKeyType = .done
    }
    
    func initAudio() {
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")!
        var url = URL(fileURLWithPath: path)
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: url)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
            
        }
        catch let error as NSError {
            print(error.debugDescription)
        }
    }
    
    @IBAction func musicButtonPressed(_ sender: UIButton) {
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            sender.alpha = 0.2
        }
        else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
    
    func parsePokemonCSV() {
        
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do {
            let csv = try CSV.init(contentsOfURL: path)
            let rows = csv.rows
            
            
            for row in rows {
                let pokemon = Pokemon(name: row["identifier"]!, pokedexId: Int(row["id"]!)!)
                
                self.pokemon.append(pokemon)
                
            }
        }
        catch let error as NSError {
            print (error.debugDescription)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pokeCell", for: indexPath) as? PokeCell {
            
            var pokemon = Pokemon()
            
            if inSearchMode {
                pokemon = self.filteredPokemon[indexPath.row]
            }
            else {
                pokemon = self.pokemon[indexPath.row]
            }
            
            cell.configureCell(pokemon)
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        return
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode {
            return filteredPokemon.count
        }
        
        return pokemon.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }
   

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
        }
        else {
            inSearchMode = true
        
            let lower = searchBar.text!.lowercased()
            
            filteredPokemon = pokemon.filter({ $0.name.range(of: lower) != nil })
        }
        
        collection.reloadData()
        
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

