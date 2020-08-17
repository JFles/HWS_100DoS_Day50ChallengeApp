//
//  HomeViewController.swift
//  HWS_100DoS_Day50ChallengeApp
//
//  Created by Jeremy Fleshman on 8/17/20.
//  Copyright © 2020 Jeremy Fleshman. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationBar()
    }

    fileprivate func setUpNavigationBar() {
        title = "Photos"

        navigationController?.navigationBar.prefersLargeTitles = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(takePicture))
    }

    // MARK: - Selectors
    @objc func takePicture() {
        presentImagePicker()
    }

    // MARK: - Data persistence
    func save() {
        #warning("Implement")
    }

    func load() {
        #warning("Implement")
    }
}

// MARK: - ImagePicker methods
extension HomeViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        #warning("Implement")
        // TODO: Save photo to the camera roll
            // UIImageWriteToSavedPhotosAlbum(_:_:_:_:)
                // includes parameters for completion block
                // can use this to trigger the captioning alertVC
        // TODO: Add ability to caption the photo after it is saved
            // ability to add a VC dismissal completion block that displays a textfield alert to add the caption?
        // TODO: Save the photo URL to data model
            // UIImagePickerController.InfoKey.imageURL
            // Should this be handled as a completion of the alert?
            // Could possibly be saved at the same time as the completed caption
    }

    fileprivate func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false // FIXME: Should this be T or F?
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
        } else {
            imagePicker.sourceType = .photoLibrary
            print("Camera unavailable on this device")
        }
        present(imagePicker, animated: true)
    }
}

// MARK: - TableView methods
extension HomeViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Photo", for: indexPath)

        cell.textLabel?.text = "Foo \(indexPath.row)"

        return cell
    }
}

