//
//  ArtistCell.swift
//  Festival-App
//
//  Created by Duminica Octavian on 22/02/2018.
//  Copyright © 2018 Duminica Octavian. All rights reserved.
//

import UIKit

let cache = NSCache<AnyObject, AnyObject>()

class ArtistCell: UITableViewCell {
    
    static let identifier = "artistCell"

    @IBOutlet weak var artistNameLbl: UILabel!
    @IBOutlet weak var artistImageView: UIImageView!
    var imageUrlString: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(artist: Artist) {
        artistNameLbl.text = artist.name
        //artistImageView.image = UIImage(named: "\(artist.name!)")
        
        imageUrlString = artist.artistImageURL
        
        let imageUrl = URL(string: artist.artistImageURL)!
        
        self.artistImageView.image = nil
        
        if let imageFromCache = cache.object(forKey: artist.artistImageURL as AnyObject) as? UIImage {
            self.artistImageView.image = imageFromCache
            return
        }
        
        // Start background thread so that image loading does not make app unresponsive
        DispatchQueue.global(qos: .userInitiated).async {
        
            let imageData = NSData(contentsOf: imageUrl)!
        
            // When from background thread, UI needs to be updated on main_queue
            DispatchQueue.main.async {
                let imageToCache = UIImage(data: imageData as Data)
                
                if self.imageUrlString == artist.artistImageURL {
                    self.artistImageView.image = imageToCache
                }
                
                cache.setObject(imageToCache!, forKey: artist.artistImageURL as AnyObject)
            }
        }
    }
    
    var didRequestToShowDetails: ((_ cell:UITableViewCell) -> ())?
    
    @IBAction func onDetailsPressed(_ sender: Any) {
        self.didRequestToShowDetails?(self)
    }
}
