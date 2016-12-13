//
//  Pokemon.swift
//  Pokedex3
//
//  Created by Alfonso, Hector I. on 12/7/16.
//  Copyright © 2016 Alfonso, Hector I. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    
    fileprivate var _name: String!
    fileprivate var _pokedexId: Int!
    fileprivate var _description: String!
    fileprivate var _type: String!
    fileprivate var _defense: String!
    fileprivate var _height: String!
    fileprivate var _weight: String!
    fileprivate var _attack: String!
    fileprivate var _nextEvolutionText: String!
    fileprivate var _nextEvolutionName: String!
    fileprivate var _nextEvolutionId: String!
    fileprivate var _nextEvolutionLevel: String!
    fileprivate var _pokemonUrl: String!
    
    
    fileprivate var _moves: [Dictionary<String, Any>]!
    
    var moves: [Dictionary<String, Any>] {
        return self._moves
    }
    
    var description: String {
        return self._description ?? ""
    }
    
    var type: String {
        return self._type ?? ""
    }
    
    var defense: String {
        return self._defense ?? ""
    }
    
    var height: String {
        return self._height ?? ""
    }
    
    var weight: String {
        return self._weight ?? ""
    }
    
    var attack: String {
        return self._attack ?? ""
    }
    
    var nextEvolutionName: String {
        return self._nextEvolutionName ?? ""
    }
    
    var nextEvolutionId: String {
        return self._nextEvolutionId ?? ""
    }
    
    var nextEvolutionLevel: String {
        return self._nextEvolutionLevel ?? ""
    }
   
    
    
    
    var name: String {
        return _name
    }

    var pokedexId: Int {
        return _pokedexId
    }
    
    init() {}
    init(name: String, pokedexId: Int) {
        self._pokedexId = pokedexId
        self._name = name
        self._pokemonUrl = "\(URL_BASE)\(URL_POKEMON)/\(self._pokedexId!)/"
    }
    
    func downloadPokemonDetails(completed: @escaping DownloadComplete) {
        
        Alamofire.request(_pokemonUrl).responseJSON { (response) in
            if let dict = response.result.value as? [String: Any] {
                
                if let moves = dict["moves"] as? [Dictionary<String, Any>] {
                    self._moves = moves
                }
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)"
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"
                }
                
                
                if let types = dict["types"] as? [Dictionary<String, String>], types.count > 0 {
                    if let name = types[0]["name"] {
                        self._type = name.capitalized
                    }
                    
                    if types.count > 1 {
                        for x in 1..<types.count {
                            if let name = types[x]["name"] {
                                self._type! += "/\(name.capitalized)"
                            }
                        }
                    }
                }
                else {
                    self._type = ""
                }
                
                if let descArray = dict["descriptions"] as? [Dictionary<String, String>], descArray.count > 1  {
                    
                    if let url = descArray[0]["resource_uri"] {
                        
                        let descriptionUrl = "\(URL_BASE)\(url)"
                        
                        Alamofire.request(descriptionUrl).responseJSON(completionHandler: {(response)  in
                            
                            if let descDict = response.result.value as? [String: Any] {
                                
                                if let description = descDict["description"] as? String {
                                    
                                  //  let newDescription = description.replacingOccurrences(of: "Pokmon", //with: "Pokemon")
                                    
                                    
                                    let sc = String.CompareOptions.caseInsensitive
                                
                                    let newDescription = description.replacingOccurrences(of: "pokmon", with: "Pokemon", options: sc, range: nil)
                                    
                                    
                                    self._description = newDescription
                                    
                                }
                            }
                            
                            completed()
                        })
                    }
                    
                }
                else {
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, Any>], evolutions.count > 0 {
                    
                    if let nextEvolution = evolutions[0]["to"] as? String {
                        
                        if nextEvolution.range(of: "mega") == nil {
                            self._nextEvolutionName = nextEvolution
                            
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                let newString = uri.replacingOccurrences(of: "/api/v1/pokemon", with: "")
                                let nextEvoId = newString.replacingOccurrences(of: "/", with: "")
                                
                                self._nextEvolutionId = nextEvoId
                                
                                if let levelExists = evolutions[0]["level"] {
                                    
                                    if let level = levelExists as? Int {
                                        self._nextEvolutionLevel = "\(level)"
                                    }
                                }
                                else {
                                    self._nextEvolutionLevel = ""
                                }
                            }
                        }
                    }
                    
                    print (self.nextEvolutionId)
                    print (self.nextEvolutionName)
                    print (self.nextEvolutionLevel)
                }
            }
        
            completed()
        }
        
        
        
        
    }
    
}
