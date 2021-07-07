//
//  Item.swift
//  5IOSMD_AssignmentPart2
//
//  Created by Kizzie Mae MARTINEZ (001105383) on 6/2/21.
//

import Foundation
public class Item {
    public var ItemName: String
    public var ItemPrice: Double
    public var ItemType: String
    public var Quantity: Int
    //default
    public init() {
        //self.ItemKey = 0
        self.ItemName = ""
        self.ItemPrice = 0
        self.ItemType = ""
        self.Quantity = 0
    }
    
    public init(name: String, price: Double, type: String, qty: Int) {
        self.ItemName = name
        self.ItemPrice = price
        self.ItemType = type
        self.Quantity = qty
    }
    
    func toString() ->String
    {
        return
           // "\nItem Key:" + String(format:"%d", self.ItemKey)  +
            "\nName :" + self.ItemName +
            "\nPrice :" + String(format:"%d", self.ItemPrice) +
            "\nItem Type :" + self.ItemType +
            "\nQuantity :" + String(format:"%d", self.Quantity)
    }
}
