//
//  DetailViewController.swift
//  HWS_100DoS_Day50ChallengeApp
//
//  Created by Jeremy Fleshman on 8/17/20.
//  Copyright © 2020 Jeremy Fleshman. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var photo: Photo?

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true

        return imageView
    }()

    override func loadView() {
        super.loadView()

        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        
        if let photo = photo {
            title = photo.caption

            let photoName = photo.fileName
            let path = getDocumentsDirectory().appendingPathComponent(photoName)

            imageView.image = UIImage(contentsOfFile: path.path)
        }
    }
}
