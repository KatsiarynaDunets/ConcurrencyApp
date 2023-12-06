//
//  ViewController.swift
//  ConcurrencyApp
//
//  Created by Kate on 06/12/2023.
//

import UIKit

class AsynchronousFunctionsVC: UIViewController {
    
    let itemLoader = ItemLoader()
    let fileLoader = FileLoader()

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - await example
        Task {
            do {
                imageView.image = try await getImage()
                imageView.image = try await getImageWithSleep()
                activityIndicatorView.stopAnimating()
            } catch {
                print(error)
            }
        }
    }
    
    func getImage() async throws -> UIImage? {
        let photos = try await itemLoader.loadPhotos(from: url)
        guard let url = URL(string: photos[1].url) else { return nil }
        let file = try await fileLoader.downloadFile(from: url)
        let data = try Data(contentsOf: file.localURL)
        let image = UIImage(data: data)
        return image
    }
    
    func getImageWithSleep() async throws -> UIImage? {
        try await Task.sleep(until: .now + .seconds(5), clock: .continuous)
        return #imageLiteral(resourceName: "kariby-more-most-zelen")
    }
}

// MARK: - ItemLoader

struct ItemLoader {
    func loadPhotos(from url: URL) async throws -> [Photo] {
        let (data, response) = try await session.data(from: url)
        return try JSONDecoder().decode([Photo].self, from: data)
    }
}

// MARK: - FileLoader

struct File {
    let localURL: URL
    // тут могут лежать любые данные по скаченному File
}

struct FileLoader {
    func downloadFile(from url: URL) async throws -> File {
        let (localURL, response) = try await session.download(from: url)
        return File(localURL: localURL)
    }
}
