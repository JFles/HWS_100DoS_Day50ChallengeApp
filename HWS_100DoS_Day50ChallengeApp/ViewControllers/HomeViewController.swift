//
//  HomeViewController.swift
//  HWS_100DoS_Day50ChallengeApp
//
//  Created by Jeremy Fleshman on 8/17/20.
//  Copyright © 2020 Jeremy Fleshman. All rights reserved.
//

import UIKit

class HomeViewController: UITableViewController {

    // TODO: Add deletion
    // TODO: Add caption editing

    // MARK: - Properties
    var photos = [Photo]()


    // MARK: - Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpNavigationBar()

        loadPhotos()
    }

    fileprivate func setUpNavigationBar() {
        title = "Photos"

        navigationController?.navigationBar.prefersLargeTitles = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(takePicture))

        navigationItem.leftBarButtonItem = editButtonItem
    }

    // MARK: - Selectors
    @objc func takePicture() {
        presentImagePicker()
    }

    // MARK: - Data persistence
    func savePhotos() {
        let defaults = UserDefaults.standard
        let encoder = JSONEncoder()

        if let savedData = try? encoder.encode(photos) {
            defaults.set(savedData, forKey: "Photos")
            print("Succeeded to save data")
        } else {
            print("Failed to save data")
        }
    }

    func loadPhotos() {
        let defaults = UserDefaults.standard
        let decoder = JSONDecoder()

        if let loadedData = defaults.object(forKey: "Photos") as? Data {
            if let loadedPhotos = try? decoder.decode([Photo].self, from: loadedData) {
                print("Succeeded to load pictures")
                photos = loadedPhotos
            } else {
                print("Failed to load photos")
            }
        }
    }
}

// MARK: - ImagePicker methods
extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }

        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }

        dismiss(animated: true) { [weak self] in
            guard let strongSelf = self else { return }

            strongSelf.captionPhoto() { (caption: String) in
                let photo = Photo(fileName: imageName, caption: caption)
                strongSelf.photos.append(photo)

                let row = strongSelf.photos.endIndex - 1
                let indexPath = IndexPath(row: row, section: 0)
                strongSelf.tableView.insertRows(at: [indexPath], with: .automatic)
                strongSelf.savePhotos()
            }
        }
    }

    func captionPhoto(_ completion: @escaping (String) -> Void) {
        let alert = UIAlertController(title: "Photo caption:", message: nil, preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)

        let action = UIAlertAction(title: "OK", style: .default) { _ in
            if let text = alert.textFields?.first?.text { completion(text) }
        }

        alert.addAction(action)

        present(alert, animated: true)
    }

    fileprivate func presentImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
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
        return photos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Photo", for: indexPath)

        cell.textLabel?.text = "\(photos[indexPath.row].caption)"

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = DetailViewController()
        viewController.photo = photos[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            #warning("Can the Data object be deleted from the user directory?")
            photos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            savePhotos()
        } else if editingStyle == .insert {
            captionPhoto() { [weak self] (caption: String) in
                guard let strongSelf = self else { return }

                strongSelf.photos[indexPath.row].caption = caption
                tableView.reloadRows(at: [indexPath], with: .automatic)
                strongSelf.savePhotos()

                strongSelf.isEditing.toggle()
            }
        }
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if isEditing {
            return .insert
        } else {
            return .delete
        }
    }
}

