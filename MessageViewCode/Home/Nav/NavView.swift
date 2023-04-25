//
//  NavView.swift
//  MessageViewCode
//
//  Created by Igor Fortti on 06/03/23.
//

import UIKit

enum TypeConversationOrContact {
    case conversation
    case contact
}

protocol NavViewProtocol: AnyObject {
    func typeScreenMessage(type: TypeConversationOrContact)
}

class NavView: UIView {
    
    weak private var delegate: NavViewProtocol?
    
    func delegate(delegate: NavViewProtocol?) {
        self.delegate = delegate
    }
    
    lazy var navBackGroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 35
        view.layer.maskedCorners = [.layerMaxXMaxYCorner]
        view.layer.shadowColor = UIColor(white: 0, alpha: 0.02).cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
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
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.spacing = 10
        return stack
    }()
    
    lazy var conversationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "message")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(tappedConversationButton), for: .touchUpInside)
        return button
    }()
    
    lazy var contactButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "group")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(tappedContactButton), for: .touchUpInside)
        return button
    }()
    
    @objc func tappedConversationButton() {
        delegate?.typeScreenMessage(type: .conversation)
        conversationButton.tintColor = .systemPink
        contactButton.tintColor = .black
    }
    
    @objc func tappedContactButton() {
        delegate?.typeScreenMessage(type: .contact)
        conversationButton.tintColor = .black
        contactButton.tintColor = .systemPink
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setupNavBackGroundViewConstraint()
        setupNavBarConstraint()
        setupSearchBarConstraint()
        setupStackViewConstraint()
        setupSearchLabelConstraint()
        setupSearchButtonConstraint()
    }
    
    private func addViews() {
        addSubview(navBackGroundView)
        navBackGroundView.addSubview(navBar)
        navBar.addSubview(searchBar)
        navBar.addSubview(stackView)
        searchBar.addSubview(searchLabel)
        searchBar.addSubview(searchButton)
        stackView.addArrangedSubview(conversationButton)
        stackView.addArrangedSubview(contactButton)
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
    
    private func setupSearchBarConstraint() {
        searchBar.snp.makeConstraints { make in
            make.centerY.equalTo(navBar.snp.centerY)
            make.leading.equalTo(navBar.snp.leading).offset(30)
            make.trailing.equalTo(stackView.snp.leading).inset(-20)
            make.height.equalTo(55)
        }
    }
    
    private func setupStackViewConstraint() {
        stackView.snp.makeConstraints { make in
            make.trailing.equalTo(navBar.snp.trailing).inset(30)
            make.centerY.equalTo(navBar.snp.centerY)
            make.width.equalTo(100)
            make.height.equalTo(30)
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
            make.trailing.equalTo(searchBar.snp.trailing).inset(20)
            make.centerY.equalTo(searchBar.snp.centerY)
            make.width.equalTo(18)
            make.height.equalTo(18)
        }
    }
}
