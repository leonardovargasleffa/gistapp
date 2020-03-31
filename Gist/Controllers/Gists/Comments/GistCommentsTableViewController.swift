//
//  GistCommentsTableViewController.swift
//  Gist
//
//  Created by Leonardo Leffa on 30/03/20.
//  Copyright © 2020 iMonster. All rights reserved.
//

import UIKit

class GistCommentsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var gist: Gist!
    @IBOutlet var tableView: UITableView!
    var viewModel: GistCommentViewModel!
    var newComment: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableView.automaticDimension;
        self.tableView.estimatedRowHeight = 134.0;
        
        self.viewModel = GistCommentViewModel(self)
        self.viewModel.clearComments()
        self.getComments()
        
    }
    
    func getComments(){
        self.viewModel.getGistComment(self.gist, { reload in
            if reload {
                self.tableView.reloadData()
                
            } else {
                "There was a problem on get Comments".errorAlert(self)
            }
        })
    }

    func configurationTextField(textField: UITextField!) {
        if (textField) != nil {
            self.newComment = textField!        //Save reference to the UITextField
            self.newComment?.placeholder = "Comment...";
        }
    }
    
    func ask(_ index: IndexPath){
        let alert = UIAlertController(title: "Comment options", message: "What you do in this comment?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler:{ (UIAlertAction) in
            self.viewModel.deleteCommentGist(self.gist, self.viewModel.getComments()[index.row]) { (deleted) in
                if deleted {
                    self.viewModel.deleteComment(index)
                    self.tableView.reloadData()
                    
                } else {
                    "There was a problem on delete commenting".errorAlert(self)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler:{ (UIAlertAction) in
            self.alterComment(index)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func alterComment(_ index: IndexPath?) {
        let alert = UIAlertController(title: "New Comment", message: "Type our comment", preferredStyle: .alert)
        alert.addTextField(configurationHandler: configurationTextField)
        
        if index != nil {
            self.newComment!.text = self.viewModel.getComments()[index!.row].body
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
        alert.addAction(UIAlertAction(title: (index != nil ? "Save" : "Comment"), style: .default, handler:{ (UIAlertAction) in
            if let indexPath = index {
                self.viewModel.updateCommentGist(self.gist, self.viewModel.listComments[indexPath.row], self.newComment!.text!) { (comment) in
                    if comment != nil {
                        self.viewModel.setCommentIndex(comment!, indexPath)
                        self.tableView.reloadData()
                        
                    } else {
                        "There was a problem on update commenting".errorAlert(self)
                    }
                }
                
            } else {
                self.viewModel.commentGist(self.gist, self.newComment!.text!) { (comment) in
                    if comment != nil {
                        self.getComments()
                        
                    } else {
                        "There was a problem commenting".errorAlert(self)
                    }
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func alertNewComment() {
        self.alterComment(nil)
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.viewModel.getComments().count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CommentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
        cell.setComment(self.viewModel.getComments()[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(self.viewModel.user.id == self.viewModel.getComments()[indexPath.row].user.id){
            self.ask(indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastItem = self.viewModel.getComments().count - 1
        if indexPath.row == lastItem {
            if self.viewModel.getComments().count >= ((self.viewModel.page-1)*self.viewModel.perPage) {
                self.getComments()
            }
        }
    }

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
