//
//  LoginViewController.swift
//  Gist
//
//  Created by Leonardo Leffa on 25/03/20.
//  Copyright © 2020 iMonster. All rights reserved.
//

import UIKit
import SafariServices

class LoginViewController: UIViewController, SFSafariViewControllerDelegate {
    var viewModel: LoginViewModel!
    var safariViewController: SFSafariViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = LoginViewModel(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(WebService.sharedInstance.loggedIn()){
            self.performSegue(withIdentifier: "GistsTableViewController", sender: nil)
        }
    }

    @IBAction func didTapLoginButton() {
        UIApplication.shared.open(self.viewModel.getUrlGithub())
    }
    
}

