//
//  ContactViewController.swift
//  MessengerApp-iOS
//
//  Created by Anderson Nascimento on 27/04/19.
//  Copyright © 2019 anderltda. All rights reserved.
//

import UIKit
import Firebase

class ContactViewController: UIViewController {
    
    var firestoreListener: ListenerRegistration!
    
    var userModelList: [UserModel] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        title = Auth.auth().currentUser?.displayName
        
        listUsers()
    }
    
    func listUsers() {
        
        firestoreListener = firestore.collection(USER_DEFAULT_APP_FIREBASE)
            .addSnapshotListener( includeMetadataChanges: true) { (snapshot, error) in
                
                if error != nil {
                    print(error!)
                }
                
                guard let snapshot = snapshot else {return}
                
                if snapshot.metadata.isFromCache || snapshot.documentChanges.count > 0 {
                    self.showUsers(snapshot: snapshot)
                }
                
        }
    }
    
    func showUsers(snapshot: QuerySnapshot) {
        
        userModelList.removeAll()
        
        for document in snapshot.documents {
            let data = document.data()
            let id = (data["id"] as! String)
            let name = data["name"] as! String
            let email = data["email"] as! String
            let phone = data["phone"] as! String
            //let create = NSDate(timeIntervalSince1970: (data["create"] as! TimeInterval)/1000)
           // let update = NSDate(timeIntervalSince1970: (data["update"] as! TimeInterval)/1000)
            
            let user = UserModel(id: id, name: name, email: email, phone: phone)
            
            userModelList.append(user)
        }
        
        tableView.reloadData()
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


extension ContactViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userModelList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let user = userModelList[indexPath.row]
        
        let talk = storyboard?.instantiateViewController(withIdentifier: "IdTalkViewController") as! TalkViewController
        
        navigationController?.pushViewController(talk, animated: true)

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
               
        let user = userModelList[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContactTableViewCell

        cell.prepare(with: user)
        
        return cell
    }

}


extension ContactViewController: UITableViewDelegate {
    
}
