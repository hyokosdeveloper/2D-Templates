//
//  Constants.swift
//  CutTheVerlet
//
//  Created by Nick Lockwood on 14/09/2014.
//  Copyright (c) 2014 Nick Lockwood. All rights reserved.
//

import UIKit

//MARK: constants

let BackgroundImage = "Background"
let GroundImage = "Ground"
let WaterImage = "Water"
let RopeTextureImage = "RopeTexture"
let RopeHolderImage = "RopeHolder"
let CrocMouthClosedImage = "CrocMouthClosed"
let CrocMouthOpenImage = "CrocMouthOpen"
let CrocMaskImage = "CrocMask"
let PrizeImage = "Pineapple"
let PrizeMaskImage = "PineappleMask"

let BackgroundMusicSound = "CheeZeeJungle.caf"
let SliceSound = "Slice.caf"
let SplashSound = "Splash.caf"
let NomNomSound = "NomNom.caf"

let RopeDataFile = "RopeData.plist"

struct Layer {
    static let Background: CGFloat = 0
    static let Crocodile: CGFloat = 1
    static let Rope: CGFloat = 1
    static let Prize: CGFloat = 2
    static let Foreground: CGFloat = 3
}

struct Category {
    static let Crocodile: UInt32 = 1
    static let RopeHolder: UInt32 = 2
    static let Rope: UInt32 = 4
    static let Prize: UInt32 = 8
}

//MARK: game configuration

let PrizeIsDynamicsOnStart = false
let CanCutMultipleRopesAtOnce = false
