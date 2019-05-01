//
//  TalkTableViewCell.swift
//  MessengerApp-iOS
//
//  Created by Anderson Nascimento on 29/04/19.
//  Copyright © 2019 anderltda. All rights reserved.
//

import UIKit

class TalkTableViewCell: UITableViewCell {
    
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
       lbMessage.text = chat.message
       lbTime.text = "10:29 PM"
    }
}
