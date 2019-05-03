//
//  ContactTableViewCell.swift
//  MessengerApp-iOS
//
//  Created by Anderson Nascimento on 03/05/19.
//  Copyright © 2019 anderltda. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var ivAvatar: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func prepare(with user: UserModel) {
        lbName.text = user.name
        lbDescription.text = user.email
        lbTime.text = "10:29 PM"
    }

}
