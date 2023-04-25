//
//  Conversation.swift
//  MessageViewCode
//
//  Created by Igor Fortti on 06/03/23.
//

import Foundation

class Conversation {
    
    var nome: String?
    var ultimaMensagem: String?
    var idDestinatario: String?
    
    init(dicionario: [String: Any]) {
        self.nome = dicionario["nomeUsuario"] as? String
        self.ultimaMensagem = dicionario["ultimaMensagem"] as? String
        self.idDestinatario = dicionario["idDestinatario"] as? String
    }
}
