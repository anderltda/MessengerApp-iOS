//
//  SigninViewController.swift
//  MessengerApp-iOS
//
//  Created by Anderson Nascimento on 27/04/19.
//  Copyright © 2019 anderltda. All rights reserved.
//

import UIKit
import Firebase

class SigninViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tfFullName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var btContinue: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tfPhone.delegate = self
        layoutChange()
    }
    
    func layoutChange() {
        
        self.btContinue.layer.cornerRadius = 10
        self.tfFullName.layer.cornerRadius = 10
        self.tfEmail.layer.cornerRadius = 10
        self.tfPassword.layer.cornerRadius = 10
        self.tfPhone.layer.cornerRadius = 10
        
        let colorWhite = UIColor.white
        self.tfFullName.layer.borderColor = colorWhite.cgColor
        self.tfEmail.layer.borderColor = colorWhite.cgColor
        self.tfPassword.layer.borderColor = colorWhite.cgColor
        self.tfPhone.layer.borderColor = colorWhite.cgColor

        self.tfFullName.layer.borderWidth = 1.0
        self.tfEmail.layer.borderWidth = 1.0
        self.tfPassword.layer.borderWidth = 1.0
        self.tfPhone.layer.borderWidth = 1.0
       
        self.tfFullName.backgroundColor = UIColor.clear
        self.tfEmail.backgroundColor = UIColor.clear
        self.tfPassword.backgroundColor = UIColor.clear
        self.tfPhone.backgroundColor = UIColor.clear
        
        self.tfFullName.attributedPlaceholder = NSAttributedString(string: "Full Name",
                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        self.tfPassword.attributedPlaceholder = NSAttributedString(string: "Password",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        self.tfEmail.attributedPlaceholder = NSAttributedString(string: "E-mail",
                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        self.tfPhone.attributedPlaceholder = NSAttributedString(string: "Phone XX999999999",
                                                              attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let phone = textField.text,
            let rangeOfTextToReplace = Range(range, in: phone) else {
                return false
        }
        
        let substringToReplace = phone[rangeOfTextToReplace]
        let count = phone.count - substringToReplace.count + string.count
        return count <= 11
    }
    
    @IBAction func btCreate(_ sender: UIButton) {
        
        guard tfEmail.text != "", tfPassword.text != "", self.tfPhone.text != "" else {
            
            self.alert(title: "Atenção", message: "Todos os campos são obrigatorios o seu preenchimento!")
            
            return
        }
        
        Auth.auth().createUser(withEmail: tfEmail.text!, password: tfPassword.text!) { (result, error) in
            if error == nil {
                
                let userEntity = UserEntity(context: self.context)
                userEntity.uid = result?.user.uid
                userEntity.email = self.tfEmail.text
                userEntity.name = self.tfFullName.text
                userEntity.phone = self.tfPhone.text
                userEntity.create = Date()
                userEntity.update = Date()
                
                do {
                    try self.context.save()
                } catch {
                    self.alert(title: "Error", message: error.localizedDescription)
                    return
                }
                
                self.firestore.collection(self.USER_DEFAULT_APP_FIREBASE)
                    .document(userEntity.uid!)
                    .setData([
                        "id" : userEntity.uid!,
                        "email" : userEntity.email!,
                        "name" : userEntity.name!,
                        "phone" : userEntity.phone!,
                        "create" : Date(),
                        "update" : Date()
                        ])
                
                self.authorized()
                
            } else {
                self.alert(title: "Error", message: error!.localizedDescription)
            }
            
            self.view.endEditing(true)
        }
    }
    
    func authorized() {
        
        let home = storyboard?.instantiateViewController(withIdentifier: "IdMainTabBarController") as! MainTabBarController
        
        navigationController?.pushViewController(home, animated: true)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
