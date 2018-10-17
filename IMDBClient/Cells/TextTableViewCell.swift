//
//  TextTableViewCell.swift
//  IMDBClient
//
//  Created by Polina Guryeva on 17/10/2018.
//  Copyright © 2018 Polina Guryeva. All rights reserved.
//

import UIKit

class TextTableViewCell: UITableViewCell {
    @IBOutlet weak var info: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
