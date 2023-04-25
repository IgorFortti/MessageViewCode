//
//  Contact.swift
//  MessageViewCode
//
//  Created by Igor Fortti on 06/03/23.
//

import Foundation

class Contact {
    
    var id: String?
    var nome: String?
    
    init(dicionario: [String: Any]?) {
        self.id = dicionario?["id"] as? String
        self.nome = dicionario?["nome"] as? String
    }
    
    convenience init (id: String?, nome: String?) {
        self.init(dicionario: nil)
        self.id = id
        self.nome = nome
    }
}
