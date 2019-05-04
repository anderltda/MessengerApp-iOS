//
//  RESTService.swift
//  MessengerApp-iOS
//
//  Created by Anderson Nascimento on 01/05/19.
//  Copyright © 2019 anderltda. All rights reserved.
//

import Foundation

class RESTService {
    
    private static let basePath = "https://viacep.com.br"
    
    private static let session = URLSession(configuration: configuration)
    
    private static let configuration : URLSessionConfiguration = {
        
        let config = URLSessionConfiguration.default
        
        // Desabilitar acesso a internet movel
        config.allowsCellularAccess = false
        
        // Adiconar alguma coisa no header
        config.httpAdditionalHeaders = ["Content-Type": "application/json"]
        
        // Configurar um tempo para o timeout
        config.timeoutIntervalForRequest = 30.0
        
        // Maximo de conexao que podera ter simultaniamente
        config.httpMaximumConnectionsPerHost = 3
        
        return config
    }()

    
    class func buscarCep(cep: String, onComplete: @escaping (AddressModel) -> Void) {
        
        let urlString = basePath + "/ws/" + (cep) + "/json/"

        guard let url = URL(string: urlString) else {
            print("Erro ao montar URL")
            return
        }
        
        var urlResquest = URLRequest(url: url)
        
        urlResquest.httpMethod = "GET"
        
        let task = session.dataTask(with: urlResquest, completionHandler: { (data, response, error) in
            
            if error != nil {
                print("Deu erro", error!)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("Response nulo")
                return
            }
            
            if response.statusCode != 200 {
                print("Erro de status code", response.statusCode)
                return
            }
            
            guard let data = data else {
                print("Dados inválidos!")
                return
            }
            
            do {
                let address = try JSONDecoder().decode(AddressModel.self, from: data)
                onComplete(address)
            } catch {
                print(error)
            }
        })
        task.resume()
    }
    
}
