//
//  LocationTableViewCell.swift
//  MessengerApp-iOS
//
//  Created by Anderson Nascimento on 01/05/19.
//  Copyright © 2019 anderltda. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {

    @IBOutlet weak var ivAvatar: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func prepare(with address: AddressModel) {
        lbName.text = address.name
        //lbTime.text = "10:29 PM"
    }
}
