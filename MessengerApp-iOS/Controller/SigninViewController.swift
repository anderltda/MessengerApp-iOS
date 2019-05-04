//
//  SigninViewController.swift
//  MessengerApp-iOS
//
//  Created by Anderson Nascimento on 27/04/19.
//  Copyright © 2019 anderltda. All rights reserved.
//

import UIKit
import Firebase

class SigninViewController: UIViewController {

    @IBOutlet weak var tfFullName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btCreate(_ sender: UIButton) {
        
        Auth.auth().createUser(withEmail: tfEmail.text!, password: tfPassword.text!) { (result, error) in
            if error == nil {
                
                var userEntity = UserEntity(context: self.context)
                userEntity.uid = result?.user.uid
                userEntity.email = self.tfEmail.text
                userEntity.name = self.tfFullName.text
                userEntity.phone = self.tfPhone.text
                
                do {
                    try self.context.save()
                } catch {
                    print(error.localizedDescription)
                }
                
                self.firestore.collection(self.USER_DEFAULT_APP_FIREBASE)
                    .document(userEntity.uid!)
                    .setData([
                        "id" : userEntity.uid,
                        "email" : userEntity.email,
                        "name" : userEntity.name,
                        "phone" : userEntity.phone,
                        "create" : Date()
                        ])
                
            } else {
                print(error!)
            }
        }
        

        
    }
    
}
