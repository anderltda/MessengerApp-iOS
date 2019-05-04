//
//  ContactTableViewController.swift
//  MessengerApp-iOS
//
//  Created by Anderson Nascimento on 27/04/19.
//  Copyright © 2019 anderltda. All rights reserved.
//

import UIKit
import Firebase

class ContactTableViewController: UITableViewController {
    
    let collection = "APP_USER_DEFAULT"
    
    var firestoreListener: ListenerRegistration!
    
    var userModelList: [UserModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        listUsers()
    }

    func listUsers() {
        
        firestoreListener = firestore.collection(collection)
            .addSnapshotListener( includeMetadataChanges: true) { (snapshot, error) in
            
            if error != nil {
                print(error!)
            }
            
            guard let snapshot = snapshot else {return}
            
            print("Total de mudanças: ", snapshot.documentChanges.count)
            
            if snapshot.metadata.isFromCache || snapshot.documentChanges.count > 0 {
               // self.showUsers(snapshot: snapshot)
            }
            
        }
    }
    

    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userModelList.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = userModelList[indexPath.row]
        addEdit(user: user)
        tableView.deselectRow(at: indexPath, animated: true)
        print("Entrou Aqui 0000")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
       
        let user = userModelList[indexPath.row]
        
        cell.textLabel?.text = user.name
       
        cell.detailTextLabel?.text = "\(user.phone)"
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let user = userModelList[indexPath.row]
            
            firestore.collection(collection).document(user.id).delete { (error) in
                if error != nil {
                    print(error!)
                }
            }
            
        }
    }
    
    @IBAction func add(_ sender: Any) {
        addEdit()
    }
    
    func addEdit(user: UserModel? = nil) {
        let title = (user == nil ? "Adicionar" : "Editar")
        let message = (user == nil ? "adicionado" : "editado")
        let alert = UIAlertController(title: title, message: "Digite abaixo os dados do item a ser \(message)", preferredStyle: .alert)
        
        alert.addTextField { (textfield) in
            textfield.placeholder = "Nome"
            textfield.text = user?.name
        }
        
        alert.addTextField { (textfield) in
            textfield.placeholder = "Email"
            textfield.keyboardType = .numberPad
            textfield.text = user?.email
        }
        
        let addAction = UIAlertAction(title: title, style: .default) { (_) in
            
            guard let name = alert.textFields?.first?.text,
                let email = alert.textFields?.last?.text,
                !name.isEmpty, !email.isEmpty else {return}
            
            //var user = user ?? User()
           // user = name
           // user.email = email
          //  self.addUser(user)
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func addUser(_ user: UserModel) {
        
        let data: [String: Any] = [
            "name" : user.name,
            "email" : user.email,
            "id" : Auth.auth().currentUser!.uid
        ]
        
        if user.id.isEmpty {
            // Criar
            firestore.collection(collection).addDocument(data: data) { (error) in
                if error != nil {
                    print(error!)
                }
            }
        } else {
            // Editar
            firestore.collection(collection).document(user.id).updateData(data) { (error) in
                if error != nil {
                    print(error!)
                }
            }
        }
        
    }
}
