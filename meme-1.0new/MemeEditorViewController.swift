//
//  MemeEditorViewController.swift
//  meme-1.0new
//
//  Created by Nitish on 23/10/16.
//  Copyright © 2016 Nitish. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomTextfield: UITextField!
    @IBOutlet weak var topTextfield: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    var sourceType:UIImagePickerControllerSourceType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.black,
            NSForegroundColorAttributeName : UIColor.white,
            NSFontAttributeName : UIFont(name : "HelveticaNeue-CondensedBlack",size: 40)!,
            NSStrokeWidthAttributeName : -3.0
            ] as [String : Any]
        
        imageView.image = nil
        
        func attributeAssign(textfield : UITextField){
            textfield.delegate = self
            textfield.defaultTextAttributes = memeTextAttributes
            textfield.textAlignment = .center
        }
        
        attributeAssign(textfield: topTextfield)
        attributeAssign(textfield: bottomTextfield)
        
        topTextfield.text = "TOP"
        bottomTextfield.text = "BOTTOM"
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)                //find whether the camera is available or not
        
        if imageView.image != nil{                                      //enabling and disabling sharing button
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
    
   
    
    @IBAction func pickAnImageFromAlbum(_ sender: AnyObject) {                  //image picking from album
       
       sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePickerMethod(source: sourceType)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {         //select image from album
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
    @IBAction func pickAnImageFromCamera(_ sender: AnyObject) {             //launch the camera and get a picture
        sourceType = UIImagePickerControllerSourceType.camera
        imagePickerMethod(source: sourceType)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {               //removing "top" and "Bottom" when editing
        if textField.text == "TOP" || textField.text == "BOTTOM"{
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {              //keyboard hides when return key entered
        view.endEditing(true)
        return true
    }
    
    func keyboardWillShow(notification: NSNotification){                    //shift the frame and show keyboard
        if view.frame.origin.y == 0 && bottomTextfield.isFirstResponder{
            self.view.frame.origin.y = getKeyboardHeight(notification: notification) * (-1)
        }else if topTextfield.isFirstResponder{
            resetFrame()                //credits:- https://discussions.udacity.com/t/better-way-to-shift-the-view-for-keyboardwillshow-and-keyboardwillhide/36558/6
        }
    }
    
    func keyboardWillHide(notification: NSNotification){                        //hide the keyboard and reset the frame
        if bottomTextfield.isFirstResponder{
            resetFrame()
        }
    }
    
    func subscribeToKeyboardNotification(){                             //subscribe to keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications(){                          //unsubscribe to keyboard notification
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    func getKeyboardHeight(notification:NSNotification) -> CGFloat{
        let userInfo=notification.userInfo
        let keyboardSize=userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func resetFrame(){
        self.view.frame.origin.y = 0
    }
    
    func save(){                            //save the newly created meme
        let meme = Meme(topText: topTextfield.text!, bottomText: bottomTextfield.text!, image: imageView.image!, memedImage: generateMemedImage())
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage{
        configureBars(hidden: true)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        configureBars(hidden: false)
        
        return memedImage
    }
    
    func configureBars(hidden: Bool){
        topToolbar.isHidden = hidden
        bottomToolbar.isHidden = hidden
    }
    
    @IBAction func shareAction(_ sender: AnyObject) {                       //function of share button and saving the meme
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
    @IBAction func cancelAction(_ sender: AnyObject) {                      //function of cancel button
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func imagePickerMethod(source: UIImagePickerControllerSourceType){
         let imagePicker = UIImagePickerController()
        imagePicker.delegate=self
        imagePicker.sourceType = source
        self.present(imagePicker, animated: true, completion: nil)
    }
}
