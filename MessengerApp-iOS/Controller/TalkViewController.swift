//
//  TalkViewController.swift
//  MessengerApp-iOS
//
//  Created by Anderson Nascimento on 27/04/19.
//  Copyright © 2019 anderltda. All rights reserved.
//

import UIKit
import Firebase

class TalkViewController: UIViewController, UITextFieldDelegate {
    
    let collection = "ROOM"
  
    var firestoreListener: ListenerRegistration!
    
    @IBOutlet weak var dockViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tfMessage: UITextField!
    @IBOutlet weak var btSend: UIButton!
    
    var userModel: UserModel!
    
    var chatModelList: [ChatModel] = []
    
    var x: String!
    var y: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tfMessage.delegate = self
        self.btSend.layer.cornerRadius = 10
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.x = self.uid + "-" + self.userModel.id
        self.y = self.userModel.id + "-" + self.uid
        listUsers()
    }
    
    func listUsers() {
        
        firestoreListener = firestore.collection(collection)
            .order(by: "time", descending: false)
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

        let xx = self.uid + "-" + self.userModel.id
        let yy = self.userModel.id + "-" + self.uid
        
        chatModelList.removeAll()
        
        for document in snapshot.documents {
            
            let data = document.data()
            let id = (data["id"] as! String)
            let message = data["message"] as! String
            let x = (data["x"] as! String)
            let y = (data["y"] as! String)
            //let time = data["time"] as! NSData
            //print(data["time"]!)

            if (xx == x) || (yy == y) || (xx == y) || (yy == x){
                chatModelList.append(ChatModel(id: id, message: message, x: x, y: y))
            }

        }
        
        tableView.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func sendMessage(_ sender: UIButton) {
    
        guard let message = tfMessage.text else {return}
        
        firestore.collection(collection)
            .addDocument(data: ["id" : uid,
                                "message" : message,
                                "x": self.x!,
                                "y": self.y!,
                                "time" : Date()])
        
        tfMessage.text = ""
        view.endEditing(true)
        self.tfMessage.endEditing(true)
    }
    
    func tableViewTapped() {
        
        self.tfMessage.endEditing(true)
        
    }
    
    // MARK: TextField Delegate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, animations: {
            self.dockViewHeightConstraint.constant = 380
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, animations: {
            self.dockViewHeightConstraint.constant = 60
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}


// MARK: TableView Delegate Methods

extension TalkViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatModelList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let chat = chatModelList[indexPath.row]
        
        let me = tableView.dequeueReusableCell(withIdentifier: "me", for: indexPath) as! MeTableViewCell
        let you = tableView.dequeueReusableCell(withIdentifier: "you", for: indexPath) as! YouTableViewCell

        if chat.id == uid {
            me.prepare(with: chat)
            return me
        } else {
            you.prepare(with: chat)
            return you
        }
    }
    
}


extension TalkViewController: UITableViewDelegate {
    
}
