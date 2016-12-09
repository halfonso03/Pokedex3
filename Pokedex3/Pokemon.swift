//
//  Pokemon.swift
//  Pokedex3
//
//  Created by Alfonso, Hector I. on 12/7/16.
//  Copyright © 2016 Alfonso, Hector I. All rights reserved.
//

import Foundation

class Pokemon {
    
    fileprivate var _name: String!
    fileprivate var _pokedexId: Int!
    
    
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
    }
    
}
