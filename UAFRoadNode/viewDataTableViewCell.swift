//
//  viewDataTableViewCell.swift
//  UAFRoadNode
//
//  Created by Alex Lewandowski and Nami Kim on 4/27/20.
//  Copyright © 2020 UAFRoadNode. All rights reserved.
//

import UIKit

class viewDataTableViewCell: UITableViewCell {

    @IBOutlet weak var attributeType: UILabel!
    @IBOutlet weak var attributeValue: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
