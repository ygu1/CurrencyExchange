//
//  ViewController.swift
//  CurrencyExchange
//
//  Created by EERC718 on 4/22/16.
//
//

import UIKit
import CoreData

class ViewController: UIViewController {
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("Currency", inManagedObjectContext: self.managedObjectContext) as! Currency
        newItem.currency = 1
        newItem.name = "USD"
        
        // Print it to the console
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

