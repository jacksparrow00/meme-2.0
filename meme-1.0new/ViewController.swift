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
        loadThisView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        
        if imageView.image != nil{
            shareButton.isEnabled = true
        }else{
            shareButton.isEnabled = false
        }
        subscribeToKeyboardNotification()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var bottomTextfield: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
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
    
    func keyboardWillShow(notification: NSNotification){
        if view.frame.origin.y == 0 && bottomTextfield.isFirstResponder{
            self.view.frame.origin.y = getKeyboardHeight(notification: notification) * (-1)
        }else if topTextfield.isFirstResponder{
            resetFrame()                //credits:- https://discussions.udacity.com/t/better-way-to-shift-the-view-for-keyboardwillshow-and-keyboardwillhide/36558/6
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        if bottomTextfield.isFirstResponder{
            resetFrame()
        }
    }
    
    func subscribeToKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    func getKeyboardHeight(notification:NSNotification) -> CGFloat{
        let userInfo=notification.userInfo
        let keyboardSize=userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func resetFrame(){
        if view.frame.origin.y != 0{
        self.view.frame.origin.y = 0
        }
    }
    
    func save(){
        let meme = Meme(topText: topTextfield.text!, bottomText: bottomTextfield.text!, image: imageView.image!, memedImage: generateMemedImage())
    }
    
    func generateMemedImage() -> UIImage{
        hideToolandNavbar()
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        showToolbar()
        
        return memedImage
    }
    
    func hideToolandNavbar(){
        self.topToolbar.isHidden = true
        self.bottomToolbar.isHidden = true
    }
    
    func showToolbar(){
        self.topToolbar.isHidden = false
        self.bottomToolbar.isHidden = false
    }
    
    @IBAction func shareAction(_ sender: AnyObject) {
        let image = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.present(controller, animated: true, completion: nil)
        controller.completionWithItemsHandler = {
            activity, success, items, error in
            if success{
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    @IBAction func cancelAction(_ sender: AnyObject) {
        loadThisView()
    }
    
    func loadThisView(){
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.black,
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name : "HelveticaNeue-CondensedBlack",size: 40)!,
            NSStrokeWidthAttributeName : -3.0
            ] as [String : Any]
        
        topTextfield.defaultTextAttributes = memeTextAttributes
        bottomTextfield.defaultTextAttributes = memeTextAttributes
        imageView.image = nil
        
        self.topTextfield.delegate = self
        self.bottomTextfield.delegate = self
        
        topTextfield.textAlignment = .center
        bottomTextfield.textAlignment = .center
        topTextfield.text = "TOP"
        bottomTextfield.text = "BOTTOM"
    }
}
