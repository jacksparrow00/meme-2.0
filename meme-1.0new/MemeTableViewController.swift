//
//  MemeTableViewControllers.swift
//  meme-1.0new
//
//  Created by Nitish on 31/10/16.
//  Copyright © 2016 Nitish. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    @IBOutlet var generateTableView: UITableView!
    
    var memes:[Meme]{
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(MemeTableViewController.add))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        generateTableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableView")
        let meme = self.memes[indexPath.row]
        cell?.textLabel?.text = meme.topText
        cell?.imageView?.image = meme.memedImage
        
        if let detailTextLabel = cell?.detailTextLabel{
            detailTextLabel.text = meme.bottomText
        }
        return cell!
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailViewController.memesdetail = self.memes[indexPath.row]
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func add(){
        let editorViewController = self.storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        self.navigationController?.pushViewController(editorViewController, animated: true)
    }
}
