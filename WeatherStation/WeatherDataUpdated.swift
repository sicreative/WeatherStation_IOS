//
//  WeatherDataUpdated.swift
//  WeatherStation
//
//  Created by slee on 27/11/2019.
//  Copyright © 2019 sclee. All rights reserved.
//

import SwiftUI
import Combine

final class WeatherDataUpdated: ObservableObject {
    @Published var updated:Bool = false
}

