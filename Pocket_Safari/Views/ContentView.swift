//
//  ContentView.swift
//  Pocket_Safari
//
//  Created by iOS Lab on 27/08/24.
//

import SwiftUI

struct ContentView: View {
    let colorP = ColorPalette()
    
    var body: some View {
        NavigationBarView()
            .ignoresSafeArea(.all)
    }
}

#Preview {
    ContentView()
}
