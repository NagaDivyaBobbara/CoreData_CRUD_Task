//
//  EmployeeListViewController.swift
//  CRUDApp
//
//  Created by Naga Divya Bobbara on 07/11/24.
//

import UIKit
import Network

class EmployeeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var employeeListTableView: UITableView!
    public static let cellIdentifier = "FIBExplanationTableViewCell"
    let dateFormatter = DateFormatter()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var empData = [EmployeeDetails]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        employeeListTableView.register(UINib(nibName: EmployeeDetailsTableViewCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: EmployeeDetailsTableViewCell.cellIdentifier)
        dateFormatter.dateFormat = "d MMM yyyy"

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getEmpDetails()
        self.employeeListTableView.reloadData()
    }
    
    @IBAction func addEmpPressed(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let employeeProfileInfoVC = storyboard.instantiateViewController(identifier: "ProfileInfoViewController")
        self.navigationController?.pushViewController(employeeProfileInfoVC, animated: true)
    }
    
    func getEmpDetails() {
        if isInternetAvailable() {
                // Fetch data from API
                NetworkManager.shared.getAllUsers { result in
                    switch result {
                    case .success(let data):
                        // Assume 'data' is the fetched employee data and it's ready to be saved into Core Data
                        let employeeDetails = self.parseEmployeeData(data)
                        EmployeeDataManager.shared.saveEmployeeDetails(employeeDetails)
                        self.empData = employeeDetails
                        DispatchQueue.main.async {
                            self.employeeListTableView.reloadData()
                        }
                    case .failure(let error):
                        print("Error fetching data from API: \(error)")
                        self.fetchAndReloadData()
                    }
                }
            } else {
                // No internet: Fetch data from Core Data
                fetchAndReloadData()
            }
        }
    
    func fetchAndReloadData() {
        if let fetchedData = EmployeeDataManager.shared.fetchEmployeeDetails() {
            self.empData = fetchedData
            DispatchQueue.main.async {
                self.employeeListTableView.reloadData()
            }
        }
    }
    
    func parseEmployeeData(_ data: [String: Any]) -> [EmployeeDetails] {
        var employeeDetails = [EmployeeDetails]()

        // Assuming the "users" array exists in the response
        if let users = data["users"] as? [[String: Any]] {
            for user in users {
                if let name = user["name"] as? String,
                   let email = user["email"] as? String,
                   let dobString = user["dob"] as? String,
                   let mobile = user["mobile"] as? String,
                   let gender = user["gender"] as? String,
                   let company = user["company"] as? String,
                   let designation = user["designation"] as? String,
                   let experience = user["experience"] as? String {

                    // Convert dobString to a Date object
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    guard let dob = dateFormatter.date(from: dobString) else {
                        print("Invalid date format for dob")
                        continue
                    }

                    // Create a new EmployeeDetails object (Core Data entity or custom class)
                    let employee = EmployeeDetails(context: context) // Or use EmployeeModel for a custom class
                    employee.name = name
                    employee.email = email
                    employee.dob = dob
                    employee.mobile = mobile
                    employee.gender = gender
                    employee.company = company
                    employee.designation = designation
                    employee.experience = experience

                    // Add to the array of employees
                    employeeDetails.append(employee)
                }
            }
        }

        return employeeDetails
    }


}

extension EmployeeListViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return empData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let details = empData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: EmployeeDetailsTableViewCell.cellIdentifier, for: indexPath) as! EmployeeDetailsTableViewCell
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none

        let dobString = dateFormatter.string(from: details.dob ?? Date())
        cell.nameLabel.text = details.name
        cell.emailLabel.text = details.email
        cell.dobLabel.text = dobString
        print("")
        cell.mobileNumberLabel.text = details.mobile
        
        cell.selectionStyle  = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEmployee = empData[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let employeeProfileInfoVC = storyboard.instantiateViewController(identifier: "ProfileInfoViewController") as? ProfileInfoViewController {
            // Pass the selected employee data to ProfileInfoViewController
            employeeProfileInfoVC.selectedEmployee = selectedEmployee
            self.navigationController?.pushViewController(employeeProfileInfoVC, animated: true)
        }
    }
}

extension UIViewController {
    
    func isInternetAvailable() -> Bool {
        let monitor = NWPathMonitor()
        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)
        
        var isConnected = false
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                isConnected = true
            } else {
                isConnected = false
            }
        }
        
        // Wait for network status to be updated
        sleep(1)  // Sleep to allow network status to be updated before returning
        
        monitor.cancel()
        return isConnected
    }
}

//struct EmployeeDetail {
//    var name: String
//    var email: String
//    var dob: Date?
//    var mobile: String
//}
