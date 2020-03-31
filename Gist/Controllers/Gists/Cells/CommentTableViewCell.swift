//
//  CommentTableViewCell.swift
//  Gist
//
//  Created by Leonardo Leffa on 30/03/20.
//  Copyright © 2020 iMonster. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var timeAgo: UILabel!
    @IBOutlet weak var commentGist: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setComment(_ gist: Comment){
        self.imgUser.downloaded(from: gist.user.avatar_url)
        self.nameUser.text = gist.user.login
        self.timeAgo.text = gist.created_at.timeAgo()
        self.commentGist.text = gist.body
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
