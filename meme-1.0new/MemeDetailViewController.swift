//
//  MemeDetailViewController.swift
//  meme-1.0new
//
//  Created by Nitish on 31/10/16.
//  Copyright © 2016 Nitish. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet weak var detailImageView: UIImageView!
    
    var memesdetail:Meme!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(MemeDetailViewController.edit))

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.detailImageView.image = memesdetail.memedImage
    }
    
    func edit(){
        let editorViewController = self.storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        present(editorViewController, animated: true, completion: nil)
    }
    
}
