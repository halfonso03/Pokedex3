//
//  MovesViewController.swift
//  Pokedex3
//
//  Created by Alfonso, Hector I. on 12/12/16.
//  Copyright © 2016 Alfonso, Hector I. All rights reserved.
//

import UIKit
import Alamofire

class MovesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var pokemon: Pokemon!
    var movesSorted: [Dictionary<String, Any>]!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var pokemonSegmentControl: UISegmentedControl!
    @IBOutlet weak var movesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        movesTableView.rowHeight = UITableViewAutomaticDimension
        movesTableView.estimatedRowHeight = 80
        nameLabel.text = pokemon.name.capitalized
        pokemonSegmentControl.selectedSegmentIndex = 1
        movesTableView.delegate = self
        movesTableView.dataSource = self
        movesSorted = pokemon.moves.sorted(by: { (lhs: [String: Any], rhs: [String: Any]) -> Bool in
            return (lhs["name"] as! String) < (rhs["name"] as! String)
        })
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movesSorted.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = movesTableView.dequeueReusableCell(withIdentifier: "movesCell", for: indexPath) as? MovesCell {
            
            let move = movesSorted[indexPath.row]
            let resource_uri = movesSorted[indexPath.row]["resource_uri"] as! String
            
            if let level = move["level"] as? Int {
                cell.configureCell(moveName: move["name"]! as! String, moveLevel: level)
            }
            else {
                cell.configureCell(moveName: move["name"]! as! String, moveLevel: 0)
            }
            
            let rowIndex = indexPath.row
            
            
            getDescriptions(index: rowIndex, moveUri: resource_uri) { () -> () in
                
                
                var i = 0
                
                repeat {
                    
                    if let cell = self.movesTableView.cellForRow(at: IndexPath(row: i, section: 0)) as? MovesCell {
                        if (cell.moveDescriptionLabel.text?.isEmpty)! {
                            cell.moveDescriptionLabel.text = self.moveUris[i]
                            self.movesTableView.reloadRows(at: [IndexPath(row: i, section: 0)], with: UITableViewRowAnimation.none)
                        }
                    }
                    
                                       
                    
                    i += 1
                    
                } while (i < self.moveUris.count)
            }
            
            
            return cell
        }
        else {
             return UITableViewCell()
        }
    }
    
    var moveUris = [String]()
    
    func getDescriptions(index: Int, moveUri: String, completed: @escaping () -> ()) {
        
       print ("\(index): \(moveUri)")
        
        Alamofire.request("http://pokeapi.co\(moveUri)").responseJSON { (response) -> Void in
            
            if let dict = response.result.value as? [String: Any] {
            
                let description = dict["description"] as! String
                
                self.moveUris.append(description.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
                
                completed()
                
            }
            
        }
        
    }
    
    
    
    @IBAction func backBUuttonPressed(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }

    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            dismiss(animated: true, completion: nil)
        }
    }
    
    
}
