//
//  ViewController.swift
//  TipCalculator
//
//  Created by Henry Vuong on 6/5/18.
//  Copyright © 2018 Henry Vuong. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationBarDelegate {

    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var navigationbar: UINavigationBar!
    
    var decimalExists = false
    var countBeforeDecimal = 0
    var tipPercentage = 0.10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationbar.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func numbersButton(_ sender: UIButton) {
        if inputLabel.text == "0" {
            inputLabel.text = ""
        }
        if decimalExists == false || (inputLabel.text?.count)! - countBeforeDecimal < 2 {
            inputLabel.text = inputLabel.text! + String(sender.tag - 1)
        }
        updateTotalAmount()
    }
    
    @IBAction func decimalButton(_ sender: UIButton) {
        if decimalExists == false {
            inputLabel.text = inputLabel.text! + "."
            decimalExists = true
            countBeforeDecimal = (inputLabel.text?.count)!
        }
        updateTotalAmount()
    }
    
    @IBAction func backspaceButton(_ sender: UIButton) {
        if inputLabel.text != "0" {
            if inputLabel.text?.count == 1 {
                inputLabel.text = "0"
            } else {
                inputLabel.text = String(inputLabel.text!.prefix((inputLabel.text?.count)! - 1))
            }
            decimalExists = false
            countBeforeDecimal = 0
        }
        updateTotalAmount()
    }
    
    // update UI label
    func updateTotalAmount() {
        totalAmountLabel.text = String(round(100 * Double(inputLabel.text!)! * (1 + tipPercentage))/100)
    }
    
    // UI custom navigation bar auto correct for status bar
    public func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

