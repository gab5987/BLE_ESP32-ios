//
//  ViewController.swift
//  BLE_ESP32
//
//  Created by Gabriel on 27/11/22.
//

import UIKit

class ViewController: UIViewController {
    var simpleBluetoothIO: SimpleBluetoothIO! // Creates a BLE interface
    
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
        simpleBluetoothIO = SimpleBluetoothIO(
            serviceUUID: "4fafc201-1fb5-459e-8fcc-c5c9c331914b",
            delegate: self,
            serviceName: serviceInputField.text!
        )
        creatingAdapterActivity.startAnimating()
        let _ = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(showWarningMessage), userInfo: nil, repeats: false)
        while(!gotMaxTime) {
            if(simpleBluetoothIO.isConnected == true) {
                theJumper(destination: "contextConnected")
                break
            }
        }
    }
    var gotMaxTime: Bool = false
    @objc func showWarningMessage() {
        gotMaxTime = true
        
        let alert = UIAlertController(title: "Warning", message: "Connection time expired", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        creatingAdapterActivity.stopAnimating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This listen to any tap on the screen to hide the keyboard
        view.addGestureRecognizer(
            UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        )
        // Creates a timer to fire up the segue for the initial pop up view, function declared down on "timeToMoveOn"
        let _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timeToMoveOn), userInfo: nil, repeats: false)
    }
    
    // Simply performs a segue for the presentation view
    @objc func timeToMoveOn() {
        self.performSegue(withIdentifier: "initialPresentationSegue", sender: self)
    }
    
    func theJumper(destination: String) {
        self.performSegue(withIdentifier: destination, sender: self)
    }
    
    @IBAction func buttonTeste(_ sender: Any) {
        simpleBluetoothIO.writeValue(value: testeInputField.text!)
    }
}

extension ViewController: SimpleBluetoothIODelegate {
    func simpleBluetoothIO(simpleBluetoothIO: SimpleBluetoothIO, didReceiveValue value: String) {
        print(value)
    }
}
