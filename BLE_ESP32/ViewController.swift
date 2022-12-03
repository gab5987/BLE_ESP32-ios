//
//  ViewController.swift
//  BLE_ESP32
//
//  Created by Gabriel on 27/11/22.
//

import UIKit

class ViewController: UIViewController {
    var receivedData: String?

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
    
    @IBOutlet weak var testeInputField: UITextField!
    @IBOutlet weak var serviceInputField: UITextField!                   // Holds the device name (Input from User)
    @IBOutlet weak var creatingAdapterActivity: UIActivityIndicatorView! // Used to create a loading animation
    
    @IBAction func connectToAdapter(_ sender: Any) {                     // Function that connects to the device specified in serviceInputField
        // This creates the adapter itself
        let _ = BluetoothDevice(deviceName: serviceInputField.text!)
        // Creates the timer to check to guarantee that the connection is stabilished
        creatingAdapterActivity.startAnimating()
        let _ = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(changeViewOrThrowError), userInfo: nil, repeats: false)
    }
    @objc func changeViewOrThrowError() {
        creatingAdapterActivity.stopAnimating()
        if(bluetoothDev.isConnected == true) {    // Shows the contextConnected screen if coneection is stabilished
            theJumper(destination: "contextConnected")
        }
        else {                                         // Or presents a error if dont
            let alert = UIAlertController(title: "Erro", message: """
                                                                  O tempo de conexão excedeu o limite
                                                                  Error 0x42 TLE(Time Limit Exceeded)
                                                                  """, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
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
    
    @IBAction func jhbjhkbkjhb(_ sender: Any) {
        sendData(value: "sdkjnfdjbfn")
    }
    func sendData(value: String) {
        bluetoothDev.writeValue(value: value)
    }
}
