//
//  AsynchronousSequencesVC.swift
//  ConcurrencyApp
//
//  Created by Kate on 06/12/2023.
//

import UIKit

let urlImg1 = URL(string: "https://get.pxhere.com/photo/landscape-mountain-camera-photography-bicycle-dslr-vehicle-taking-photo-tripod-965509.jpg")!
let urlImg2 = URL(string: "https://cdn1.flamp.ru/df271521a12773528a59498632d7ba6a.jpg")!
let urlImg3 = URL(string: "https://get.pxhere.com/photo/man-forest-road-photography-male-model-spring-fashion-black-season-trees-photograph-pose-943075.jpg")!

class AsynchronousSequencesVC: UIViewController {

    let itemLoader = ItemLoader()
    let fileLoader = FileLoader()

    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - await example
        Task {
            do {
                /// Asynchronous Sequences / Асинхронные последовательности
                try await itemLoader.loadPhotosSequences(from: url)
                /// Calling Asynchronous Functions in Parallel / Параллельный вызов асинхронных функций
                let images = try await getImage()
                imageView1.image = images?[0]
                imageView2.image = images?[1]
                imageView3.image = images?[2]
                activityIndicatorView.stopAnimating()
            } catch {
                print(error)
            }
        }
    }
    
    func getImage() async throws -> [UIImage?]? {
        
        // MARK: - await
        let startTime = Date()
        let file1 = try await fileLoader.downloadFile(from: urlImg1)
        let file2 = try await fileLoader.downloadFile(from: urlImg2)
        let file3 = try await fileLoader.downloadFile(from: urlImg3)

        let files = [file1, file2, file3]
        let finishTime = Date()
        print("totalTime = \(startTime.distance(to: finishTime))")
        
        // MARK: - async
//        let startTime = Date()
//        async let file1 = fileLoader.downloadFile(from: urlImg1)
//        async let file2 = fileLoader.downloadFile(from: urlImg2)
//        async let file3 = fileLoader.downloadFile(from: urlImg3)
//
//        let files = try await [file1, file2, file3]
//        let finishTime = Date()
//        print("totalTime = \(startTime.distance(to: finishTime))")
        
        // data
        let data1 = try Data(contentsOf: files[0].localURL)
        let data2 = try Data(contentsOf: files[1].localURL)
        let data3 = try Data(contentsOf: files[2].localURL)
        
        let image1 = UIImage(data: data1)
        let image2 = UIImage(data: data2)
        let image3 = UIImage(data: data3)
        
        return [image1, image2, image3]
    }
}

extension ItemLoader {
    
    func loadPhotosSequences(from url: URL) async throws {

        let (bytes, _) = try await URLSession.shared.bytes(from: url)
        for try await byte in bytes {
          print(byte)
        }
        
        for try await line in url.lines {
            print(line)
        }
    }
}

