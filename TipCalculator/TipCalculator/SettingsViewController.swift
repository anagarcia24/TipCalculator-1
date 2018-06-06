//
//  SettingsViewController.swift
//  TipCalculator
//
//  Created by Henry Vuong on 6/6/18.
//  Copyright © 2018 Henry Vuong. All rights reserved.
//

import UIKit
import CoreData

class SettingsViewController: UIViewController {

    @IBOutlet weak var tipPercentageSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func closeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        var tipPercent: Double!
        switch tipPercentageSegmentedControl.selectedSegmentIndex {
            case 0: tipPercent = 0.05
            case 1: tipPercent = 0.10
            case 2: tipPercent = 0.15
            case 3: tipPercent = 0.18
            case 4: tipPercent = 0.20
            case 5: tipPercent = 0.25
            case 6: tipPercent = 0.30
            case 7: tipPercent = 0.35
            default: tipPercent = 0.15;
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:"Percent")
        
        do {
            let test = try managedContext.fetch(fetchRequest)
            if test.count == 1
            {
                let objectUpdate = test[0] as! NSManagedObject
                objectUpdate.setValue(tipPercent, forKey: "percentage")
                
                do {
                    try managedContext.save()
                    print("hello")
                }
                    catch
                {
                    print(error)
                }
            }
        } catch {
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }

        
    }
    
}
