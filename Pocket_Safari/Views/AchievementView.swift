//
//  AchievementView.swift
//  Pocket_Safari
//
//  Created by iOS Lab on 27/08/24.
//

import SwiftUI

struct AchievementView: View {
    let colorP = ColorPalette()
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(colorP.c3)
            Text("AchievmentView")
        }
    }
}
