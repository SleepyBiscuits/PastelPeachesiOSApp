//
//  ItemViewController.swift
//  5IOSMD_AssignmentPart2
//
//  Created by Kizzie Mae MARTINEZ (001105383) on 5/10/21.
//

import UIKit
import SQLite3

//MARK: - Table View Cell
class ItemTableViewCell: UITableViewCell{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    
}
class ItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var itemTableView: UITableView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var db: OpaquePointer? = nil

    var qtyNum: Double?
    var priceNum: Double?
    var totalNum: Double?
    var deleteResult: Bool?
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }*/
    // MARK: - Segues

    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = ShopTableView.indexPathForSelectedRow {
                let item = itemArray[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.title = "Details";
                controller.detailItem = item
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    // MARK: - Database
    func getDBPath()->String{
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,FileManager.SearchPathDomainMask.userDomainMask,true)
        let documentsDir = paths[0]
        let databasePath = (documentsDir as NSString).appendingPathComponent("ShopDB.db")
        return databasePath;
    }*/
    // MARK: SelectQuery
    func selectQuery()
    {
        let selectQueryStatement = "SELECT * FROM ShoppingList"
        var queryStatement: OpaquePointer? = nil
        if(sqlite3_prepare_v2(db, selectQueryStatement, -1, &queryStatement, nil) == SQLITE_OK){
            print("Query Result:")
            while(sqlite3_step(queryStatement) == SQLITE_ROW)
            {
                let ItemKey = sqlite3_column_int(queryStatement,0)
                let ItemName = sqlite3_column_text(queryStatement,1)
                let ItemPrice = sqlite3_column_double(queryStatement,2)
                let ItemType = sqlite3_column_text(queryStatement,3)
                let Quantity = sqlite3_column_int(queryStatement,4)
                print ("\(ItemKey) | \(String(describing: ItemName))")
                let i = Item(name:String(cString: ItemName!), price:ItemPrice, type:String(cString: ItemType!),qty:Int(Quantity))
                appDelegate.ItemArray.append(i)
            }
        }else{
            print("SELECT statement could not be prepared", terminator: "")
        }
        sqlite3_finalize(queryStatement)
        sqlite3_close(db)
    }
    // MARK: - Table View
    func numberOfSectionInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.ItemArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)  as! ItemTableViewCell
        let item:Item = appDelegate.ItemArray[indexPath.row]
        cell.nameLabel?.text = item.ItemName
        cell.typeLabel?.text = item.ItemType
        qtyNum = Double(item.Quantity)
        priceNum = item.ItemPrice
        totalNum = qtyNum! * priceNum!
        
        cell.qtyLabel?.text = "Qty: " + String(format: "%d", item.Quantity) + " x " + String(format: "$ %.2f", priceNum!)
        cell.priceLabel?.text = "Total: " + String(format: "$ %.2f AUD", totalNum!)
        //cell.itemImageView?.image = UIImage(named: "shopping-bag.ico")
        return cell;
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        //return false if u do not want the specified item to be editable.
        return true
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
         return "Shopping list"
     }
     /*func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
         return "Footer Item"
     }*/
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
     {
         return 70.0; //Choose your custom row height
     }
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //load db
       /* if sqlite3_open(getDBPath(), &db) == SQLITE_OK{
            print("Succesfully opened connection to database")
            
        }else{
            print("Unable to open database")
        }*/
       
        selectQuery()
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        itemTableView.reloadData()
        self.view.backgroundColor = Colour.sharedInstance.selectedColour
        self.itemTableView.backgroundColor =
            Colour.sharedInstance.selectedColour
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: DeleteQuery
    func deleteQuery(name:String) {
        //, price:Double, type:String, qty:Int
        let deleteSQL = "DELETE FROM ShoppingList WHERE item = ('\(name)')"
        //let deleteSQL = "DELETE FROM ShoppingList WHERE item = ('\(name)',\(price),'\(type)',\(qty))"
        //let deleteSQL = "DELETE FROM shoppinglist WHERE item = ('\(name)')"
        print(deleteSQL)
        var queryStatement: OpaquePointer? = nil
        if sqlite3_open(appDelegate.getDBPath(), &db) == SQLITE_OK
        {
            print("Succesfully opened connection to database")
            if (sqlite3_prepare_v2(db, deleteSQL, -1, &queryStatement, nil) == SQLITE_OK)
            {
                if sqlite3_step(queryStatement) == SQLITE_DONE
                {
                    print("Record Deleted!")
                    //statusLabel.text = "Record Inserted!"
                    deleteResult = true;
                }
                else
                {
                    print("Fail to Delete")
                }
                sqlite3_finalize(queryStatement)
            }
            else
            {
                print("Delete statement could not be prepared", terminator: "")
            }
            sqlite3_close(db)
        }
        else
        {
            print("Unable to open database", terminator: "")
        }
    }
    
   
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete{
            //Delete from DB
            let selectedItem:Item = appDelegate.ItemArray[indexPath.row]
            let itemName:String = selectedItem.ItemName
            //let itemPrice:Double = selectedItem.ItemPrice
            //let itemType:String = selectedItem.ItemType
            //let itemQty:Int = selectedItem.Quantity
            deleteQuery(name:itemName)
            //deleteQuery(name:itemName,price:itemPrice,type:itemType,qty:itemQty)
            //Remove from the array and the table
            appDelegate.ItemArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        else if editingStyle == .insert {
            //Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
  
    
    
}
