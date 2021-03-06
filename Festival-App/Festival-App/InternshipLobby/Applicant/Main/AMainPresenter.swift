//
//  AMainPresenter.swift
//  Festival-App
//
//  Created by Octavian Duminica on 15/01/2019.
//  Copyright © 2019 Duminica Octavian. All rights reserved.
//

import Foundation

class AMainPresenter {
    
    weak var view: AMainView?
    
    var numberOfOffers: Int {
        return OfferService.shared.offers.count
    }
    
    init(view: AMainView) {
        self.view = view
    }
    
    func configure(_ itemView: AOfferItemView, at index: Int) {
        let offer = OfferService.shared.offers[index]
        
        itemView.displayTitle(offer.title)
        itemView.displayImage(offer.companyImageURL)
    }
    
    func loadOffers() {
        view?.startActivityIndicator()
        OfferService.shared.getAllOffers { [weak self] (success) in
            self?.view?.stopActivityIndicator()
            
            if success {
                self?.view?.reloadData()
            } else {
                self?.view?.displayAlert(title: "Info", message: "Failed to get offers.")
            }
        }
    }
    
    func removeOffers() {
        OfferService.shared.clearOffers()
    }
    
    func didSelectRow(at index: Int) {
        view?.navigateToDetails(at: index)
    }
}
