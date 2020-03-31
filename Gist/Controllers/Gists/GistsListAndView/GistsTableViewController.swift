//
//  GistsTableViewController.swift
//  Gist
//
//  Created by Leonardo Leffa on 25/03/20.
//  Copyright © 2020 iMonster. All rights reserved.
//

import UIKit

class GistsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    var viewModel: GistsViewModel!
    var publicGists: Bool = true
    var listGists: [Gist] = []
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.receiveGistID(notification:)), name: Notification.Name("receiveGistID"), object: nil)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("receiveGistID"), object: nil)
    }
    
    @objc func receiveGistID(notification: Notification) {
        self.performSegue(withIdentifier: "GistViewController", sender: (notification.object as! String))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = 134.0;
        
        self.viewModel = GistsViewModel(self)
        self.viewModel.clearGists();
        self.getGists()
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func getGists(){
        self.viewModel.getGists(self.publicGists, { reload in
            self.tableView.reloadData()
        })
    }
    
    @IBAction func selectGists(_ sender: UISegmentedControl) {
        self.publicGists = (sender.selectedSegmentIndex == 0)
        self.viewModel.clearGists();
        self.getGists()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.listGists.count
    }
    
    @IBAction func sair(){
        self.viewModel.logoff()
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GistTableViewCell = tableView.dequeueReusableCell(withIdentifier: "GistTableViewCell", for: indexPath) as! GistTableViewCell
        cell.setGist(self.viewModel.listGists[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastItem = self.viewModel.listGists.count - 1
        if indexPath.row == lastItem {
            if self.viewModel.listGists.count >= (self.viewModel.page*self.viewModel.perPage) {
                self.getGists()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gist: Gist = self.viewModel.listGists[indexPath.row]
        if gist.files != nil {
            self.performSegue(withIdentifier: "GistViewController", sender: gist.id)
            
        } else {
            let alert = UIAlertController(title: "Ops!", message: "This gist has no files!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation*/
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "GistViewController"){
            let vc: GistViewController = segue.destination as! GistViewController
            vc.gistid = (sender as! String)
        }
    }
    

}
