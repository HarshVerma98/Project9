//
//  DetailViewController.swift
//  Project9 Challenge1
//
//  Created by Harsh Verma on 10/08/21.
//

import UIKit

class DetailViewController: UIViewController {

    var imageView: UIImageView!
    var selectedImage: String?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        createLayout()
        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didPressShare))
        navigationItem.largeTitleDisplayMode = .never
        imageView.image = UIImage(named: selectedImage!)
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(imageView)
        imageView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    func createLayout() {
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
    }
    
    @objc func didPressShare() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.2) else {
            return
        }
        let vc = UIActivityViewController(activityItems: [image, selectedImage!], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true, completion: nil)
    }
    

}
