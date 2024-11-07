//
//  ViewController.swift
//  CRUDApp
//
//  Created by Naga Divya Bobbara on 07/11/24.
//

import UIKit

public class ProfileInfoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var mobileNumTF: UITextField!
    @IBOutlet weak var DOBTF: UITextField!
    @IBOutlet weak var genderTF: UITextField!
    @IBOutlet weak var designationTF: UITextField!
    @IBOutlet weak var companyNameTF: UITextField!
    @IBOutlet weak var yearsOfExpTF: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var updateButton: UIButton!
    
    private let datePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var empData = [EmployeeDetails]()
    private let genderPicker = UIPickerView()
    let genderOptions = ["Male", "Female"]
    var selectedEmployee: EmployeeDetails?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setUpDatePicker()
        setUpGenderPicker()
        if let employee = selectedEmployee {
            saveButton.isHidden = false
            updateButton.isHidden = true
            deleteButton.isHidden = false
            editButton.isHidden = false
            changeALLTFState(isEnabled: false)
            nameTF.text = employee.name
            emailTF.text = employee.email
            mobileNumTF.text = employee.mobile
            genderTF.text = employee.gender
            companyNameTF.text = employee.company
            designationTF.text = employee.designation
            yearsOfExpTF.text = employee.experience
            
            // Set the date of birth using a date formatter
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            if let dob = employee.dob {
                DOBTF.text = dateFormatter.string(from: dob)
            }
        } else {
            saveButton.isHidden = false
            updateButton.isHidden = true
            deleteButton.isHidden = true
            editButton.isHidden = true
            changeALLTFState(isEnabled: true)
        }
        dateFormatter.dateFormat = "d MMM yyyy"
    }
    
    func changeALLTFState(isEnabled: Bool) {
        nameTF.isEnabled = isEnabled
        emailTF.isEnabled = isEnabled
        mobileNumTF.isEnabled = isEnabled
        genderTF.isEnabled = isEnabled
        companyNameTF.isEnabled = isEnabled
        designationTF.isEnabled = isEnabled
        yearsOfExpTF.isEnabled = isEnabled
        DOBTF.isEnabled = isEnabled
    }
    
    func setUpGenderPicker() {
        genderPicker.delegate = self
        genderPicker.dataSource = self
        genderTF.inputView = genderPicker
        
        // Toolbar with Done button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(genderDoneButtonTapped))
        toolbar.setItems([doneButton], animated: true)
        genderTF.inputAccessoryView = toolbar
    }
    
    @objc private func genderDoneButtonTapped() {
        // Set the selected gender in the text field
        let selectedRow = genderPicker.selectedRow(inComponent: 0)
        genderTF.text = genderOptions[selectedRow]
        view.endEditing(true)
    }
    
    func setUpDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        DOBTF.inputView = datePicker
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // Add Done button to the toolbar
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.setItems([doneButton], animated: true)
        
        // Assign toolbar to textField inputAccessoryView
        DOBTF.inputAccessoryView = toolbar
    }
    
    @objc private func doneButtonTapped() {
        // Format the date and set it to the text field
        dateFormatter.dateStyle = .medium
//        dateFormatter.dateFormat = "d MMM yyyy"
        DOBTF.text = dateFormatter.string(from: datePicker.date)
        
        // Dismiss the picker
        view.endEditing(true)
    }
    
    @IBAction func deleteBtnPressed(_ sender: Any) {
        guard let employeeToDelete = selectedEmployee else {
                showAlert(message: "Employee details not found", title: "Error")
                return
            }
        self.deleteEmpDetails(details: employeeToDelete)
        self.navigationController?.popViewController(animated: true)
        self.showAlert(message: "Employee deleted successfully.", title: "Success")
        
    }
    
    @IBAction func editBtnPressed(_ sender: Any) {
        changeALLTFState(isEnabled: true)
        saveButton.isHidden = true
        updateButton.isHidden = false
        deleteButton.isHidden = true
        editButton.isHidden = true
        mobileNumTF.isEnabled = false
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        
    }
    
    
    @IBAction func updateBtnPressed(_ sender: Any) {
        guard let employee = selectedEmployee else {
            showAlert(message: "No employee selected to update.", title: "Error")
            return
        }
//        dateFormatter.dateFormat = "d MMM yyyy"
        // Validate the fields as before
        guard let name = nameTF.text, !name.isEmpty,
              let email = emailTF.text, !email.isEmpty, isValidEmail(email),
              let dob = DOBTF.text, !dob.isEmpty, let dobDate = dateFormatter.date(from: dob),
              let mobile = mobileNumTF.text, !mobile.isEmpty, isValidPhoneNumber(mobile),
              let gender = genderTF.text, !gender.isEmpty,
              let company = companyNameTF.text, !company.isEmpty,
              let designation = designationTF.text, !designation.isEmpty,
              let experience = yearsOfExpTF.text, !experience.isEmpty else {
            
            showAlert(message: "Please fill in all fields correctly.", title: "Warning")
            return
        }
        
        EmployeeDataManager.shared.updateEmployeeDetails(details: employee, updatedName: name, updatedEmail: email, updatedDOB: dobDate, updatedMobile: mobile, updatedGender: gender, updatedCompany: company, updatedDesignation: designation, updatedExperience: experience)
        showAlert(message: "Employee details updated successfully.", title: "Success")
        
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        // Validate all the fields
        
        if let selectedEmployee = selectedEmployee  {
            return
        }
        
        //        dateFormatter.dateFormat = "d MMM yyyy"
        
        guard let name = nameTF.text, !name.isEmpty else {
            showAlert(message: "Name cannot be empty", title: "Warning")
            return
        }
        
        guard let email = emailTF.text, !email.isEmpty, isValidEmail(email) else {
            showAlert(message: "Enter a valid email address", title: "Warning")
            return
        }
        
        if !isEmailUnique(email) {
            showAlert(message: "This email is already used by another employee. Please use a different email.", title: "Warning")
            return
        }
        
        guard let dob = DOBTF.text, !dob.isEmpty, let dobDate = dateFormatter.date(from: dob) else {
            showAlert(message: "Enter a valid date of birth", title: "Warning")
            return
        }
        
        guard let mobile = mobileNumTF.text, !mobile.isEmpty, isValidPhoneNumber(mobile) else {
            showAlert(message: "Enter a valid mobile number", title: "Warning")
            return
        }
        
        guard let gender = genderTF.text, !gender.isEmpty else {
            showAlert(message: "Please select gender", title: "Warning")
            return
        }
        
        guard let company = companyNameTF.text, !company.isEmpty else {
            showAlert(message: "Company name cannot be empty", title: "Warning")
            return
        }
        
        guard let designation = designationTF.text, !designation.isEmpty else {
            showAlert(message: "Designation cannot be empty", title: "Warning")
            return
        }
        
        guard let experience = yearsOfExpTF.text, !experience.isEmpty, let yearsOfExperience = Double(experience) else {
            showAlert(message: "Please enter a valid number for years of experience.", title: "Warning")
            return
        }
        
        // If all fields are valid, proceed to save the data
        EmployeeDataManager.shared.createEmployeeDetails(name: name, email: email, dob: dobDate, mobile: mobile, gender: gender, company: company, designation: designation, experience: experience)
        showAlert(message: "Employee details saved successfully.", title: "Success")
        clearEmployeeFormData()
    }
    
    func clearEmployeeFormData() {
        self.nameTF.text = ""
        self.emailTF.text = ""
        self.DOBTF.text = ""
        self.mobileNumTF.text = ""
        self.genderTF.text = ""
        self.companyNameTF.text = ""
        self.designationTF.text = ""
        self.yearsOfExpTF.text = ""
    }
    
    func isEmailUnique(_ email: String) -> Bool {
        // Fetch request to find employees with the same email
        let fetchRequest = EmployeeDetails.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.isEmpty // If results are empty, the email is unique
        } catch {
            print("Error checking email uniqueness: \(error)")
            return false
        }
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegex = "^[0-9]{10}$" // Example: 10-digit phone number validation
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phoneNumber)
    }
    
    func getEmpDetails() {
        if let fetchedData = EmployeeDataManager.shared.fetchEmployeeDetails() {
            empData = fetchedData
        }
    }
    
    func deleteEmpDetails(details: EmployeeDetails) {
        EmployeeDataManager.shared.deleteEmployeeDetails(details: details)
        self.getEmpDetails()
    }
        
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderOptions.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderOptions[row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTF.text = genderOptions[row]
    }
    
}

extension UIViewController {
    func showAlert(message: String, title: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    
    
}
