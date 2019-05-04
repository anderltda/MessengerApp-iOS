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
    @IBOutlet weak var tfZipCode: UITextField!
    @IBOutlet weak var tfPlace: UITextField!
    @IBOutlet weak var tfDistrict: UITextField!
    @IBOutlet weak var tfNumber: UITextField!
    @IBOutlet weak var tfComplement: UITextField!
    @IBOutlet weak var tfCity: UITextField!
    
    var addressModel: AddressModel!
    var userModel: UserModel!
    
    var addressEntity: AddressEntity!
    var userEntity: UserEntity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findByUserFirebaseOrCoreData()
        findByAddressFirebaseOrCoreData()
    }
    
    func findByUserFirebaseOrCoreData() {
        
        do {
            
            let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
            
            fetchRequest.predicate = NSPredicate(format: "uid == %@", uid)
            
            let fetchedResults = try context.fetch(fetchRequest)
            
            if let user = fetchedResults.first {
                
                self.userEntity = user
                self.tfFullName.text = self.userEntity.name
                self.tfEmail.text = self.userEntity.email
                self.tfPhone.text = self.userEntity.phone
                
            } else {
                
                _ = firestore.collection(USER_DEFAULT_APP_FIREBASE).whereField("id", isEqualTo: uid)
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
                                
                                self.userModel = UserModel(id: id, name: name, email: email, phone: phone)
                                
                                self.tfFullName.text = self.userModel.name
                                self.tfEmail.text = self.userModel.email
                                self.tfPhone.text = self.userModel.phone
                                
                            }
                        }
                        
                }
            }
            
        } catch {
            print ("fetch task failed", error)
        }
        
    }
    
    func findByAddressFirebaseOrCoreData() {
        
        do {
            
            let fetchRequest: NSFetchRequest<AddressEntity> = AddressEntity.fetchRequest()
            
            fetchRequest.predicate = NSPredicate(format: "uid == %@", uid)
            
            let fetchedResults = try context.fetch(fetchRequest)
            
            if let address = fetchedResults.first {
                
                self.addressEntity = address
                tfZipCode.text = self.addressEntity.cep
                tfPlace.text = self.addressEntity.logradouro
                tfDistrict.text = self.addressEntity.bairro
                tfNumber.text = self.addressEntity.number
                tfComplement.text = self.addressEntity.complemento
                
                if let localidade = addressEntity.localidade, let uf = addressEntity.uf {
                    tfCity.text = "\(String(describing: localidade))/\(String(describing: uf))"
                }
                
            } else {
                
                _ = firestore.collection(CONTACTS_LOCATION_APP_FIREBASE).whereField("id", isEqualTo: uid)
                    .addSnapshotListener( includeMetadataChanges: true) { (snapshot, error) in
                        
                        if error != nil {
                            print(error!)
                        }
                        
                        guard let snapshot = snapshot else {return}
                        
                        if snapshot.metadata.isFromCache || snapshot.documentChanges.count > 0 {
                            
                            for document in snapshot.documents {
                                
                                let data = document.data()
                                let id = (data["id"] as! String)
                                let name = (data["name"] as! String)
                                let lat = (data["lat"] as! Double)
                                let long = (data["long"] as! Double)
                                let cep = (data["cep"] as! String)
                                let logradouro = (data["logradouro"] as! String)
                                let complemento = (data["complemento"] as! String)
                                let bairro = (data["bairro"] as! String)
                                let localidade = (data["localidade"] as! String)
                                let estado: String = (data["estado"] as! String)
                                let number = (data["number"] as! String)
                                
                                self.addressModel = AddressModel()
                                self.addressModel.id = id
                                self.addressModel.name = name
                                self.addressModel.lat = lat
                                self.addressModel.long = long
                                self.addressModel.cep = cep
                                self.addressModel.logradouro = logradouro
                                self.addressModel.complemento = complemento
                                self.addressModel.bairro = bairro
                                self.addressModel.localidade = localidade
                                self.addressModel.uf = estado
                                self.addressModel.number = number
                                
                                self.tfZipCode.text = self.addressModel.cep
                                self.tfPlace.text = self.addressModel.logradouro
                                self.tfDistrict.text = self.addressModel.bairro
                                self.tfNumber.text = self.addressModel.number
                                self.tfComplement.text = self.addressModel.complemento
                                self.tfCity.text = "\(String(describing: self.addressModel.localidade))/\(String(describing: self.addressModel.uf))"
                                
                            }
                        }
                }
            }
            
        } catch {
            print ("fetch task failed", error)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func btSalvar(_ sender: UIButton) {
        
        if userEntity == nil {
            userEntity = UserEntity(context: context)
            userEntity.create = Date.init()
        }
        
        if addressEntity == nil {
            addressEntity = AddressEntity(context: context)
            addressEntity.create = Date.init()
        }
        
        if addressModel != nil {
            addressEntity.localidade = addressModel.localidade
            addressEntity.logradouro = addressModel.logradouro
            addressEntity.uf = addressModel.uf
        }
        
        
        userEntity.uid = uid
        userEntity.email = tfEmail.text
        userEntity.name = tfFullName.text
        userEntity.phone = tfPhone.text
        userEntity.update = Date.init()
        
        addressEntity.uid = uid
        addressEntity.name = tfFullName.text
        addressEntity.bairro = tfDistrict.text
        addressEntity.cep = tfZipCode.text
        addressEntity.number = tfNumber.text
        addressEntity.complemento = tfComplement.text
        addressEntity.lat = -23.4834015
        addressEntity.long = -46.661051
        addressEntity.update = Date.init()
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
        self.firestore.collection(self.USER_DEFAULT_APP_FIREBASE)
            .document(userEntity.uid!)
            .setData([
                "id" : userEntity.uid!,
                "email" : userEntity.email!,
                "name" : userEntity.name!,
                "phone" : userEntity.phone!,
                "update" : Date()
                ])
        
        self.firestore.collection(self.CONTACTS_LOCATION_APP_FIREBASE)
            .document(addressEntity.uid!)
            .setData([
                "id" : addressEntity.uid!,
                "name" : addressEntity.name!,
                "lat" : addressEntity.lat,
                "long" : addressEntity.long,
                "cep" : addressEntity.cep!,
                "logradouro" : addressEntity.logradouro!,
                "complemento" : addressEntity.complemento!,
                "bairro" : addressEntity.bairro!,
                "localidade" : addressEntity.localidade!,
                "estado" : addressEntity.uf!,
                "number" : addressEntity.number!,
                "create" : addressEntity.create!,
                "update" : addressEntity.update!
                ])
        
        view.endEditing(true)
        findByUserFirebaseOrCoreData()
        findByAddressFirebaseOrCoreData()
    }
    
    @IBAction func btBucarCep(_ sender: UIButton) {
        
        RESTService.buscarCep(cep: tfZipCode.text!) { (address) in
            self.addressModel = address
            DispatchQueue.main.async {
                self.tfPlace.text = self.addressModel.logradouro
                self.tfDistrict.text = self.addressModel.bairro
                self.tfCity.text = "\(self.addressModel.localidade)/\(self.addressModel.uf)"
            }
        }
        
    }
}



