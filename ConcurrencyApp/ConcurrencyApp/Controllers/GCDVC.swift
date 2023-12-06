//
//  GCDVC.swift
//  ConcurrencyApp
//
//  Created by Kate on 06/12/2023.
//

import UIKit

let url = URL(string: "https://jsonplaceholder.typicode.com/photos?albumId=1")!
let session = URLSession.shared

final class GCDVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - closure example
        
        getPhotos() { [weak self] photos in
            self?.getPhoto(imageURLStr: photos[0].url) { [weak self] image in
                DispatchQueue.main.async {
                    self?.imageView.image = image
                    self?.activityIndicatorView.stopAnimating()
                }
            }
        }
        /// поскольку код должен быть написан как серия обработчиков завершения, вы в конечном итоге пишете вложенные замыкания. В этом стиле более сложный код с глубокой вложенностью может быстро стать громоздким.
    }

    private func getPhotos(closure: @escaping ([Photo]) -> ()) {
        session.dataTask(with: url) { data, _, error in
            guard let data,
                  let photos = try? JSONDecoder().decode([Photo].self,
                                                         from: data) else { return }
            closure(photos)
        }.resume()
    }
    
    private func getPhoto(imageURLStr: String,
                          closure: @escaping (UIImage) -> ()) {
        guard let url = URL(string: imageURLStr) else { return }
        session.dataTask(with: url) { data, _, _ in
            guard let data,
                  let image = UIImage(data: data) else { return }
            closure(image)
        }.resume()
    }
}
