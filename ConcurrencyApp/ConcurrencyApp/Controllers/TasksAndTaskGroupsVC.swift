//
//  File.swift
//  ConcurrencyApp
//
//  Created by Kate on 06/12/2023.
//

import UIKit

class TasksAndTaskGroupsVC: UIViewController {
    
    let fileLoader = FileLoader()

    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - await example

        let task = Task {
            do {
                let images = try await fetchImages()
                imageView1.image = images[0]
                imageView2.image = images[1]
                imageView3.image = images[2]
                activityIndicatorView.stopAnimating()
            } catch {
                print(error)
            }
        }
//        print(task.isCancelled)
//        task.cancel()
//        print(task.isCancelled)
    }
    
    func fetchImages() async throws -> [UIImage?] {
        
        let urls = [urlImg1, urlImg2, urlImg3]
        
        return try await withThrowingTaskGroup(of: UIImage?.self) { group in
            var images = [UIImage?]()

            // adding tasks to the group and fetching movies
            for url in urls {
                group.addTask {
                    return try await self.getImage(url: url)
                }
            }

            // grab movies as their tasks complete, and append them to the `movies` array
            for try await image in group {
                images.append(image)
                print(image as Any)
                print(Date())
            }

            return images
        }
    }
    
    func getImage(url: URL) async throws -> UIImage? {
        let file = try await fileLoader.downloadFile(from: url)
        let data = try Data(contentsOf: file.localURL)
        let image = UIImage(data: data)
        return image
    }
}
