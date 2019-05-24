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
    @IBOutlet weak var btLogin: UIButton!
    
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.layoutChange()
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user != nil {
                self.authorized(animated: false)
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func layoutChange() {
        
        self.tabBarController?.tabBar.shadowImage = UIImage()
        
        self.tabBarController?.tabBar.backgroundImage = UIImage()
        
        self.tabBarController?.tabBar.clipsToBounds = true
        
        self.btLogin.layer.cornerRadius = 10
        self.tfEmail.layer.cornerRadius = 10
        self.tfPassword.layer.cornerRadius = 10
        
        let colorWhite = UIColor.white
        self.tfEmail.layer.borderColor = colorWhite.cgColor
        self.tfPassword.layer.borderColor = colorWhite.cgColor
        
        self.tfEmail.layer.borderWidth = 1.0
        self.tfPassword.layer.borderWidth = 1.0
        
        self.tfEmail.backgroundColor = UIColor.clear
        self.tfPassword.backgroundColor = UIColor.clear
        
        self.tfEmail.attributedPlaceholder = NSAttributedString(string: "E-mail",
                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
        self.tfPassword.attributedPlaceholder = NSAttributedString(string: "Password",
                                                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
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


