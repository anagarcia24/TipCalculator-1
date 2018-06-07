//
//  ViewController.swift
//  TipCalculator
//
//  Created by Henry Vuong on 6/5/18.
//  Copyright © 2018 Henry Vuong. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UINavigationBarDelegate {

    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var navigationbar: UINavigationBar!
    @IBOutlet weak var tipPercentageLabel: UILabel!
    @IBOutlet weak var keypadView: UIView!
    @IBOutlet weak var userInputView: UIView!
    @IBOutlet weak var totalAmountView: UIView!
    
    @IBOutlet weak var userInputViewTopConstraint: NSLayoutConstraint!
    
    var decimalExists = false
    var isCalculating = false
    var countBeforeDecimal = 0
    var tipPercentage = 0.15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationbar.delegate = self
        keypadView.frame = keypadView.frame.offsetBy(dx: 0, dy: 329)
        totalAmountView.frame = totalAmountView.frame.offsetBy(dx: 0, dy: 124)
        totalAmountView.alpha = 0
        userInputView.alpha = 0
        
        UIView.animate(withDuration: 0.50, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
            self.keypadView.frame = self.keypadView.frame.offsetBy(dx: 0, dy: -329)
        }, completion: { (value: Bool) in self.totalAmountView.alpha = 1 })
        
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
            self.userInputView.alpha = 1
            self.userInputView.frame = self.userInputView.frame.offsetBy(dx: 0, dy: 88.5)
            
        }, completion: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Percent")
        var fetchedResults:[NSManagedObject]? = nil
        
        do {
            try fetchedResults = managedContext.fetch(fetchRequest) as? [NSManagedObject]
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
        if let results = fetchedResults {
            if results.count == 0 {
                // add a default tip percent
                addTipPercentage()
            } else {
                tipPercentage = results[0].value(forKey: "percentage") as! Double
                tipPercentageLabel.text = "+" + String(tipPercentage * 100) + "%"
            }
        } else {
            print("Could not fetch")
        }
    }


    @IBAction func numbersButton(_ sender: UIButton) {
        if inputLabel.text == "0" {
            inputLabel.text = ""
        }
        if decimalExists == false || (inputLabel.text?.count)! - countBeforeDecimal < 2 {
            inputLabel.text = inputLabel.text! + String(sender.tag - 1)
            if isCalculating == false {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                    self.userInputView.frame = self.userInputView.frame.offsetBy(dx: 0, dy: -88.5)
                    self.totalAmountView.frame = self.totalAmountView.frame.offsetBy(dx: 0, dy: -124)
                }, completion: nil)
                isCalculating = true
            }
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
            if inputLabel.text?.count == 1 || (inputLabel.text?.last == "." && inputLabel.text?.first == "0") {
                inputLabel.text = "0"
                decimalExists = false
                countBeforeDecimal = 0
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: .curveEaseInOut, animations: {
                    self.userInputView.frame = self.userInputView.frame.offsetBy(dx: 0, dy: 88.5)
                    self.totalAmountView.frame = self.totalAmountView.frame.offsetBy(dx: 0, dy: 124)
                }, completion: nil)
                isCalculating = false
            } else {
                if inputLabel.text?.last == "." {
                    decimalExists = false
                    countBeforeDecimal = 0
                }
                inputLabel.text = String(inputLabel.text!.prefix((inputLabel.text?.count)! - 1))
            }
        }
        updateTotalAmount()
    }
    
    // update UI label
    func updateTotalAmount() {
        totalAmountLabel.text = String(round(100 * Double(inputLabel.text!)! * (1 + tipPercentage))/100)
    }
    
    // adds a NSObject for the tip percentage (Only will be called on first use of app)
    func addTipPercentage() {
        // storing core data
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        // create the entity we want to save
        let entity = NSEntityDescription.entity(forEntityName: "Percent", in: managedContext)
        let defaultPercent = NSManagedObject(entity: entity!, insertInto: managedContext)
        // set the attribute values
        defaultPercent.setValue(0.15, forKey: "percentage")
        
        // Commit the changes.
        do {
            try managedContext.save()
        } catch {
            // what to do if an error occurs?
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
    }
    
    // UI custom navigation bar auto correct for status bar
    public func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
}

