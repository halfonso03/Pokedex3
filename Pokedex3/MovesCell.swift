//
//  MovesCell.swift
//  Pokedex3
//
//  Created by Alfonso, Hector I. on 12/12/16.
//  Copyright © 2016 Alfonso, Hector I. All rights reserved.
//

import UIKit

class MovesCell: UITableViewCell {

    @IBOutlet weak var moveNameLabel: UILabel!
    @IBOutlet weak var moveLevelLabel: UILabel!
    
    @IBOutlet weak var moveDescriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(moveName: String, moveLevel: Int) {
        moveNameLabel.text = moveName.capitalized
        if moveLevel != 0 {
            moveLevelLabel.text = "Level: \(moveLevel)"
        }
        
        
    }

}
