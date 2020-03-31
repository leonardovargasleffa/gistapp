//
//  LoginViewModel.swift
//  Gist
//
//  Created by Leonardo Leffa on 25/03/20.
//  Copyright © 2020 iMonster. All rights reserved.
//

import UIKit

class LoginViewModel: DefaultViewModel {
    init(_ controller: UIViewController) {
        super.init(controller, {})
        WebService.sharedInstance.githubLogged = { error in
            if error == nil {
                self.controller.performSegue(withIdentifier: "GistsTableViewController", sender: nil)
            }
        };
    }
    
    func getUrlGithub() -> URL {
        return WebService.sharedInstance.OAuthURL();
    }
}
