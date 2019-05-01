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
        // Do any additional setup after loading the view.
        
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            print("Usuario logado:", user?.email)
            if let user = user {
                self.showMainScreen(user: user, animated: false)
            }
        })
    }
    
    func showMainScreen(user: User?, animated: Bool = true) {
        print("Indo para a proxima tela")
        
        let myVC = storyboard?.instantiateViewController(withIdentifier: "IdMainTabBarController") as! MainTabBarController

        navigationController?.pushViewController(myVC, animated: true)
        
        //guard let vc = storyboard?.instantiateViewController(withIdentifier: String(describing: ContactController.self)) else {return}
        
        //navigationController?.pushViewController(vc, animated: animated)
    }
    
    func performUserhange(user: User?) {
        
        guard let user = user else { return }
        
        let changeRequest = user.createProfileChangeRequest()
        
        
        changeRequest.commitChanges { (error) in
            if error != nil {
                print(error!)
            }
            
            self.showMainScreen(user: user, animated: true)
        }
    }
    
    func removeListener() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
        
    }

    @IBAction func login(_ sender: Any) {
        removeListener()
        Auth.auth().signIn(withEmail: tfEmail.text!, password: tfPassword.text!) { (result, error) in
            if error == nil {
                print("usuario logado", result)
                self.showMainScreen(user: result?.user, animated: true)
            } else {
                print(error!)
            }
        }
    }
    
    @IBAction func signup(_ sender: Any) {
        
    }
}

