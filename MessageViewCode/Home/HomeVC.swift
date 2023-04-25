//
//  HomeVC.swift
//  MessageViewCode
//
//  Created by Igor Fortti on 06/03/23.
//

import UIKit
import Firebase


class HomeVC: UIViewController {
    
    private var auth: Auth?
    private var db: Firestore?
    private var idUsuarioLogado: String?
    private var screenContact: Bool?
    private var emailUsuarioLogado: String?
    private var alert: Alert?
    private var homeScreen: HomeScreen?
    private var contato: ContatoController?
    private var listContact: [Contact] = []
    private var listaConversas: [Conversation] = []
    private var conversasListener: ListenerRegistration?
    
    override func loadView() {
        homeScreen = HomeScreen()
        view = self.homeScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = CustomColor.appLight
        configHomeView()
        configCollectionView()
        configAlert()
        configIdentifierFirebase()
        configContato()
        addListenerRecuperarConversa()
    }
    
    private func configHomeView() {
        homeScreen?.navView.delegate(delegate: self)
    }
    
    private func configCollectionView() {
        homeScreen?.collectionViewProtocols(delegate: self, dataSource: self)
    }
    
    private func configAlert() {
        alert = Alert(controller: self)
    }
    
    private func configIdentifierFirebase() {
        auth = Auth.auth()
        db = Firestore.firestore()
        
        if let currentUser = auth?.currentUser {
            idUsuarioLogado = currentUser.uid
            emailUsuarioLogado = currentUser.email
        }
    }
    
    private func configContato() {
        contato = ContatoController()
        contato?.delegate(delegate: self)
    }
    
    func addListenerRecuperarConversa() {
        if let idUsuarioLogado = auth?.currentUser?.uid {
            conversasListener = db?.collection("conversas").document(idUsuarioLogado).collection("ultimas_conversas").addSnapshotListener({ querSnapshot, error in
                if error == nil {
                    self.listaConversas.removeAll()
                    if let snapshot = querSnapshot {
                        for document in snapshot.documents {
                            let dados = document.data()
                            self.listaConversas.append(Conversation(dicionario: dados))
                        }
                        self.homeScreen?.reloadCollectionView()
                    }
                }
            })
        }
    }
    
    private func getContato(){
        listContact.removeAll()
        db?.collection("usuarios").document(self.idUsuarioLogado ?? "").collection("contatos").getDocuments(completion: { snapShotResultado, error in
            if error != nil {
                print("error getContato")
                return
            }
            if let snapshot = snapShotResultado {
                for document in snapshot.documents {
                    let dadosContato = document.data()
                    self.listContact.append(Contact(dicionario: dadosContato))
                }
                self.homeScreen?.reloadCollectionView()
            }
        })
    }
}

extension HomeVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if screenContact ?? false {
            return listContact.count + 1
        } else {
            return listaConversas.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if screenContact ?? false {
            if indexPath.row == listContact.count{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageLastCollectionViewCell.identifier, for: indexPath)
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageDetailCollectionViewCell.identifier, for: indexPath) as? MessageDetailCollectionViewCell
                cell?.setupViewContact(contact: listContact[indexPath.row])
                return cell ?? UICollectionViewCell()
            }
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageDetailCollectionViewCell.identifier, for: indexPath) as? MessageDetailCollectionViewCell
            cell?.setupViewConversation(conversation: listaConversas[indexPath.row])
            return cell ?? UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if screenContact ?? false {
            if indexPath.row == listContact.count {
                alert?.addContact(completion: { value in
                    self.contato?.addContact(email: value, emailUsuarioLogado: self.emailUsuarioLogado ?? "", idUsuario: self.idUsuarioLogado ?? "")
                })
            } else {
                let vc: ChatViewController = ChatViewController()
                vc.contato = listContact[indexPath.row]
                navigationController?.pushViewController(vc, animated: true)
            }
        } else {
            let vc: ChatViewController = ChatViewController()
            let dados = listaConversas[indexPath.row]
            let contato: Contact = Contact(id: dados.idDestinatario ?? "", nome: dados.nome ?? "")
            vc.contato = contato
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}

extension HomeVC:NavViewProtocol{
    
    func typeScreenMessage(type: TypeConversationOrContact) {
        switch type {
        case .contact:
            screenContact = true
            getContato()
            conversasListener?.remove()
        case .conversation:
            screenContact = false
            addListenerRecuperarConversa()
            homeScreen?.reloadCollectionView()
        }
    }
}


extension HomeVC:ContatoProtocol {
    func alertStateError(titulo: String, message: String) {
        alert?.getAlert(titulo: titulo, mensagem: message)
    }
    
    func successContato() {
        alert?.getAlert(titulo: "Ebaaaaaa", mensagem: "Usuario cadastrado com sucesso!!", completion: {
            self.getContato()
        })
    }
}
