//
//  AddAccommodationView.swift
//  Festival-App
//
//  Created by Octavian Duminica on 10/08/2018.
//  Copyright © 2018 Duminica Octavian. All rights reserved.
//

import Foundation

protocol AddAccommodationView: class {
    func centerMapOnUserLocation(withLatitude latitude: Double, andLongitude longitude: Double)
    func setupScrollView()
    func minimizeMap()
    func navigateToAccommodationScreen()
    func displayImagePicker()
    func roundButtons()
    func setupButtonsImageViews()
    func startActivityIndicator()
    func stopActivityIndicator()
}