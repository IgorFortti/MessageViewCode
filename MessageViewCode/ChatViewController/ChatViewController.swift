//
//  ChatViewController.swift
//  MessageViewCode
//
//  Created by Igor Fortti on 07/03/23.
//

import UIKit
import Firebase
import AVFoundation

class ChatViewController: UIViewController {
    
    var listaMensagens: [Message] = []
    var idUsuarioLogado: String?
    var contato: Contact?
    var mensagemListener: ListenerRegistration?
    var auth: Auth?
    var db: Firestore?
    var nomeContato: String?
    var nomeUsuarioLogado: String?
    var chatScreen: ChatViewScreen?
    
    override func loadView() {
        chatScreen = ChatViewScreen()
        view = chatScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configDataFirebase()
        configChatView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addListenerRecuperMensagens()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mensagemListener?.remove()
    }
    
    private func addListenerRecuperMensagens() {
        if let idDestinatario = self.contato?.id {
            mensagemListener = db?.collection("mensagens").document(idUsuarioLogado ?? "").collection(idDestinatario).order(by: "data", descending: true).addSnapshotListener({ querySnapshot, error in
                self.listaMensagens.removeAll()
                if let snapshot = querySnapshot {
                    for document in snapshot.documents {
                        let dados = document.data()
                        self.listaMensagens.append(Message(dicionario: dados))
                    }
                    self.chatScreen?.reloadTableView()
                }
            })
        }
    }
        
    private func configDataFirebase() {
        auth = Auth.auth()
        db = Firestore.firestore()
        if let id = auth?.currentUser?.uid {
            idUsuarioLogado = id
            recuperarDadosUsuarioLogado()
        }
        if let nome = contato?.nome {
            nomeContato = nome
        }
    }
    
    private func recuperarDadosUsuarioLogado() {
        let usuarios = db?.collection("usuarios").document(idUsuarioLogado ?? "")
        usuarios?.getDocument(completion: { documentSnapshot, error in
            if error == nil {
                let dados: Contact = Contact(dicionario: documentSnapshot?.data() ?? [:])
                self.nomeUsuarioLogado = dados.nome ?? ""
            }
        })
    }
    
    private func configChatView() {
        chatScreen?.configNavView(controller: self)
        chatScreen?.configTableView(delegate: self, dataSource: self)
        chatScreen?.delegate(delegate: self)
    }
    
    @objc func tappedBackButton() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    private func salvarMensagem(idRemetente: String, idDestinatario: String, mensagem: [String:Any]) {
        db?.collection("mensagens").document(idRemetente).collection(idDestinatario).addDocument(data: mensagem)
        chatScreen?.inputMessageTextField.text = ""
    }
    
    private func salvarConversa(idRemetente: String, idDestinatario: String, conversa: [String:Any]) {
        db?.collection("conversas").document(idRemetente).collection("ultimas_conversas").document(idDestinatario).setData(conversa)
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listaMensagens.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let indice = indexPath.row
        let dados = listaMensagens[indice]
        let idUsuario = dados.idUsuario ?? ""
        if idUsuarioLogado != idUsuario {
            let cell = tableView.dequeueReusableCell(withIdentifier: IncomingTextMessageTableViewCell.identifier, for: indexPath) as? IncomingTextMessageTableViewCell
            cell?.transform = CGAffineTransform(scaleX: 1, y: -1)
            cell?.setupCell(message: dados)
            cell?.selectionStyle = .none
            return cell ?? UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: OutgoingTextMessageTableViewCell.identifier, for: indexPath) as? OutgoingTextMessageTableViewCell
            cell?.transform = CGAffineTransform(scaleX: 1, y: -1)
            cell?.setupCell(message: dados)
            cell?.selectionStyle = .none
            return cell ?? UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let desc: String = self.listaMensagens[indexPath.row].texto ?? ""
        let font = UIFont(name: CustomFont.poppinsSemiBold, size: 14) ?? UIFont()
        let estimateHeight = desc.heightWithContrainedWidth(width: 220, font: font)
        return CGFloat(65 + estimateHeight)
    }
}

extension ChatViewController: ChatViewScreenProtocol {
    func actionPushMessage() {
        let message: String = chatScreen?.inputMessageTextField.text ?? ""
        if let idUsuarioDestinatario = contato?.id {
            let mensagem: Dictionary<String,Any> = [
                "idUsuario" : idUsuarioLogado ?? "",
                "texto" : message,
                "data" : FieldValue.serverTimestamp()
            ]
            salvarMensagem(idRemetente: idUsuarioLogado ?? "", idDestinatario: idUsuarioDestinatario, mensagem: mensagem)
            salvarMensagem(idRemetente: idUsuarioDestinatario, idDestinatario: idUsuarioLogado ?? "", mensagem: mensagem)
            
            var conversa: [String:Any] = ["ultimaMensagem": message]
            conversa["idRemetente"] = idUsuarioLogado ?? ""
            conversa["idDestinatario"] = idUsuarioDestinatario
            conversa["nomeUsuario"] = nomeContato ?? ""
            salvarConversa(idRemetente: idUsuarioLogado ?? "", idDestinatario: idUsuarioDestinatario, conversa: conversa)
            conversa["idRemetente"] = idUsuarioDestinatario
            conversa["idDestinatario"] = idUsuarioLogado ?? ""
            conversa["nomeUsuario"] = nomeUsuarioLogado ?? ""
            salvarConversa(idRemetente: idUsuarioDestinatario, idDestinatario: idUsuarioLogado ?? "", conversa: conversa)
        }
    }
}
