//
//  Constants.swift
//  Festival-App
//
//  Created by Duminica Octavian on 21/02/2018.
//  Copyright © 2018 Duminica Octavian. All rights reserved.
//

import Foundation

enum Stages: String {
    case Main = "Main"
    case Resistance = "Resistance"
    case Live = "Live"
    case Oasis = "Oasis"
}

typealias CompletionHandler = (_ Success: Bool) -> ()

let USER_MENU_OPTIONS = ["Home", "News", "Artists", "Lineup", "Accomodation", "Merch"]
let PRODUCT_CATEGORIES = ["Men", "Women", "Accesories", "Music"]
let USER_MENU_CELL_IDENTIFIER = "userMenuCell"
let ARTIST_CELL_IDENTIFIER = "artistCell"
let PRODUCT_CATEGORY_CELL_IDENTIFIER = "productCategoryCell"
let NEWS_CELL_IDENTIFIER = "newsCell"
let PRODUCT_CELL_IDENTIFIER = "productCell"
let PRODUCT_VC_IDENTIFIER = "MerchVC"

// URL Constants
//let BASE_URL = "http://localhost:3000"
let BASE_URL = "https://pacific-anchorage-10639.herokuapp.com"
let URL_GET_ARTISTS = "\(BASE_URL)/artists"
let URL_GET_PRODUCTS = "\(BASE_URL)/products"

// Notification Constants
let NOTIF_USER_DATA_DID_CHANGE = Notification.Name("notifUserDataChanged")
let NOTIF_CHANNELS_LOADED = Notification.Name("channelsLoaded")
let NOTIF_CHANNEL_SELECTED = Notification.Name("channelSelected")

// Segues
let TO_LOGIN = "toLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWIND = "unwindToChannel"
let TO_AVATAR_PICKER = "toAvatarPicker"

// User Defaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"

// Headers
let HEADER = [
    "Content-Type" : "application/json; charset=utf-8"
]
