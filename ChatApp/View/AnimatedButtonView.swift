//
//  AnimatedButtonView.swift
//  swiftContinuedLearning
//
//  Created by Himanshu Karamchandani on 30/09/23.
//

import SwiftUI

struct AnimatedButtonView: View {
    @State var trimValue: CGFloat = 0.95
    @State var isClicked: Bool = false
    @Namespace var animation
    @State var degrees = 0.0
    @State var checkMarkScale = 0.0
    var body: some View {
        VStack {
            
            if isClicked {
                ZStack {
                    RoundedRectangle(cornerRadius: 35,style: .continuous)
                        .trim(from: 0.0,to: trimValue)
                        .stroke()
                        .matchedGeometryEffect(id: "animation", in: animation)
                        .frame(width: 70,height: 70)
                        .rotationEffect(.degrees(degrees))
                    
                    Image(systemName: "checkmark")
                        .foregroundColor(.green)
                        .font(.title2)
                        .bold()
                        .scaleEffect(checkMarkScale)
                }
            } else {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .matchedGeometryEffect(id: "animation", in: animation)
                        .frame(width: 120,height: 60)
                        
                    HStack {
                        Spacer()
                        Image(systemName: "cart.fill")
                            .foregroundColor(.white)
                        Text("Buy")
                            .foregroundColor(.white)
                        Spacer()
                    }
                }
                .onTapGesture {
                    withAnimation {
                        isClicked.toggle()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        withAnimation(.linear(duration: 1.0).repeatCount(2,autoreverses: false)) {
                            degrees = 360
                        }
                        
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation(.linear) {
                            trimValue = 1.0
                            checkMarkScale = 1.0
                        }
                    }
                }
            }
        }
       

    }
}

struct AnimatedButtonView_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedButtonView()
    }
}
