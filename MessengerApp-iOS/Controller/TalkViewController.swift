//
//  TalkViewController.swift
//  MessengerApp-iOS
//
//  Created by Anderson Nascimento on 27/04/19.
//  Copyright © 2019 anderltda. All rights reserved.
//

import UIKit
import Firebase

class TalkViewController: UIViewController {
    
    let collection = "ROOM"
  
    var firestoreListener: ListenerRegistration!
    
    var chatModelList: [ChatModel] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tfMessage: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Auth.auth().currentUser?.displayName
        listUsers()
    }
    
    func listUsers() {
        
        firestoreListener = firestore.collection(collection).order(by: "time", descending: false)
            .addSnapshotListener( includeMetadataChanges: true) { (snapshot, error) in
                
                if error != nil {
                    print(error!)
                }
                
                guard let snapshot = snapshot else {return}
                
                print("Total de mudanças: ", snapshot.documentChanges.count)
                
                if snapshot.metadata.isFromCache || snapshot.documentChanges.count > 0 {
                    self.showUsers(snapshot: snapshot)
                }
                
        }
    }
    
    func showUsers(snapshot: QuerySnapshot) {
        
        chatModelList.removeAll()
        
        for document in snapshot.documents {
            let data = document.data()
            let id = (data["id"] as! String)
            let message = data["message"] as! String
            // let time = data["time"] as! NSData
            
            print(data["time"]!)
            
            let chat = ChatModel(id: id, message: message)
            
            chatModelList.append(chat)
        }
        
        tableView.reloadData()
    }
    
    @IBAction func btSend(_ sender: UIButton) {
    
        guard let message = tfMessage.text else {return}
        
        firestore.collection(collection)
            .addDocument(data: ["id" : uid,
                                "message" : message,
                                "time" : Date()])
        
        tfMessage.text = ""
        
    }
    
    
}


extension TalkViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatModelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TalkTableViewCell
        
        let chat = chatModelList[indexPath.row]
    
        cell.prepare(with: chat)
        
        return cell
    }
    
}


extension TalkViewController: UITableViewDelegate {
    
}
