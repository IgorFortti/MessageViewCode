//
//  MessageLastCollectionViewCell.swift
//  MessageViewCode
//
//  Created by Igor Fortti on 06/03/23.
//

import UIKit

class MessageLastCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = String(describing: MessageLastCollectionViewCell.self)
    
    lazy var screen: MessageLastCollectionViewCellScreen = {
        let screen = MessageLastCollectionViewCellScreen()
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
    
    private func setupScreenConstraint() {
        screen.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
