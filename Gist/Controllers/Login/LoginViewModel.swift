//
//  LoginViewModel.swift
//  Gist
//
//  Created by Leonardo Leffa on 25/03/20.
//  Copyright © 2020 iMonster. All rights reserved.
//

import UIKit

class LoginViewModel: DefaultViewModel {
    var controller: UIViewController!
    
    init(_ controller: UIViewController) {
        super.init(controller, {})
        
        self.controller = controller;
        
        WebService.sharedInstance.githubLogged = { error in
            if error == nil {
                controller.performSegue(withIdentifier: "GistsTableViewController", sender: nil)
            }
        };
    }
    
    func getUrlGithub() -> URL {
        return WebService.sharedInstance.OAuthURL();
    }
}
