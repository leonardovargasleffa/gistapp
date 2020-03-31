//
//  GistTableViewCell.swift
//  Gist
//
//  Created by Leonardo Leffa on 30/03/20.
//  Copyright © 2020 iMonster. All rights reserved.
//

import UIKit

class GistTableViewCell: UITableViewCell {

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var nameUser: UILabel!
    @IBOutlet weak var nameFile: UILabel!
    @IBOutlet weak var timeAgo: UILabel!
    @IBOutlet weak var descGist: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setGist(_ gist: Gist){
        self.imgUser.downloaded(from: gist.owner.avatar_url)
        self.nameUser.text = gist.owner.login
        self.nameFile.text = (gist.files != nil ? gist.files!.keys.first ?? "" : "")
        self.timeAgo.text = gist.created_at.timeAgo()
        self.descGist.text = gist.description
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
