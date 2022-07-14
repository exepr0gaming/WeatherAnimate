//
//  ContentView.swift
//  WeatherAnimate
//
//  Created by Курдин Андрей on 11.07.2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        HomeView()
					.preferredColorScheme(.dark)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
