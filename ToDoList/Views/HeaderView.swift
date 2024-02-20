//
//  HeaderView.swift
//  ToDoList
//
//  Created by Hamada Salhab on 04.02.2024.
//

import SwiftUI

struct HeaderView: View {
    let title: String
    let subtitle: String
    let rotationAngle: Double
    let backgroundColor: Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(backgroundColor)
                .rotationEffect(Angle(degrees: rotationAngle))
            
            VStack {
                Text(title)
                    .font(.system(size: 50))
                    .bold()
                    .foregroundColor(Color.white)
                
                Text(subtitle)
                    .font(.system(size: 30))
                    .foregroundColor(Color.white)
            }
            .padding(.top, 80)
        }
        .frame(width: UIScreen.main.bounds.width * 3, height: 350)
        .offset(y: -150)
        
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(title: "title", subtitle: "subtitle", rotationAngle:  15, backgroundColor: Color.blue)
    }
}
