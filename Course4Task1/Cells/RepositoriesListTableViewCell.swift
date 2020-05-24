//
//  RepositoriesListTableViewCell.swift
//  Course4Task1
//

//

import UIKit
import Kingfisher

//Sets TableViewCell for search results table
class RepositoriesListTableViewCell: UITableViewCell {
    @IBOutlet weak var repNameLabel: UILabel!
    @IBOutlet weak var repDescriptionLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorAvatarImageView: UIImageView! {
        didSet {
            authorAvatarImageView.layoutIfNeeded()
            authorAvatarImageView.layer.cornerRadius = authorAvatarImageView.frame.size.width / 2
            authorAvatarImageView.clipsToBounds = true
        }
    }
    var repUrl: URL?
    
    public func setRepositoryShortInfoItem(_ repository: RepositoryShortInfo.Item) {
        repNameLabel.text = repository.name
        repDescriptionLabel.text = repository.description
        authorNameLabel.text = repository.owner.login
        authorAvatarImageView.kf.setImage(with: repository.owner.avatarUrl)
        repUrl = repository.htmlUrl
    }
    
}
