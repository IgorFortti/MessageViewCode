//
//  IncomingTextMessageTableViewCellScreen.swift
//  MessageViewCode
//
//  Created by Igor Fortti on 07/03/23.
//

import UIKit

class IncomingTextMessageTableViewCellScreen: UIView {
    
    lazy var contactMessage: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0, alpha: 0.06)
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMinYCorner]
        return view
    }()
    
    lazy var messageTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .darkGray
        label.font = UIFont(name: CustomFont.poppinsMedium, size: 14)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = CustomColor.appLight
        addViews()
        setupContactMessageContraint()
        setupMessageTextLabelContraint()
    }
    
    private func addViews() {
        addSubview(contactMessage)
        contactMessage.addSubview(messageTextLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContactMessageContraint() {
        contactMessage.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading).offset(20)
            make.top.equalTo(snp.top).offset(10)
            make.width.lessThanOrEqualTo(250)
        }
    }
    
    private func setupMessageTextLabelContraint() {
        messageTextLabel.snp.makeConstraints { make in
            make.leading.equalTo(contactMessage.snp.leading).offset(15)
            make.top.equalTo(contactMessage.snp.top).offset(15)
            make.trailing.equalTo(contactMessage.snp.trailing).inset(15)
            make.bottom.equalTo(contactMessage.snp.bottom).inset(15)
        }
    }
}
