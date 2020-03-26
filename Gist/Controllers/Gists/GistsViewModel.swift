//
//  GistsViewModel.swift
//  Gist
//
//  Created by Leonardo Leffa on 25/03/20.
//  Copyright © 2020 iMonster. All rights reserved.
//

import UIKit

class GistsViewModel: DefaultViewModel {
    
    var user: User!
    
    init(_ controller: UIViewController) {
        super.init(controller, {
            if let nav = controller.navigationController {
                nav.dismiss(animated: true, completion: nil)
            }
        })
        
        self.getUser { (usr) in
            if(usr == nil){
                self.logoff()
            } else {
                self.user = usr;
            }
        }
    }
    
    func getUser(_ user: @escaping ((_ usr: User?) -> Void)) {
        WebService.sharedInstance.getGitHubUserData().subscribe(onNext: { [weak self] (start) in
                user(start)
        }, onError: { (error) in
                user(nil)
        }).disposed(by: self.disposeBag)
    }
}
