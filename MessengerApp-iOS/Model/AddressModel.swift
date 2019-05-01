//
//  AddressModel.swift
//  MessengerApp-iOS
//
//  Created by Anderson Nascimento on 01/05/19.
//  Copyright © 2019 anderltda. All rights reserved.
//

import Foundation

class AddressModel : Codable {
    
    var id: String!
    var name: String!
    var lat: Double!
    var long: Double!
    var cep: String = ""
    var logradouro: String = ""
    var complemento: String = ""
    var bairro: String = ""
    var localidade: String = ""
    var uf: String = ""
    var number: String!
    
}
