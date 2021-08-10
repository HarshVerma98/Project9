//
//  ViewController.swift
//  Project9
//
//  Created by Harsh Verma on 10/08/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    var petition = [Petition]()
    var filteredResult = [Petition]()
    var keyWord: String = ""
    var url: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(didPressCredits))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(didPressFilter))
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "White House Petitions"
        if navigationController?.tabBarItem.tag == 0 {
            url = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            url = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        table.delegate = self
        table.dataSource = self
        DispatchQueue.global(qos: .userInitiated).async { [self] in
            if let urlString = URL(string: url) {
                if let data = try? Data(contentsOf: urlString) {
                    self.parseJSON(json: data)
                }else {
                    print("Error")
                }
            }else {
                print("Error")
            }
        }
        
    }

    func parseJSON(json: Data) {
        if let obtained = try? JSONDecoder().decode(Petitions.self, from: json) {
            petition =  obtained.results
            DispatchQueue.main.async { [weak self] in
                self?.table.reloadData()
            }
            
        }
    }
    
    func filterData() {
        if keyWord.isEmpty {
            filteredResult = petition
            navigationItem.leftBarButtonItem?.title = "Filter"
            return
        }
        navigationItem.leftBarButtonItem?.title = "Filter (current: \(keyWord))"
        filteredResult = petition.filter({ pet in
            if let _ = pet.title.range(of: keyWord, options: .caseInsensitive) {
                return true
            }
            if let _ = pet.body.range(of: keyWord, options: .caseInsensitive) {
                return true
            }
            return false
        })
        
    }
    
    @objc func didPressCredits() {
        let alert = UIAlertController(title: "This data comes from:", message: "We The People API of the WhiteHouse", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    @objc func didPressFilter() {
        let alert = UIAlertController(title: "Filter", message: "Enter the text to look for", preferredStyle: .alert)
        alert.addTextField()
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "LookUp", style: .default, handler: { _ in
            self.keyWord = alert.textFields?[0].text ?? ""
            self.filterData()
            self.table.reloadData()
        }))
        present(alert, animated: true)
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petition.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = petition[indexPath.row].title
        cell.detailTextLabel?.text = petition[indexPath.row].body
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
        let vc = DetailViewController()
        vc.details = petition[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
