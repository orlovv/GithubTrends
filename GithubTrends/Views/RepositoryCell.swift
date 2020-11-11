//
//  RepositoryCell.swift
//  GithubTrends
//
//  Created by Vladimir Orlov on 09.11.2020.
//

import UIKit
import Kingfisher

class RepositoryCell: UICollectionViewCell {
    
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var repoNameLabel: UILabel!
    @IBOutlet var repoAuthorLabel: UILabel!
    @IBOutlet var repoDescLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
    
    public func configure(with model: RepositoryModel) {
        repoNameLabel.text = model.repoName
        repoAuthorLabel.text = model.username
        repoDescLabel.text = model.repoDesc
        if let imageURL = model.avatar, let url = URL(string: imageURL) {
            logoImageView.kf.setImage(with: url)
        } else {
            logoImageView.image = nil
        }
    }
}
