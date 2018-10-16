//
//  MovieTableViewCell.swift
//  IMDBClient
//
//  Created by Polina Guryeva on 15/10/2018.
//  Copyright © 2018 Polina Guryeva. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
