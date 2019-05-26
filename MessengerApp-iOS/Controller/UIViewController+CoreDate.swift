//
//  UIViewController+CoreDate.swift
//  MessengerApp-iOS
//
//  Created by Anderson Nascimento on 30/04/19.
//  Copyright © 2019 anderltda. All rights reserved.
//

import UIKit
import CoreData
import Firebase

extension UIViewController {
    
    var USER_DEFAULT_APP_FIREBASE: String {
        return "APP_USER_DEFAULT"
    }
    
    var CONTACTS_CHAT_APP_FIREBASE: String {
        return "CONTACTS"
    }
    
    var CONTACTS_LOCATION_APP_FIREBASE: String {
        return "LOCATIONS"
    }
    
    var firestore: Firestore {
        
        let settings = FirestoreSettings()
        
        settings.isPersistenceEnabled = true
        
        let firestore = Firestore.firestore()
        
        firestore.settings = settings
        
        return firestore
    }
    
    func alert(title: String, message: String) {
        
        let alerta = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alerta.addAction(ok)
        
        present(alerta, animated: true, completion: nil)
    }
    
    var uid: String {
        
        guard let auth = Auth.auth().currentUser else {
           return ""
        }
        
        return auth.uid
    }
    
    var context: NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext
        
    }
    
}
