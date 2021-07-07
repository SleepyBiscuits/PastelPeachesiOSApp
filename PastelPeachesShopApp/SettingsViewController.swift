//
//  SettingsViewController.swift
//  5IOSMD_AssignmentPart2
//
//  Created by Kizzie Mae MARTINEZ (001105383) on 5/10/21.
//

import UIKit

class SettingsViewController: UIViewController{
    
    @available(iOS 14.0, *)
    @IBAction func customClicked(_ sender: Any) {
        //performSegue(withIdentifier: "customizePage", sender: self)
        let picker = UIColorPickerViewController()
        //Setting the initial color of the picker
        picker.selectedColor = self.view.backgroundColor!

        //Setting Delegate
        picker.delegate = self
        //Present the color Picker
        self.present(picker, animated: true, completion: nil)
    }
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated)
        self.view.backgroundColor = Colour.sharedInstance.selectedColour
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
}
@available(iOS 14.0,*)
extension SettingsViewController: UIColorPickerViewControllerDelegate {
    // Called once you have finished picking the color
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController)
    {
        self.view.backgroundColor = viewController.selectedColor
    }

//Called on every color selection done in the picker.
func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController)
    {
    self.view.backgroundColor = viewController.selectedColor
    Colour.sharedInstance.selectedColour = self.view.backgroundColor
    }
}
