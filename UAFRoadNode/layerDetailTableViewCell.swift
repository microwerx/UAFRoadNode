//
//  layerDetailTableViewCell.swift
//  UAFRoadNode
//
//  Created by Nami Kim on 4/19/20.
//  Copyright © 2020 UAFRoadNode. All rights reserved.
//

import UIKit

class layerDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var attributeLabel: UILabel!
    @IBOutlet weak var valueTypeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
