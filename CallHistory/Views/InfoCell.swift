//
//  CallCell.swift
//  CallHistory
//
//  Created by Viacheslav Yakymenko on 04.05.2022.
//

import UIKit

class InfoCell: UICollectionViewCell {
    
    lazy var callStatusImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()
    
    lazy var durationLabel: UILabel = {
        let durationLabel = UILabel()
        durationLabel.font = UIFont.italicSystemFont(ofSize: 13)
        durationLabel.textColor = UIColor(red: 0.376, green: 0.376, blue: 0.376, alpha: 1)
        durationLabel.numberOfLines = 1
        durationLabel.translatesAutoresizingMaskIntoConstraints = false

        return durationLabel
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont.boldSystemFont(ofSize: 17)
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        nameLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        return nameLabel
    }()
    
    lazy var phoneLabel: UILabel = {
        let phoneLabel = UILabel()
        phoneLabel.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        phoneLabel.numberOfLines = 1
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false

        return phoneLabel
    }()
    
    lazy var timeLabel: UILabel = {
        var timeLabel = UILabel()
        timeLabel.font = UIFont.systemFont(ofSize: 13)
        timeLabel.textColor = UIColor(red: 0.376, green: 0.376, blue: 0.376, alpha: 1)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        return timeLabel
    }()
    
    lazy var callerView = UIView()
    
    var viewModel: InfoCellViewModel? {
        didSet {
            self.loadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(callerView)
        contentView.addSubview(callStatusImageView)
        contentView.addSubview(durationLabel)
        contentView.addSubview(timeLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.shadowColor = UIColor.lightGray.cgColor
        contentView.layer.cornerRadius = 8
        contentView.layer.shadowOpacity = 1
        contentView.layer.shadowOffset = .zero
        contentView.layer.shadowPath = UIBezierPath(rect: contentView.bounds).cgPath
        contentView.layer.backgroundColor = UIColor.white.cgColor
    }
    
    func loadData() {
        
        callStatusImageView.image = viewModel?.statusImage
        durationLabel.text = viewModel?.duration
        phoneLabel.text = viewModel?.phone
        timeLabel.text = viewModel?.time
        
        callerView = buildCallerView()
    }
    
    func setupConstraints() {
        callerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            callStatusImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            callStatusImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            callStatusImageView.widthAnchor.constraint(equalToConstant: 40),
            callStatusImageView.heightAnchor.constraint(equalToConstant: 40),
            
            durationLabel.topAnchor.constraint(equalTo: callStatusImageView.bottomAnchor, constant: 12),
            durationLabel.centerXAnchor.constraint(equalTo: callStatusImageView.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            timeLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),

            callerView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            callerView.leftAnchor.constraint(equalTo: callStatusImageView.rightAnchor, constant: 16),
            callerView.rightAnchor.constraint(lessThanOrEqualTo: timeLabel.leftAnchor, constant: -16),
            callerView.heightAnchor.constraint(lessThanOrEqualTo: contentView.heightAnchor),
        ])
    }
    
    func buildCallerView() -> UIView {
        callerView.addSubview(phoneLabel)
        
        phoneLabel.leftAnchor.constraint(equalTo: callerView.leftAnchor).isActive = true
        phoneLabel.bottomAnchor.constraint(equalTo: callerView.bottomAnchor).isActive = true
        
        if let callerName = viewModel?.name {
            callerView.addSubview(nameLabel)
            
            nameLabel.text = callerName
            
            nameLabel.leftAnchor.constraint(equalTo: phoneLabel.leftAnchor).isActive = true
            nameLabel.topAnchor.constraint(equalTo: callerView.topAnchor).isActive = true
            nameLabel.widthAnchor.constraint(lessThanOrEqualTo: callerView.widthAnchor).isActive = true
            
            phoneLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0).isActive = true
            phoneLabel.font = UIFont.systemFont(ofSize: 17)
        } else {
            phoneLabel.font = UIFont.boldSystemFont(ofSize: 17)
            phoneLabel.topAnchor.constraint(equalTo: callerView.topAnchor).isActive = true
        }
        return callerView
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.removeFromSuperview()
        phoneLabel.removeFromSuperview()
    }

}
