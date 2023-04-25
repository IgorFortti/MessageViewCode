//
//  OutgoingTextMessageTableViewCell.swift
//  MessageViewCode
//
//  Created by Igor Fortti on 07/03/23.
//

import UIKit

class OutgoingTextMessageTableViewCell: UITableViewCell {
    
    static let identifier: String = String(describing: OutgoingTextMessageTableViewCell.self)
    
    lazy var screenCell: OutgoingTextMessageTableViewCellScreen = {
        let screen = OutgoingTextMessageTableViewCellScreen()
        return screen
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        isSelected = false
        addViews()
        setupScreenCellConstraint()
    }
    
    public func setupCell(message: Message?) {
        self.screenCell.messageTextLabel.text = message?.texto ?? ""
    }
    
    private func addViews() {
        contentView.addSubview(screenCell)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupScreenCellConstraint() {
        screenCell.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
