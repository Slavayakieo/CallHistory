//
//  BottomSheetController.swift
//  CallHistory
//
//  Created by Viacheslav Yakymenko on 07.05.2022.
//

import UIKit

class BusinessInfoController: UIViewController {
    
    var viewModel: BottomSheetViewModelProtocol?
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Business number"
        label.font = .systemFont(ofSize: 13)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var clientLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel?.label
        label.font = .systemFont(ofSize: 17)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var phoneLabel: UILabel = {
        let label = UILabel()
        label.text = viewModel?.phone
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var seeThroughView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()
    
    let helperLayer = CAShapeLayer()
    var containerViewHeightConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(seeThroughView)
        view.addSubview(containerView)
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        containerViewHeightConstraint?.isActive = false
        UIView.animate(withDuration: 0.07) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupContainerViewLayers()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if touch?.view == self.seeThroughView {
            self.dismiss(animated: true)
            dissmissWithAnimation()
        }
    }
    
    func setupContainerViewLayers() {
        let path = UIBezierPath(roundedRect: containerView.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 16.0, height: 16.0))
        
        helperLayer.fillColor = UIColor.white.cgColor
        helperLayer.frame = containerView.layer.bounds
        helperLayer.path = path.cgPath

        containerView.layer.backgroundColor = UIColor.clear.cgColor
        containerView.layer.insertSublayer(helperLayer, at: 0)

        containerView.layer.masksToBounds = false
        helperLayer.masksToBounds = false
        helperLayer.shadowColor = UIColor.lightGray.cgColor
        helperLayer.shadowOffset = .zero
        helperLayer.shadowOpacity = 1
        helperLayer.shadowPath = path.cgPath
        helperLayer.shadowRadius = 4
    }

    
    private func dissmissWithAnimation() {
        containerViewHeightConstraint?.isActive = true
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.dismiss(animated: false)
        }
    }
    
    private func setupConstraints() {
        containerViewHeightConstraint =  containerView.heightAnchor.constraint(equalToConstant: 0)
        containerViewHeightConstraint?.isActive = true

        seeThroughView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(headerLabel)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(clientLabel)
        clientLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(phoneLabel)
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false

        let guide = self.view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            seeThroughView.topAnchor.constraint(equalTo: guide.topAnchor),
            seeThroughView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            seeThroughView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            seeThroughView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),

            containerView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),

            
            headerLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 28),
            headerLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),

            clientLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor),
            clientLabel.leadingAnchor.constraint(equalTo: headerLabel.leadingAnchor),
            
            phoneLabel.topAnchor.constraint(equalTo: clientLabel.bottomAnchor, constant: 4),
            phoneLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30),
            phoneLabel.leadingAnchor.constraint(equalTo: headerLabel.leadingAnchor),
        ])
    }
}


