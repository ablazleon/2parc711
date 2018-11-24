//
//  MyTableViewCell.swift
//  2parc711
//
//  Created by Adrian on 24/11/2018.
//  Copyright © 2018 Adrian. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var img1View: UIImageView!
    
    @IBOutlet weak var img2View: UIImageView!
    
    @IBOutlet weak var urlLabel: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
