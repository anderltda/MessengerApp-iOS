//
//  ProfileViewController.swift
//  MessengerApp-iOS
//
//  Created by Anderson Nascimento on 27/04/19.
//  Copyright © 2019 anderltda. All rights reserved.
//

import UIKit
import CoreData

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var tfFullName: UITextField!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfPhone: UITextField!
    @IBOutlet weak var tfCep: UITextField!
    
    var address: AddressModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findByUser()
    }
    
    func findByUser() {
        
        do {
            
            let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
           
            fetchRequest.predicate = NSPredicate(format: "uid == %@", uid)
            
            let fetchedResults = try context.fetch(fetchRequest) as! [UserEntity]
           
            if let user = fetchedResults.first {
            
                self.tfFullName.text = user.name
                self.tfEmail.text = user.email
                self.tfPhone.text = user.phone
            
            } else {
                
                let user = firestore.collection(USER_DEFAULT_APP_FIREBASE).whereField("id", isEqualTo: uid)
                    .addSnapshotListener( includeMetadataChanges: true) { (snapshot, error) in
                        
                        if error != nil {
                            print(error!)
                        }
                        
                        guard let snapshot = snapshot else {return}
                        
                        if snapshot.metadata.isFromCache || snapshot.documentChanges.count > 0 {
                            
                            for document in snapshot.documents {
                                
                                let data = document.data()
                                let id = (data["id"] as! String)
                                let name = data["name"] as! String
                                let email = data["email"] as! String
                                let phone = data["phone"] as! String
                                
                                let user = UserModel(id: id, name: name, email: email, phone: phone)
                                
                                self.tfFullName.text = user.name
                                self.tfEmail.text = user.email
                                self.tfPhone.text = user.phone
                                
                            }
                        }
                        
                }
            }

        } catch {
            print ("fetch task failed", error)
        }
 
    }
    
    @IBAction func btSalvar(_ sender: UIButton) {
        
        var userEntity = UserEntity(context: context)
        userEntity.uid = uid
        userEntity.email = tfEmail.text
        userEntity.name = tfFullName.text
        userEntity.phone = tfPhone.text
        //userEntity.updated = Date
        
        do {
          try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    @IBAction func btBucarCep(_ sender: UIButton) {

        RESTService.buscarCep(cep: tfCep.text!) { (address) in
            self.address = address
            DispatchQueue.main.async {
                self.tfFullName.text = self.address.logradouro
            }
        }


    }
    
    

}

