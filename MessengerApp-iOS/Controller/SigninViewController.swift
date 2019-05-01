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
                        "id" : result?.user.uid,
                        "email" : self.tfEmail.text,
                        "name" : self.tfFullName.text,
                        "phone" : self.tfPhone.text,
                        "create" : Date()
                        ])
                
            } else {
                print(error!)
            }
        }
        

        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
