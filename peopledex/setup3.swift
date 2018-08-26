//
//  setup3.swift
//  peopledex
//
//  Created by Richie Min on 2018-08-25.
//  Copyright © 2018 Richie Min. All rights reserved.
//

import UIKit

class setup3: UIViewController {

    
    @IBOutlet weak var topic1: UITextField!
    @IBOutlet weak var topic2: UITextField!
    @IBOutlet weak var topic3: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topic1.delegate = self
        topic2.delegate = self
        topic3.delegate = self


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

extension setup3: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

