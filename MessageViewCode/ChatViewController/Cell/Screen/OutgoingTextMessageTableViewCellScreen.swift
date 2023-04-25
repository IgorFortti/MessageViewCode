//
//  OutgoingTextMessageTableViewCellScreen.swift
//  MessageViewCode
//
//  Created by Igor Fortti on 07/03/23.
//

import UIKit

class OutgoingTextMessageTableViewCellScreen: UIView {

    lazy var myMessageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = CustomColor.appPurple
        view.layer.cornerRadius = 20
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner, .layerMaxXMinYCorner]
        return view
    }()
    
    lazy var messageTextLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .white
        label.font = UIFont(name: CustomFont.poppinsSemiBold, size: 14)
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
        addSubview(myMessageView)
        myMessageView.addSubview(messageTextLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupContactMessageContraint() {
        myMessageView.snp.makeConstraints { make in
            make.trailing.equalTo(snp.trailing).inset(20)
            make.top.equalTo(snp.top).offset(10)
            make.width.lessThanOrEqualTo(250)
        }
    }
    
    private func setupMessageTextLabelContraint() {
        messageTextLabel.snp.makeConstraints { make in
            make.leading.equalTo(myMessageView.snp.leading).offset(15)
            make.top.equalTo(myMessageView.snp.top).offset(15)
            make.trailing.equalTo(myMessageView.snp.trailing).inset(15)
            make.bottom.equalTo(myMessageView.snp.bottom).inset(15)
        }
    }
}
