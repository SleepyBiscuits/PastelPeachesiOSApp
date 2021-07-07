//
//  AddViewController.swift
//  5IOSMD_AssignmentPart2
//
//  Created by Kizzie Mae MARTINEZ (001105383) on 5/10/21.
//
import SQLite3
import UIKit

class AddViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var typePickerView: UIPickerView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var qtyPickerView: UIPickerView!
    
    //@IBOutlet weak var qtyPickerView: UIPickerView!
    //@IBOutlet weak var shopTable: UITableView!
    var objects = [Any]()
    var type: [String] = ["Miscellaneous","Clothing","Groceries","Fitness","Meals","Toys","Electronics","Shoes","Lifestyle","Health"]
    var qty: [String] = ["1","2","3","4","5","6","7","8","9","10"]
    var ItemArray = [Item]()
    var qtySelect: Int?
    var typeSelect: String?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var db: OpaquePointer? = nil
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //movieTitleArray = appDelegate.movieArray.sorted(by: {$0.title < $1.title})
        self.view.backgroundColor = Colour.sharedInstance.selectedColour
        qtyPickerView.delegate = self
        qtyPickerView.dataSource = self
        typePickerView.delegate = self
        typePickerView.dataSource = self
        
    }
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.view.backgroundColor = Colour.sharedInstance.selectedColour
        statusLabel.text! = ""
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: - Product Name
    
    // MARK: - Product Type Picker View
    func numberOfComponents(in typePickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == qtyPickerView {
            return qty.count;
        }
        return type.count;
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        if pickerView == qtyPickerView {
            return qty[row] as String
        }
        return type[row] as String
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //print(type[row])
        if pickerView == qtyPickerView {
            qtySelect = Int(qty[row])
        }
        typeSelect = type[row]
    }
    
    //MARK: QTY
    //MARK: Price Text Field
    
    
    //MARK: - Add Button Click Event
    @IBAction func addClick(_ sender: Any) {
        var itemName: String?
        var itemPrice: Double?
        var itemType: String?
        var quantity: Int?
        let temp = priceTextField.text ?? ""
        if nameTextField.text!.isEmpty || priceTextField.text!.isEmpty {
            let alertController = UIAlertController (title:"Empty Text Fields",message:"please input the appropriate data again", preferredStyle:.alert)
            //Define an action
            let alertAction = UIAlertAction(title:"Ok",style:.default, handler:nil)
            //Add an action
            alertController.addAction(alertAction)
            //Display alert
            self.present(alertController, animated:true, completion:nil)
        } else if Int(temp) == nil {
            let alertController = UIAlertController (title:"Not Numbers",message:"please input numbers into the price text field", preferredStyle:.alert)
            //Define an action
            let alertAction = UIAlertAction(title:"Ok",style:.default, handler:nil)
            //Add an action
            alertController.addAction(alertAction)
            //Display alert
            self.present(alertController, animated:true, completion:nil)
        }else{
        itemName = nameTextField.text!
        itemPrice = NSString(string:priceTextField.text!).doubleValue
        itemType = type[typePickerView.selectedRow(inComponent: 0)]
        quantity = NSString(string:qty[qtyPickerView.selectedRow(inComponent: 0)]).integerValue
        
       // print(itemType!)
        
        insertQuery(name:itemName!, price: itemPrice!, type: itemType!, qty: quantity!)
        let s = Item(name:itemName!, price: itemPrice!, type: itemType!, qty: quantity!)
        appDelegate.ItemArray.append(s)
        
        nameTextField.text = ""
        priceTextField.text = ""
        typePickerView.selectRow(0,inComponent:0,animated: true)
        qtyPickerView.selectRow(0,inComponent:0,animated: true)
        typePickerView.reloadAllComponents();
        qtyPickerView.reloadAllComponents();
        }
    }
   
    func insertQuery(name:String, price:Double, type:String, qty:Int) {
        let insertSQL = "INSERT INTO ShoppingList(ItemName, ItemPrice, ItemType, Quantity) VALUES ('\(name)',\(price),'\(type)',\(qty))"
        print(insertSQL)
        var queryStatement: OpaquePointer? = nil
        if sqlite3_open(appDelegate.getDBPath(), &db) == SQLITE_OK
        {
            print("Succesfully opened connection to database")
            if (sqlite3_prepare_v2(db, insertSQL, -1, &queryStatement, nil) == SQLITE_OK)
            {
                if sqlite3_step(queryStatement) == SQLITE_DONE
                {
                    print("Record Inserted!")
                    statusLabel.text = "Item Added!"
                }
                else
                {
                    print("Fail to Insert")
                    statusLabel.text = "Failed to add Item"
                }
            }
            else
            {
                print("Insert statement could not be prepared")
                statusLabel.text = "INSERT STATEMENT NOT PREPARED"
            }
            sqlite3_close(db)
        }
        else
        {
            print("Unable to open database")
            statusLabel.text = "UNABLE TO OPEN DB"
        }
    }
    
    //MARK: Reset Button Click Event
    @IBAction func resetClick(_ sender: Any) {
        nameTextField.text = ""
        priceTextField.text = ""
        typePickerView.reloadAllComponents();
        qtyPickerView.reloadAllComponents();
        statusLabel.text = "Cleared all fields"
    }
    
}

