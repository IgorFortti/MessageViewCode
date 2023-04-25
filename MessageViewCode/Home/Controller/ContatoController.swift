//
//  ContatoController.swift
//  MessageViewCode
//
//  Created by Igor Fortti on 06/03/23.
//

import Foundation
import UIKit
import FirebaseFirestore

protocol ContatoProtocol: AnyObject {
    func alertStateError(titulo: String, message: String)
    func successContato()
}

class ContatoController{
    
    weak private var delegate: ContatoProtocol?
    
    public func delegate(delegate: ContatoProtocol?) {
        self.delegate = delegate
    }
    
    func addContact(email: String, emailUsuarioLogado: String, idUsuario: String) {
        if email == emailUsuarioLogado {
            self.delegate?.alertStateError(titulo: "Atenção", message: "Voce adicionou seu próprio e-mail")
            return
        }
        let firestore = Firestore.firestore()
        firestore.collection("usuarios").whereField("email", isEqualTo: email).getDocuments { snapshotResultado, error in
            if let totalItens = snapshotResultado?.count {
                if totalItens == 0{
                    self.delegate?.alertStateError(titulo: "Atenção", message: "Não foi possível realizar o cadastro. Por favor, verifique o e-mail e tente novamente")
                    return
                }
            }
            if let snapshot = snapshotResultado {
                for document in snapshot.documents {
                    let dados = document.data()
                    self.salvarContato(dadosContato: dados, idUsuario: idUsuario)
                }
            }
        }
    }
    
    func salvarContato(dadosContato: Dictionary<String,Any>, idUsuario: String) {
        let contact: Contact = Contact(dicionario: dadosContato)
        let firestore: Firestore = Firestore.firestore()
        firestore.collection("usuarios").document(idUsuario).collection("contatos").document(contact.id ?? "").setData(dadosContato) { (error) in
            if error == nil {
                self.delegate?.successContato()
            }
        }
    }
}
