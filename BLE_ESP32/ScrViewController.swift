//
//  ScrViewController.swift
//  BLE_ESP32
//
//  Created by Gabriel on 28/11/22.
//  Copyright © 2022 pierdr. All rights reserved.
//

import UIKit

var dataGlobal: String?

class ScrViewController: UIViewController {
    
    // Gets the bluetooth interface from the past controller
    var simpleBluetoothIO = ViewController.simpleBluetoothIO
    
    var receivedData: String!
    
    @IBOutlet weak var labelTeste: UILabel!
    @IBOutlet weak var inputTeste: UITextField!
    @IBOutlet weak var switchTeste: UISwitch!
    
//    @IBAction func sendTeste(_ sender: Any) {
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
    }
    
    @objc func updateData() {
        receivedData = dataGlobal
        print(receivedData ?? "<ERROR>")
        labelTeste.text = receivedData
    }

    @IBAction func dismissTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}
