//
//  MessageDetailCollectionViewCell.swift
//  MessageViewCode
//
//  Created by Igor Fortti on 06/03/23.
//

import UIKit

class MessageDetailCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = String(describing: MessageDetailCollectionViewCell.self)
    
    lazy var screen: MessageDetailCollectionViewCellScreen = {
        let screen = MessageDetailCollectionViewCellScreen()
        return screen
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(screen)
        setupScreenConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViewContact(contact: Contact) {
        self.setUserName(userName: contact.nome ?? "")
    }
    
    func setupViewConversation(conversation: Conversation) {
        self.setUserNameAttributedText(conversation)
    }
    
    func setUserNameAttributedText(_ conversation: Conversation) {
        let attributedText = NSMutableAttributedString(string: "\(conversation.nome ?? "")", attributes: [NSAttributedString.Key.font : UIFont(name: CustomFont.poppinsMedium, size: 16) ?? UIFont(), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        attributedText.append(NSAttributedString(string: "\n\(conversation.ultimaMensagem ?? "")",
        attributes: [NSAttributedString.Key.font : UIFont(name: CustomFont.poppinsMedium, size: 14) ?? UIFont(), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        self.screen.userNameLabel.attributedText = attributedText
    }
    
    func setUserName(userName: String) {
        let attributText = NSMutableAttributedString(string: userName, attributes: [NSAttributedString.Key.font : UIFont(name: CustomFont.poppinsMedium, size: 16) ?? UIFont(), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        self.screen.userNameLabel.attributedText = attributText
    }
    
    private func setupScreenConstraint() {
        screen.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
