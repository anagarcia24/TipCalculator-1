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
    
    var decimalExists = false
    var countBeforeDecimal = 0
    var tipPercentage = 0.15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationbar.delegate = self
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
                print(results.count)
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

