//
//  setup4.swift
//  peopledex
//
//  Created by Richie Min on 2018-08-25.
//  Copyright © 2018 Richie Min. All rights reserved.
//

import UIKit

class setup4: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var photo: UIImageView!
    
    @IBAction func chooseImage(_ sender: Any) {
        

       photo.layer.masksToBounds = false
       photo.layer.cornerRadius = photo.frame.height/2
       photo.clipsToBounds = true
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        let imagePickerController = UIImagePickerController()
     
        imagePickerController.delegate = self
        
        imagePickerController.allowsEditing = true

        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
            }else{
                print("Camera Not Available")
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: {(action:UIAlertAction) in imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
       // let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
       // photo.image = image
       // picker.dismiss(animated:true, completion:nil)
        
        var picture : UIImage!
        
        if let img = info[UIImagePickerControllerEditedImage] as? UIImage
        {
            picture = img
            
        }
        else if let img = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            picture = img
        }
        
        photo.image = picture
        picker.dismiss(animated:true, completion:nil)

    }
    

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

