//
//  ViewController.swift
//  BLE_ESP32
//
//  Created by Gabriel on 27/11/22.
//

import UIKit
var serviceName: String?

class ViewController: UIViewController {
    
    // This method creates a gradient color for the background
    func setGradientBackground() {
        let colorTop =  UIColor(red: 21.0/255.0, green: 147.0/255.0, blue: 195.0/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 38.0/255.0, green: 28.0/255.0, blue: 71.0/255.0, alpha: 1.0).cgColor
                    
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    // This method is called right before everything is loaded on screen, it calls the gradient method
    override func viewWillAppear(_ animated: Bool) {
        setGradientBackground()
        super.viewWillAppear(animated)
    }
    
    @IBOutlet weak var serviceInputField: UITextField!                   // Holds the device name (Input from User)    
    @IBAction func connectToAdapter(_ sender: Any) {                     // Function that connects to the device specified in serviceInputField
        serviceName = serviceInputField.text!
        theJumper(destination: "contextConnected")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This listen to any tap on the screen to hide the keyboard
        view.addGestureRecognizer(
            UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        )
    }
    
    func theJumper(destination: String) {
        self.performSegue(withIdentifier: destination, sender: self)
    }
}

