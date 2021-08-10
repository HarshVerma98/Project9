//
//  ViewController.swift
//  Project9 Challenge1
//
//  Created by Harsh Verma on 10/08/21.
//

import UIKit

class ViewController: UIViewController {
    
    var ids: String = "cell"
    var pics = [String]()
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Storm Viewer"
        table.delegate = self
        table.dataSource = self
        performSelector(inBackground: #selector(readFromDisk), with: nil)
        
        // Do any additional setup after loading the view.
    }
    

    @objc func readFromDisk() {
        let Manager = FileManager.default
        let path = Bundle.main.resourcePath!
        let item = try! Manager.contentsOfDirectory(atPath: path)
        
        for images in item {
            if images.hasPrefix("nssl") {
                pics.append(images)
            }
        }
        pics.sort()
        table.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        
    }
    
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = pics[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
        let vc = DetailViewController()
        vc.selectedImage = pics[indexPath.row]
        vc.title = "\(indexPath.row + 1) of \(pics.count)"
        navigationController?.pushViewController(vc, animated: true)
    }
}
