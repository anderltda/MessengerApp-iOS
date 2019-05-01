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
import FirebaseCore
import FirebaseFirestore
import FirebaseAnalytics
import FirebaseAuth

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
    
    var uid: String {
        return Auth.auth().currentUser!.uid
    }
    
    var context: NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        return appDelegate.persistentContainer.viewContext
        
    }
    
}
