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
        getAllCurrency()
    
    }
    
    func getAllCurrency() {
        spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        spinner.center = self.view.center
        self.view.addSubview(spinner)
        spinner.startAnimating()
        let url = NSURL(string:urlPath)!
        var request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        data = NSMutableData()
        var connection = NSURLConnection(request: request, delegate: self, startImmediately: true)
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse)
    { //It says the response started coming
        NSLog("didReceiveResponse")
    }
    func connection(connection: NSURLConnection, didReceiveData _data: NSData)
    { //This will be called again and again until you get the full response
        //NSLog("didReceiveData")
        // Appending data
        data.appendData(_data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection)
    {
        // This will be called when the data loading is finished i.e. there is no data left to be received and now you can process the data.
        spinner.stopAnimating()
        NSLog("connectionDidFinishLoading")
        var jsonError: NSError?
        let hcards = (try! NSJSONSerialization.JSONObjectWithData(data, options: [])) as! NSMutableDictionary
        print("\(hcards)")
        //cards = hcards.valueForKey("Goblins vs Gnomes") as! NSMutableArray
        //println("\(cards)")
        dispatch_async(dispatch_get_main_queue()){
            //self.tableView.reloadData()
        }
        
        //var responseStr:NSString = NSString(data:self.data, encoding:NSUTF8StringEncoding)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

