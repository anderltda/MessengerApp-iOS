//
//  SettingViewController.swift
//  MessengerApp-iOS
//
//  Created by Anderson Nascimento on 27/04/19.
//  Copyright © 2019 anderltda. All rights reserved.
//

import UIKit
import Firebase

class ExitViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
        self.navigationController?.popViewController(animated: true)
    }
}
