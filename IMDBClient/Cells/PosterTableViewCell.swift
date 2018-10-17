//
//  PosterTableViewCell.swift
//  IMDBClient
//
//  Created by Polina Guryeva on 17/10/2018.
//  Copyright © 2018 Polina Guryeva. All rights reserved.
//

import UIKit

class PosterTableViewCell: UITableViewCell {

    @IBOutlet weak var poster: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
