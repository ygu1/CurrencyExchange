//
//  ViewController.swift
//  CurrencyExchange
//
//  Created by EERC718 on 4/22/16.
//
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    @IBOutlet var nameTable: UITableView!
    @IBOutlet weak var nameTable2: UITableView!
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
    var nameDict: NSDictionary!
    
    var currency1: Double!
    var currency2: Double!
    var btnSelected: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

//        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
//        let paths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
//        let documentsURL = paths[0] as! NSURL
//        print(documentsURL)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bgImage")!)
        nameDict = readNameList()
        setTable()
        getAllCurrency()
    }
    
    /*
     *   Read the name matching list "nameMatchList.plist"s
     */
    func readNameList() -> NSDictionary {
        var myDict: NSDictionary!
        if let path = NSBundle.mainBundle().pathForResource("nameMatchList", ofType: "plist") {
            myDict = NSDictionary(contentsOfFile: path)
        }
        return myDict
    }
    
    /*
     *   Show or hide table
     */
    @IBAction func showHiddenTable(sender: UIButton) {
        var tableView: UITableView!
        var tableView2: UITableView!
        if sender.tag == 1 {
            tableView = nameTable
            tableView2 = nameTable2
        }
        else if sender.tag == 2 {
            tableView = nameTable2
            tableView2 = nameTable
        }
        else {
            print("No button tag match")
        }
        if tableView.hidden {
            tableView2.hidden = true
            tableView.hidden = false
            let tempFrame = CGRect(x: sender.frame.origin.x, y: sender.frame.origin.y, width: tableView.frame.size.width, height: tableView.frame.size.height)
            tableView.frame = tempFrame
            btnSelected = sender.tag
        }
    }
    
    
    /*
     *   Set money label
     */
    func  setMoneyLabel() {
        let key1 = tableBtn1.currentTitle!
        let key2 = tableBtn2.currentTitle!
        currency1 = currencyDict.valueForKey(key1) as! Double
        currency2 = currencyDict.valueForKey(key2) as! Double
        let string1 = nameDict.valueForKey(key1) as! String
        let string2 = nameDict.valueForKey(key2) as! String
        moneyLabel1.text = "1 " + string1 + " equals"
        moneyLabel2.text = String(format:"%.2f ",1.0 * currency2 / currency1)+string2
    }
    
    /*
     *   Set button title
     */
    func setBtn(moneyName:String, btnNumber:Int){
        if btnNumber == 1 {
            if tableBtn2.currentTitle == moneyName {
                tableBtn2.setTitle(tableBtn1.currentTitle, forState: .Normal)
            }
            tableBtn1.setTitle(moneyName, forState: .Normal)
        }
        else {
            if tableBtn1.currentTitle == moneyName {
                tableBtn1.setTitle(tableBtn2.currentTitle, forState: .Normal)
            }
            tableBtn2.setTitle(moneyName, forState: .Normal)
        }
    }
    
    func setTextLabel(){
        let key1 = tableBtn1.currentTitle!
        let key2 = tableBtn2.currentTitle!
        currency1 = currencyDict.valueForKey(key1) as! Double
        currency2 = currencyDict.valueForKey(key2) as! Double
        inputText1.text = "1.00"
        inputText2.text = String(format:"%.2f",1.0 * currency2 / currency1)
        
    }
    
    /*
     *   If text field number changed, it will calculate the currency
     */
    @IBAction func textFieldChanged(sender: UITextField) {
        var changeText: UITextField!
        var resultText: UITextField!
        if sender == inputText1 {
            changeText = inputText1
            resultText = inputText2
        }
        else {
            changeText = inputText2
            resultText = inputText1
        }
        if (Double(changeText.text!) == nil) {
            resultText.text = "0.00"
        }
        else{
            resultText.text = String(format:"%.2f",Double(changeText.text!)! * currency2 / currency1)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    /*
     *   Set table appearance
     */
    func setTable() {
        self.nameTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        nameTable.delegate = self
        nameTable.dataSource = self
        nameTable.hidden = true
        nameTable.layer.borderWidth = 1
        nameTable.layer.borderColor = UIColor.blackColor().CGColor
        nameTable.layer.cornerRadius = 5
        self.nameTable2.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        nameTable2.delegate = self
        nameTable2.dataSource = self
        nameTable2.hidden = true
        nameTable2.layer.borderWidth = 1
        nameTable2.layer.borderColor = UIColor.blackColor().CGColor
        nameTable2.layer.cornerRadius = 5
        inputText1.delegate = self
        inputText2.delegate = self
    }
    
    /*
     *   Number of sections in the table
     */
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    /*
     *   Number of rows in the table
     */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyDict.count
    }
    
    /*
     *   Set cell in the table
     */
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        let key = currencyDictKeys[indexPath.row] as String
        cell.textLabel?.text = nameDict.valueForKey(key) as? String
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let btnName = currencyDictKeys[indexPath.row] as String
        self.setBtn(btnName, btnNumber: btnSelected)
        self.setTextLabel()
        self.setMoneyLabel()
        tableView.hidden = true
    }
    
    /*
     *   Get currency info by http request, updating the database
     */
    func getAllCurrency() {
        spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        spinner.center = self.view.center
        self.view.addSubview(spinner)
        spinner.startAnimating()
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
    
    /*
     *   Upate the temp currency dictinary
     */
    func updateCurrencyDict() {
        let tempCurrency = Currency.fetchAll(self.managedObjectContext)
        if tempCurrency != nil && tempCurrency?.count != 0{
            var i = 0
            while i < tempCurrency?.count {
                currencyDict.setObject(tempCurrency![i].currency, forKey: tempCurrency![i].name!)
                i += 1
            }
            currencyDict.setObject(1.0, forKey: "EUR")
            currencyDictKeys = (currencyDict.allKeys as! Array<String>).sort()
        }
        else {
            print("Please connect network to update currency database.")
        }
        //print(currencyDictKeys)
        dispatch_async(dispatch_get_main_queue()){
            self.spinner.stopAnimating()
            self.nameTable.reloadData()
            self.nameTable2.reloadData()
        }
        self.setBtn("EUR", btnNumber: 1)
        self.setBtn("USD", btnNumber: 2)
        self.setTextLabel()
        self.setMoneyLabel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

