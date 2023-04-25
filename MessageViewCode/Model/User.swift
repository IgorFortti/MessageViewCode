//
//  User.swift
//  MessageViewCode
//
//  Created by Igor Fortti on 06/03/23.
//

import Foundation

class User {
    
    var nome: String?
    var email: String?
    
    init(dicionario: [String: Any]) {
        self.nome = dicionario["nome"] as? String
        self.email = dicionario["email"] as? String
    }
}
