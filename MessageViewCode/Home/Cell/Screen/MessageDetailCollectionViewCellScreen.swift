//
//  MessageDetailCollectionViewCellScreen.swift
//  MessageViewCode
//
//  Created by Igor Fortti on 06/03/23.
//

import UIKit

class MessageDetailCollectionViewCellScreen: UIView {

    lazy var userImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "imagem-perfil")
        image.clipsToBounds = true
        image.layer.cornerRadius = 26
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addviews()
        setupUserImageViewConstraint()
        setupUserNameLabelConstraint()
    }
    
    private func addviews() {
        addSubview(userImageView)
        addSubview(userNameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUserImageViewConstraint() {
        userImageView.snp.makeConstraints { make in
            make.leading.equalTo(snp.leading).offset(30)
            make.centerY.equalTo(snp.centerY)
            make.height.equalTo(55)
            make.width.equalTo(55)        }
    }
    
    private func setupUserNameLabelConstraint() {
        userNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(snp.centerY)
            make.leading.equalTo(userImageView.snp.trailing).offset(15)
            make.trailing.equalTo(snp.trailing).inset(30)
        }
    }
}
