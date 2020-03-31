//
//  GistViewController.swift
//  Gist
//
//  Created by Leonardo Leffa on 30/03/20.
//  Copyright © 2020 iMonster. All rights reserved.
//

import UIKit

class GistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var gistid: String!
    var gist: Gist?
    @IBOutlet var tableView: UITableView!
    var viewModel: GistsViewModel!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = 134.0;
        
        self.viewModel = GistsViewModel(self)
        self.viewModel.getGist(self.gistid, { gist in
            if let gistGet = gist {
                self.gist = gistGet
                self.tableView.reloadData()
            }
        })
        // Do any additional setup after loading the view.
    }
    

    @IBAction func viewComments(_ sender: Any) {
        self.performSegue(withIdentifier: "GistCommentsTableViewController", sender: nil)
    }
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return (self.gist != nil ? self.gist!.files!.keys.count : 0)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (self.gist != nil ? Array(self.gist!.files!.keys)[section] : "")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CodeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CodeTableViewCell", for: indexPath) as! CodeTableViewCell
        if(self.gist != nil){
            cell.setFile(self.gist!.files![Array(self.gist!.files!.keys)[indexPath.section]]!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "GistCommentsTableViewController"){
            let vc: GistCommentsTableViewController = segue.destination as! GistCommentsTableViewController
            vc.gist = self.gist
        }
    }

}
