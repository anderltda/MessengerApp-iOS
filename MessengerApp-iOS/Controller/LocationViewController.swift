//
//  LocationViewController.swift
//  MessengerApp-iOS
//
//  Created by Anderson Nascimento on 27/04/19.
//  Copyright © 2019 anderltda. All rights reserved.
//

import UIKit
import Firebase

class LocationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var firestoreListener: ListenerRegistration!
    
    var addressModelList: [AddressModel] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        listLocation()
    }
    
    func listLocation() {
        
        firestoreListener = firestore.collection(CONTACTS_LOCATION_APP_FIREBASE)
            .addSnapshotListener( includeMetadataChanges: true) { (snapshot, error) in
                
                if error != nil {
                    print(error!)
                }
                
                guard let snapshot = snapshot else {return}
                
                if snapshot.metadata.isFromCache || snapshot.documentChanges.count > 0 {
                    self.showLocation(snapshot: snapshot)
                }
                
        }
    }
    
    func showLocation(snapshot: QuerySnapshot) {
        
        addressModelList.removeAll()
        
        for document in snapshot.documents {
            let data = document.data()
            let id = (data["id"] as! String)
            let name = data["name"] as! String
            
            let address = AddressModel(id: id, name: name)
            
            addressModelList.append(address)
        }
        
        tableView.reloadData()
    }
}

extension LocationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressModelList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension LocationViewController: UITableViewDelegate {
    
}
