//
//  CameraView.swift
//  Pocket_Safari
//
//  Created by iOS Lab on 27/08/24.
//
import SwiftUI

struct CameraView: View {
    let colorP = ColorPalette()
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
            Text("CameraView")
        }
    }
}