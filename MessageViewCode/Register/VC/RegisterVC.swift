//
//  RegisterVC.swift
//  AppViewCodeCurso
//
//  Created by Igor Fortti on 02/03/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterVC: UIViewController {
    
    private var screen: RegisterScreen?
    private var auth: Auth?
    private var firestore: Firestore?
    private var alert: Alert?
    
    override func loadView() {
        screen = RegisterScreen()
        view = screen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screen?.delegate(delegate: self)
        screen?.textFieldDelegate(delegate: self)
        auth = Auth.auth()
        firestore = Firestore.firestore()
        alert = Alert(controller: self)
    }
}

extension RegisterVC: RegisterScreenProtocol {
    func registerButtonTapped() {
        guard let screen = screen else { return }
        auth?.createUser(withEmail: screen.getEmail(), password: screen.getPassword(), completion: { (result, error) in
            if error != nil {
                self.alert?.getAlert(titulo: "Atenção", mensagem: "Tente novamente mais tarde", completion: {
                    self.navigationController?.popViewController(animated: true)
                })
            } else {
                if let idUsuario = result?.user.uid {
                    self.firestore?.collection("usuarios").document(idUsuario).setData([
                        "nome": screen.getName(),
                        "email": screen.getEmail(),
                        "id": idUsuario,
                    ])
                }
                self.alert?.getAlert(titulo: "Cadastro concluído", mensagem: "Por gentilza, realize o Login", completion: {
                    let homeVC = HomeVC()
                    let navVC = UINavigationController(rootViewController: homeVC)
                    navVC.modalPresentationStyle = .fullScreen
                    self.present(navVC, animated: true)
                })
            }
        })
    }
    
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension RegisterVC: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        screen?.validateTextFields()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
