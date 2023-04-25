//
//  ChatNavigationView.swift
//  MessageViewCode
//
//  Created by Igor Fortti on 07/03/23.
//

import UIKit

class ChatNavigationView: UIView {
    
    var controller: ChatViewController? {
        didSet {
            backButton.addTarget(controller, action: #selector(ChatViewController.tappedBackButton), for: .touchUpInside)
        }
    }
    
    lazy var navBackGroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 35
        view.layer.maskedCorners = [.layerMaxXMaxYCorner]
        view.layer.shadowColor = UIColor(white: 0, alpha: 0.05).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 10)
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 10
        return view
    }()
    
    lazy var navBar: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var searchBar: UIView = {
        let view = UIView()
        view.backgroundColor = CustomColor.appLight
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        return view
    }()
    
    lazy var searchLabel: UILabel = {
        let label = UILabel()
        label.text = "Digite aqui"
        label.font = UIFont(name: CustomFont.poppinsMedium, size: 16)
        label.textColor = .lightGray
        return label
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "search"), for: .normal)
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "back"), for: .normal)
        button.contentMode = .scaleAspectFit
        return button
    }()
    
    lazy var customImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "imagem-perfil")
        image.clipsToBounds = true
        image.layer.cornerRadius = 26
        return image
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setupNavBackGroundViewConstraint()
        setupNavBarConstraint()
        setupCustomImageConstraint()
        setupBackButtonConstraint()
        setupSearchBarConstraint()
        setupSearchLabelConstraint()
        setupSearchButtonConstraint()
    }
    
    private func addViews() {
        addSubview(navBackGroundView)
        navBackGroundView.addSubview(navBar)
        navBar.addSubview(backButton)
        navBar.addSubview(customImage)
        navBar.addSubview(searchBar)
        searchBar.addSubview(searchLabel)
        searchBar.addSubview(searchButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNavBackGroundViewConstraint() {
        navBackGroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupNavBarConstraint() {
        navBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupBackButtonConstraint() {
        backButton.snp.makeConstraints { make in
            make.leading.equalTo(navBar.snp.leading).offset(20)
            make.centerY.equalTo(navBar.snp.centerY)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
    }
    
    private func setupCustomImageConstraint() {
        customImage.snp.makeConstraints { make in
            make.leading.equalTo(backButton.snp.trailing).offset(10)
            make.centerY.equalTo(navBar.snp.centerY)
            make.height.equalTo(55)
            make.width.equalTo(55)
        }
    }
    
    private func setupSearchBarConstraint() {
        searchBar.snp.makeConstraints { make in
            make.leading.equalTo(customImage.snp.trailing).offset(20)
            make.centerY.equalTo(navBar.snp.centerY)
            make.trailing.equalTo(navBar.snp.trailing).inset(20)
            make.height.equalTo(55)
        }
    }
    
    private func setupSearchLabelConstraint() {
        searchLabel.snp.makeConstraints { make in
            make.leading.equalTo(searchBar.snp.leading).offset(25)
            make.centerY.equalTo(searchBar.snp.centerY)
        }
    }
    
    private func setupSearchButtonConstraint() {
        searchButton.snp.makeConstraints { make in
            make.centerY.equalTo(searchBar.snp.centerY)
            make.trailing.equalTo(searchBar.snp.trailing).inset(20)
            make.height.equalTo(20)
            make.width.equalTo(20)
        }
    }
}
