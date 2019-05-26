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
        self.navigationItem.hidesBackButton = true
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
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
            let id = data["id"] as! String
            let name = data["name"] as! String
            let lat = data["lat"] as! Double
            let long = data["long"] as! Double
            let cep = data["cep"] as! String
            let logradouro = data["logradouro"] as! String
            let complemento = data["complemento"] as! String
            let bairro = data["bairro"] as! String
            let localidade = data["localidade"] as! String
            let estado = data["estado"] as! String
            let number = data["number"] as! String
            
            let address = AddressModel()
            address.id = id
            address.name = name
            address.lat = lat
            address.long = long
            address.cep = cep
            address.logradouro = logradouro
            address.complemento = complemento
            address.bairro = bairro
            address.localidade = localidade
            address.uf = estado
            address.number = number
            
            if self.uid != id {
                addressModelList.append(address)
            }
            
        }
        
        tableView.reloadData()
    }
}

extension LocationViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! LocationTableViewCell
        let address = addressModelList[indexPath.row]
        cell.prepare(with: address)
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addressModelList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let address = addressModelList[indexPath.row]
        
        let map = storyboard?.instantiateViewController(withIdentifier: "IdMapsViewController") as! MapsViewController
        
        map.prepare(with: address)
        
        navigationController?.pushViewController(map, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

extension LocationViewController: UITableViewDelegate {
    
}
