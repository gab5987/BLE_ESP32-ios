//
//  ViewController.swift
//  BLE_ESP32
//
//  Created by Gabriel on 27/11/22.
//

import UIKit

class ViewController: UIViewController {
    var simpleBluetoothIO: SimpleBluetoothIO! // Creates a BLE interface
    
    @IBOutlet weak var serviceInputField: UITextField!                   // Holds the device name (Input from User)
    @IBOutlet weak var creatingAdapterActivity: UIActivityIndicatorView! // Used to create a loading animation
    @IBAction func connectToAdapter(_ sender: Any) {                     // Function that connects to the device specified in serviceInputField
        simpleBluetoothIO = SimpleBluetoothIO(
            serviceUUID: "4fafc201-1fb5-459e-8fcc-c5c9c331914b",
            delegate: self,
            serviceName: serviceInputField.text!
        )
        createConnection = true
        showAnim()
    }
    
    var createConnection: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This listen to any tap on the screen to hide the keyboard
        view.addGestureRecognizer(
            UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        )
    }
    
    func showAnim() {
        if(createConnection == true) {
            creatingAdapterActivity.startAnimating()
        }
        else {
            creatingAdapterActivity.stopAnimating()
        }
    }
}

extension ViewController: SimpleBluetoothIODelegate {
    func simpleBluetoothIO(simpleBluetoothIO: SimpleBluetoothIO, didReceiveValue value: Int8) {
    }
}
