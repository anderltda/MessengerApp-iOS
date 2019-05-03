//
//  YouTableViewCell.swift
//  MessengerApp-iOS
//
//  Created by Anderson Nascimento on 03/05/19.
//  Copyright © 2019 anderltda. All rights reserved.
//

import UIKit

class YouTableViewCell: UITableViewCell {

    @IBOutlet weak var ivAvatar: UIImageView!
    @IBOutlet weak var vwYou: UIView!
    @IBOutlet weak var lbMessage: UILabel!
    @IBOutlet weak var lbTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func prepare(with chat: ChatModel) {
        vwYou.layer.cornerRadius = 10
        lbMessage.text = chat.message
        lbTime.text = "11:46 PM"
    }


}
