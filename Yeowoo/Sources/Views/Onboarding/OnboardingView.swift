//
//  OnboardingView.swift
//  Yeowoo
//
//  Created by 김용주 on 2023/07/29.
//

import SwiftUI
import UIKit

struct OnboardingView: View {
    @State private var selectedPage = 0
    var body: some View {
        VStack {
            ZStack {
                TabView(selection: $selectedPage) {
                    PageOne()
                        .tag(0)
                    Color.blue
                        .tag(1)
                    Color.green
                        .tag(2)
                    Color.yellow
                        .tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                VStack(spacing: 0) {
                    Spacer()
                    
                    HStack(spacing: UIScreen.getWidth(10)) {
                        ForEach(0..<4) { pageNumber in
                            Circle()
                                .fill(
                                    selectedPage == pageNumber ?
                                    Color.mainColor : Color("G5")
                                )
                                .frame(width: 8, height: 8)
                        }
                    }
                    
                    Spacer()
                        .frame(height: UIScreen.getHeight(20))
                }
                
            }
            Spacer()
                .frame(height: UIScreen.getHeight(selectedPage == 3 ? 20 : 74))
            if selectedPage == 3 {
                Button(action: {
                    
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color.mainColor)
                            .frame(width: UIScreen.getWidth(350), height: UIScreen.getHeight(54))
                        
                        Text("시작하기")
                            .foregroundColor(.white)
                            .font(.custom18bold())
                    }
                }
            }
        }
    }
}

private extension OnboardingView {
    
    @ViewBuilder
    func PageOne() -> some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: UIScreen.getHeight(73))
                
                HStack {
                    Text("함께 여행할 친구들을 초대해\n우리만의 공유앨범을 만들어 보세요")
                        .font(.custom22bold())
                        .lineSpacing(5)
                        .padding(.leading, UIScreen.getWidth(20))
                    
                    Spacer()
                }
                
                Spacer()
                    .frame(height: UIScreen.getHeight(40))
                
                ZStack {
                    Rectangle()
                    
                    VStack {
                        Spacer()
                        
                        LinearGradient(gradient: Gradient(colors: [.clear, .white]), startPoint: UnitPoint(x: 0.5, y: 0), endPoint: UnitPoint(x: 0.5, y: 0.5))
                            .frame(height: UIScreen.getHeight(100))
                    }
                }
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
