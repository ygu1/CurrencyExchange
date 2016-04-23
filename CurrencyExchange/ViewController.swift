//
//  ViewController.swift
//  CurrencyExchange
//
//  Created by EERC718 on 4/22/16.
//
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var nameTable: UITableView!
    @IBOutlet weak var moneyLabel1: UILabel!
    @IBOutlet weak var moneyLabel2: UILabel!
    @IBOutlet weak var tableBtn1: UIButton!
    @IBOutlet weak var tableBtn2: UIButton!
    @IBOutlet weak var inputText1: UITextField!
    @IBOutlet weak var inputText2: UITextField!
    
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let urlPath: String = "http://api.fixer.io/latest"
    var spinner: UIActivityIndicatorView!

    var currencyDict: NSMutableDictionary! = NSMutableDictionary()
    var currencyDictKeys: Array<String>! = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

//        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
//        let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
//        let documentsURL = paths[0] as! NSURL
//        print(documentsURL)
        setTable()
        getAllCurrency()
    }
    
    @IBAction func showHiddenTable(sender: UIButton) {
        if nameTable.hidden {
            nameTable.hidden = false
        }
        else {
            nameTable.hidden = true
        }
    }
    
    func setTable() {
        self.nameTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        nameTable.delegate = self
        nameTable.dataSource = self
        nameTable.hidden = true
        nameTable.layer.borderWidth = 1
        nameTable.layer.borderColor = UIColor.blackColor().CGColor
        nameTable.layer.cornerRadius = 5
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyDict.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UITableViewCell = nameTable.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        let key = currencyDictKeys[indexPath.row] as String
        cell.textLabel?.text = key
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func getAllCurrency() {
//        spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
//        spinner.center = self.view.center
//        self.view.addSubview(spinner)
//        spinner.startAnimating()
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
            else{
                print("Error status code: \(statusCode)")
            }
            dispatch_async(dispatch_get_main_queue()){
                self.updateCurrencyDict()
            }
        }
        task.resume()
    }
    
    func updateCurrencyDict() {
        let tempCurrency = Currency.fetchAll(self.managedObjectContext)
        if tempCurrency != nil && tempCurrency?.count != 0{
            var i = 0
            while i < tempCurrency?.count {
                currencyDict.setObject(tempCurrency![i].currency, forKey: tempCurrency![i].name!)
                i += 1
            }
            currencyDictKeys = (currencyDict.allKeys as! Array<String>).sort()
        }
        else {
            print("Please connect network to update currency database.")
        }
        //self.spinner.stopAnimating()
        print(currencyDictKeys)
        dispatch_async(dispatch_get_main_queue()){
            self.nameTable.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

