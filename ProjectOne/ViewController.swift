//
//  ViewController.swift
//  ProjectOne
//
//  Created by Sophia Amin on 4/13/18.
//  Copyright © 2018 Sophia Amin. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var textFieldVal1: UITextField!
    @IBOutlet weak var textFieldVal2: UITextField!
    @IBOutlet weak var labelTotal: UILabel!
    @IBOutlet weak var buttonTotal: UIButton!
    @IBOutlet weak var labelSavedData: UILabel!
    @IBOutlet weak var buttonSaveCoreData: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //load the saved core data value
        labelSavedData.text = UserDefaults.standard.string(forKey: "Calculated")
        
    }


    @IBAction func totalPressed(_ sender: UIButton) {
        labelTotal.text = doCalcGetString()
        labelSavedData.text = UserDefaults.standard.string(forKey: "Calculated")
        
    }
    
    
    @IBAction func saveCoreDataPressed(_ sender: UIButton) {
        //new object in coredata
        setUpData(displayNum: labelTotal.text!)
        //print to the console the entry into core data
        
    }
    
    func doCalcGetString() -> String{
        //get values from the text fields and add
        var calculated:Int? = nil ?? 0
        let numOne:Int? = Int(textFieldVal1.text!) ?? 0
        let numTwo:Int? = Int(textFieldVal2.text!) ?? 0
        calculated = numOne! + numTwo!
        let name:String? = String(describing: calculated!)
        UserDefaults.standard.set(name, forKey: "Calculated")  //String saved
        
        return name!
        
    }
    
   //CORE DATA
    
    func setUpData(displayNum: String){
//        //1. Similar to create database and create SQL table named CarData (SQL comparisons)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            return
       } //instance of app delegate, check if it is the app delegate with a guard statement (safe code)
          let totalContext = appDelegate.persistentContainer.viewContext
          let totalEntity = NSEntityDescription.entity(forEntityName: "Total", in: totalContext)

        //2. Similar to INSERT INTO CarData(color, price, type) VALUES(any, any, any) (SQL)
          let newTotal = NSManagedObject(entity: totalEntity!, insertInto: totalContext)
        //~database~ has been created

          newTotal.setValue(displayNum, forKey: "calcNum")
        
          saveData(contextSaveObject: totalContext)
          loadData(contextLoadObject: totalContext)
    }

    func saveData(contextSaveObject: AnyObject){
        do{
            try contextSaveObject.save()
        }
        catch {
            print("Error saving")
        }
    }
    
    
    func loadData(contextLoadObject: AnyObject){
        let myRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Total")
        myRequest.returnsObjectsAsFaults = false
        
        //3. important part of Core Data to use the VALUES in the database
        do{
            let result = try contextLoadObject.fetch(myRequest)
            for data in result as! [NSManagedObject]{ //cast as an array (for saving into rows)
                let theTotal = data.value(forKey: "calcNum")// as! String //must cast object to String (or Int if needed)
   
                
                print("Here is my info from Database: The total is: \(String(describing: theTotal!)) ")
            }
        }catch{
            print("Error loading")
        }
        
    }
    
}

