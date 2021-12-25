//
//  IGFeedPostHeaderTableViewCell.swift
//  Instagram
//
//  Created by aleksandar on 16.12.21..
//

import UIKit
import SDWebImage

protocol IGFeedPostHeaderTableViewCellDelegate: AnyObject {
    func didTapMoreButton()
}

class IGFeedPostHeaderTableViewCell: UITableViewCell {

    static let identifier = "IGFeedPostHeaderTableViewCell"
    
    weak var delegate: IGFeedPostHeaderTableViewCellDelegate?
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .medium)
        
        return label
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(profileImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(moreButton)
        moreButton.addTarget(
            self,
            action: #selector(didTapMoreButton),
            for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = contentView.height - 4
        profileImageView.frame = CGRect(
            x: 2,
            y: 2,
            width: size,
            height: size)
        profileImageView.layer.cornerRadius = size / 2
        moreButton.frame = CGRect(
            x: contentView.width - size,
            y: 2,
            width: size,
            height: size)
        usernameLabel.frame = CGRect(
            x: profileImageView.right + 10,
            y: 2,
            width: contentView.width - (size * 2),
            height: contentView.height - 4)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        usernameLabel.text = nil
        profileImageView.image = nil
    }
    
    //MARK: - Actions
    
    @objc func didTapMoreButton() {
        delegate?.didTapMoreButton()
    }
    
    //MARK: - Methods
    
    public func configure(with model: User) {
        usernameLabel.text = model.username
        profileImageView.image = UIImage(systemName: "person.circle")
        //profileImageView.sd_setImage(with: model.profilePicture, completed: nil)
    }
}
