//
//  ViewController.swift
//  MessengerApp-iOS
//
//  Created by Anderson Nascimento on 27/04/19.
//  Copyright © 2019 anderltda. All rights reserved.
//
import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user != nil {
                self.authorized(animated: false)
            }
        })
    }
    
    func authorized(animated: Bool = true) {
        let home = storyboard?.instantiateViewController(withIdentifier: "IdMainTabBarController") as! MainTabBarController
        navigationController?.pushViewController(home, animated: animated)
    }
    
    func removeListener() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    @IBAction func login(_ sender: Any) {
        removeListener()
        guard tfEmail.text != "", tfPassword.text != "" else {
            self.alert(title: "Atenção", message: "E-mail e Password são obrigatorios o seu preenchimento!")
            return
        }
        
        Auth.auth().signIn(withEmail: tfEmail.text!, password: tfPassword.text!) { (result, error) in
            if error == nil {
                self.authorized(animated: true)
            } else {
                self.alert(title: "Error", message: error!.localizedDescription)
            }
        }
        
        self.view.endEditing(true)
    }
    
    @IBAction func signup(_ sender: Any) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

