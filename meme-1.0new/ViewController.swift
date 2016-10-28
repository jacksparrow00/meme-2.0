//
//  ViewController.swift
//  meme-1.0new
//
//  Created by Nitish on 23/10/16.
//  Copyright © 2016 Nitish. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.black,
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name : "HelveticaNeue-CondensedBlack",size: 40)!,
            NSStrokeWidthAttributeName : -3.0
        ] as [String : Any]
        
        topTextfield.defaultTextAttributes = memeTextAttributes
        bottomTextfield.defaultTextAttributes = memeTextAttributes
        
        self.topTextfield.delegate = self
        self.bottomTextfield.delegate = self
        
        topTextfield.textAlignment = .center
        bottomTextfield.textAlignment = .center
        topTextfield.text = "TOP"
        bottomTextfield.text = "BOTTOM"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
    }

    
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var bottomTextfield: UITextField!
    @IBOutlet weak var topTextfield: UITextField!
    @IBOutlet weak var imageView: UIImageView!

    @IBAction func pickAnImageFromAlbum(_ sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate=self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imageView.image = image
            dismiss(animated: true, completion: nil)
        }
        else{
            let alertController = UIAlertController()
            alertController.title = "Error"
            alertController.message = "Wrong photo selected. Please ensure you are selecting the right photo"
            
            let alertAction = UIAlertAction(title: "OK", style: .default){ action in self.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(alertAction)
            dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func pickAnImageFromCamera(_ sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "TOP" || textField.text == "BOTTOM"{
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

