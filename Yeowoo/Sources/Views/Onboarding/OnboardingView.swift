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
		NavigationView {
			ZStack {
				TabView(selection: $selectedPage) {
					PageOne()
						.tag(0)
					PageTwo()
						.tag(1)
					PageThree()
						.tag(2)
					PageFour()
						.tag(3)
				}
				.edgesIgnoringSafeArea(.bottom)
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
						.frame(height: UIScreen.getHeight(94))
				}
				VStack {
					Spacer()
					if selectedPage == 3 {
						NavigationLink {
							let appState = AppState()
							LoginCoverView()
								.environmentObject(appState)
								.navigationBarBackButtonHidden()
						} label: {
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
				.padding(.bottom, 10)
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
                    .frame(height: UIScreen.getHeight(63))
                
                HStack {
                    Text("함께 여행할 친구들을 초대해\n우리만의 공유앨범을 만들어 보세요")
                        .font(.custom22bold())
                        .lineSpacing(5)
                        .padding(.leading, UIScreen.getWidth(20))
                    
                    Spacer()
                }
                
                Spacer()
                
                Image("Onboarding1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: UIScreen.getHeight(636))
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    @ViewBuilder
    func PageTwo() -> some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: UIScreen.getHeight(63))
                
                HStack {
                    Text("역할별로 정리된 앨범을 눌러\n친구의 시선으로 여행을 기억해봐요")
                        .font(.custom22bold())
                        .lineSpacing(5)
                        .padding(.leading, UIScreen.getWidth(20))
                    
                    Spacer()
                }
                
                Spacer()
                
                Image("Onboarding2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: UIScreen.getHeight(636))
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    @ViewBuilder
    func PageThree() -> some View {
        ZStack {
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: UIScreen.getHeight(63))
                
                HStack {
                    Text("친구들이 작성한 글과 사진을 보며\n생생하게 여행을 기억해봐요")
                        .font(.custom22bold())
                        .lineSpacing(5)
                        .padding(.leading, UIScreen.getWidth(20))
                    
                    Spacer()
                }
                
                Spacer()
                
                Image("Onboarding3")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: UIScreen.getHeight(636))
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
    
    @ViewBuilder
    func PageFour() -> some View {
        ZStack {
            VStack {
                Spacer()
                
                Image("Onboarding4")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.getWidth(390))
                
                Spacer()
            }
            
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: UIScreen.getHeight(63))
                
                HStack {
                    Text("여우와 함께 여행 중 우리가 함께한\n모든 순간을 기억해봐요")
                        .font(.custom22bold())
                        .lineSpacing(5)
                        .padding(.leading, UIScreen.getWidth(20))
                    
                    Spacer()
                }
                
                Spacer()
            }
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
