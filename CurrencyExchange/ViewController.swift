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
    let urlPath: String = "http://api.fixer.io/latest"
    var spinner: UIActivityIndicatorView!
    var allCurrency: NSMutableArray = NSMutableArray()
    var data: NSMutableData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

//        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
//        let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
//        let documentsURL = paths[0] as! NSURL
//        print(documentsURL)
        //Currency.modifyCurrency(self.managedObjectContext, moneyName: "USD", nowCurrency: 1.2)
        //getAllCurrency()
        getAllCurrency()
    
    }
    
    func getAllCurrency() {
        let requestURL: NSURL = NSURL(string: urlPath)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        urlRequest.HTTPMethod = "GET"
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                do{
                    let json = (try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)) as! NSMutableDictionary
                    let rates = json.valueForKey("rates") as! NSMutableDictionary
                    var i = 0
                    while i < rates.allKeys.count {
                        if (Currency.modifyCurrency(self.managedObjectContext, moneyName: rates.allKeys[i] as! String, nowCurrency: rates.valueForKey(rates.allKeys[i] as! String) as! Double) != nil)
                        {
                            print("Successfully update \(rates.allKeys[i] as! String) currency to \(rates.valueForKey(rates.allKeys[i] as! String) as! Double)")
                            
                        }
                        else{
                            Currency.createInManagedObjectContext(self.managedObjectContext, moneyName: rates.allKeys[i] as! String, nowCurrency: rates.valueForKey(rates.allKeys[i] as! String) as! Double)
                        }
                        i += 1
                    }
                }catch {
                    print("Error with Json: \(error)")
                }
            }
        }
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

