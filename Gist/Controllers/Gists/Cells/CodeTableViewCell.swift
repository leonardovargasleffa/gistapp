//
//  CodeTableViewCell.swift
//  Gist
//
//  Created by Leonardo Leffa on 30/03/20.
//  Copyright © 2020 iMonster. All rights reserved.
//

import UIKit
import Alamofire

class CodeTableViewCell: UITableViewCell {

    @IBOutlet var code: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setFile(_ file: Files){
        do {
            let attrStr = try NSAttributedString(
                data: (file.content != nil ? file.content : "")!.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                options: [:],
                documentAttributes: nil)
            self.code.attributedText = attrStr
        } catch let _ {
            
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
