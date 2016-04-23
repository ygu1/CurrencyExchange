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

//        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
//        let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
//        let documentsURL = paths[0] as! NSURL
//        print(documentsURL)

        Currency.modifyCurrency(self.managedObjectContext, moneyName: "USD", nowCurrency: 1.2)
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

