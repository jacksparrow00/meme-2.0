//
//  MemeCollectionViewController.swift
//  meme-1.0new
//
//  Created by Nitish on 31/10/16.
//  Copyright © 2016 Nitish. All rights reserved.
//

import UIKit

class MemeCollectionViewController : UICollectionViewController{
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var memes: [Meme]{
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(MemeCollectionViewController.add))            //add button on right side of navigation controller
        
        let space:CGFloat = 3.0                                                 //resize cell according to device
        let cellWidth = (self.view.frame.size.width-(2*space))/3.0
        let cellHeight = (self.view.frame.size.height-(2*space))/3.0
        
        flowLayout.minimumLineSpacing = 1.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false               //due to a bug
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        flowLayout.collectionView?.reloadData()                             //refresh data
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailViewController.memesdetail = self.memes[indexPath.row]
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionView", for: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[indexPath.row]
        cell.seeImage.image = meme.memedImage
        return cell
    }
    
    func add(){
        let editorViewController = self.storyboard?.instantiateViewController(withIdentifier: "MemeEditorViewController") as! MemeEditorViewController
        self.navigationController?.present(editorViewController, animated: true, completion: nil)
    }
}
