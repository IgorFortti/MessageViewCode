//
//  ChatViewScreen.swift
//  MessageViewCode
//
//  Created by Igor Fortti on 07/03/23.
//

import UIKit
import AVFoundation
import SnapKit

protocol ChatViewScreenProtocol: AnyObject {
    func actionPushMessage()
}

class ChatViewScreen: UIView {
    
    weak private var delegate: ChatViewScreenProtocol?
    
    public func delegate(delegate: ChatViewScreenProtocol?) {
        self.delegate = delegate
    }
    
    var bottomContraint: NSLayoutConstraint?
    var player: AVAudioPlayer?
    
    lazy var navView: ChatNavigationView = {
        let view = ChatNavigationView()
        return view
    }()
    
    lazy var messageInputView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    lazy var messageBar: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColor.appLight
        view.layer.cornerRadius = 20
        return view
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 22.5
        button.layer.shadowColor = CustomColor.appPink.cgColor
        button.layer.shadowRadius = 10
        button.layer.shadowOffset = CGSize(width: 0, height: 5)
        button.layer.shadowOpacity = 0.3
        button.backgroundColor = CustomColor.appPink
        button.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        button.setImage(UIImage(named: "send"), for: .normal)
        return button
    }()
    
    lazy var inputMessageTextField: UITextField = {
        let textField = UITextField()
        textField.delegate = self
        textField.textColor = .darkGray
        textField.font = UIFont(name: CustomFont.poppinsSemiBold, size: 14)
        textField.attributedPlaceholder = NSAttributedString(string: "Digite aqui", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        return textField
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(IncomingTextMessageTableViewCell.self, forCellReuseIdentifier: IncomingTextMessageTableViewCell.identifier)
        tableView.register(OutgoingTextMessageTableViewCell.self, forCellReuseIdentifier: OutgoingTextMessageTableViewCell.identifier)
        tableView.backgroundColor = .clear
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()

        return tableView
    }()
    
    public func configTableView(delegate: UITableViewDelegate, dataSource: UITableViewDataSource) {
        tableView.delegate = delegate
        tableView.dataSource = dataSource
    }
    
    public func reloadTableView() {
        tableView.reloadData()
    }
    
    public func configNavView(controller: ChatViewController) {
        navView.controller = controller
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = CustomColor.appLight
        addViews()
        setupNavViewContraint()
        setuptableViewContraint()
        setupMessageInputContraint()
        setupMessageBarContraint()
        setupInputMessageTextFieldContraint()
        setupSendButtonContraint()
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        inputMessageTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        bottomContraint = NSLayoutConstraint(item: messageInputView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
        addConstraint(bottomContraint ?? NSLayoutConstraint())
        sendButton.isEnabled = false
        sendButton.layer.opacity = 0.4
        sendButton.transform = .init(scaleX: 0.8, y: 0.8)
        inputMessageTextField.becomeFirstResponder()
    }
    
    private func addViews() {
        addSubview(tableView)
        addSubview(navView)
        addSubview(messageInputView)
        messageInputView.addSubview(messageBar)
        messageBar.addSubview(sendButton)
        messageBar.addSubview(inputMessageTextField)
    }
    
    @objc func sendButtonTapped() {
        sendButton.touchAnimation(s: self.sendButton)
        delegate?.actionPushMessage()
        startPushMessage()
        playSound()
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "send", withExtension: "wav") else { return }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            self.player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)
            guard let player = self.player else { return }
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    public func startPushMessage() {
        inputMessageTextField.text = ""
        sendButton.isEnabled = false
        sendButton.layer.opacity = 0.4
        sendButton.transform = .init(scaleX: 0.8, y: 0.8)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNavViewContraint() {
        navView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(140)
        }
    }
    
    private func setuptableViewContraint() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(messageInputView.snp.top)
        }
    }
    
    private func setupMessageInputContraint() {
        messageInputView.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(80)
        }
    }
    
    private func setupMessageBarContraint() {
        messageBar.snp.makeConstraints { make in
            make.leading.equalTo(messageInputView.snp.leading).offset(20)
            make.trailing.equalTo(messageInputView.snp.trailing).inset(20)
            make.centerY.equalTo(messageInputView.snp.centerY)
            make.height.equalTo(55)
        }
    }
    
    private func setupInputMessageTextFieldContraint() {
        inputMessageTextField.snp.makeConstraints { make in
            make.leading.equalTo(messageBar.snp.leading).offset(20)
            make.trailing.equalTo(sendButton.snp.leading).inset(5)
            make.centerY.equalTo(messageBar.snp.centerY)
            make.height.equalTo(45)
        }
    }
    
    private func setupSendButtonContraint() {
        sendButton.snp.makeConstraints { make in
            make.trailing.equalTo(messageBar.snp.trailing)
            make.bottom.equalTo(messageBar.snp.bottom)
            make.top.equalTo(messageBar.snp.top)
            make.width.equalTo(55)
        }
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification){
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            self.bottomContraint?.constant = isKeyboardShowing ? -keyboardHeight : 0
            self.tableView.center.y = isKeyboardShowing ? self.tableView.center.y-keyboardHeight : self.tableView.center.y+keyboardHeight
            UIView.animate(withDuration:0.1, delay: 0 , options: .curveEaseOut , animations: {
                self.layoutIfNeeded()
            } , completion: {(completed) in
            })
        }
    }
}

extension ChatViewScreen: UITextFieldDelegate {
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if self.inputMessageTextField.text == ""{
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.sendButton.isEnabled = false
                self.sendButton.layer.opacity = 0.4
                self.sendButton.transform = .init(scaleX: 0.8, y: 0.8)
            }, completion: { _ in
            })
        }
        else {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.sendButton.isEnabled = true
                self.sendButton.layer.opacity = 1
                self.sendButton.transform = .identity
            }, completion: { _ in
            })
        }
    }
}
