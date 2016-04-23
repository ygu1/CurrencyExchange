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
    
    /*
     *   Create new log and save
     */
    class func createInManagedObjectContext(moc: NSManagedObjectContext, moneyName: String, nowCurrency: Double) -> Currency {
        let newItem = NSEntityDescription.insertNewObjectForEntityForName("Currency", inManagedObjectContext: moc) as! Currency
        newItem.name = moneyName
        newItem.currency = nowCurrency
        saveCurrency(moc)
        return newItem
    }
    
    class func changeCurrency(moc: NSManagedObjectContext, moneyName: String, nowCurrency: Double) {
        
    }
    
    
    /*
     *   Save function
     */
    class func saveCurrency(moc: NSManagedObjectContext) {
        do {
            try moc.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    /*
     *  Fetch all logs
     */
    class func fetchAll(moc: NSManagedObjectContext) -> Array<Currency>? {
        let fetchRequest = NSFetchRequest(entityName: "Currency")
        let fetchResults = (try! moc.executeFetchRequest(fetchRequest) as? [Currency])
        return fetchResults
    }
    
    /*
     *  Fetch a log with the money name
     */
    class func fetchWithName(moc: NSManagedObjectContext, moneyName: String) -> Currency? {
        let fetchRequest = NSFetchRequest(entityName: "Currency")
        fetchRequest.predicate = NSPredicate(format: "name == %@", moneyName)
        let fetchResults = (try! moc.executeFetchRequest(fetchRequest) as? [Currency])
        if fetchResults != nil && fetchResults?.count != 0{
            return fetchResults![0]
        }
        else{
            return nil
        }
    }
    
    /*
     *   Modify currency
     */
    class func modifyCurrency(moc: NSManagedObjectContext, moneyName: String, nowCurrency: Double) -> Currency? {
        if let newCurrency = self.fetchWithName(moc, moneyName: moneyName) {
            newCurrency.currency = nowCurrency
            self.saveCurrency(moc)
            return newCurrency
        }
        else{
            print("Can not find this money \(moneyName)")
            return nil
        }
    }
    
}
