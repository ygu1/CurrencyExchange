//
//  Currency.swift
//  CurrencyExchange
//
//  Created by EERC718 on 4/22/16.
//
//

import Foundation
import CoreData


class Currency: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    @NSManaged var name: String?
    @NSManaged var currency: Double
    
    class func createInManagedObjectContext(moc: NSManagedObjectContext, moneyName: String, nowCurrency: Double) -> Currency {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("LogItem", inManagedObjectContext: moc) as! Currency
        newItem.name = moneyName
        newItem.currency = nowCurrency
        
        return newItem
    }
}
