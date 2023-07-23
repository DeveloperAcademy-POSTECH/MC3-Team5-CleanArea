//
//  AlbumLayout.swift
//  Yeowoo
//
//  Created by 김용주 on 2023/07/17.
//

import SwiftUI

struct AlbumLayout: View {
    @ObservedObject var mainViewModel = MainViewModel()
    
    @State var traveling: Int = 0
    var userId: [String]
    @State var profileImages: [String] = []
    var coverImage: String
    var personCount = 0
    @State var days: Int = 0
    var travelName: String
    var startDay: String
    var endDay: String
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                ZStack {
                    if coverImage != "" {
                        AsyncImage(url: URL(string: coverImage)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            ProgressView()
                        }
                    } else {
                        Text("사진사진사진")
                    }
                    
                    RadialGradient(colors: [Color("ButtonColor"), .clear], center: .bottomLeading, startRadius: 0, endRadius: 270)
                        .opacity(1)
                }.frame(width: UIScreen.getWidth(350), height: UIScreen.getHeight(190))
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    if traveling == 1 {
                        TravelLabel(travelText: "여행중")
                            .padding(.top, UIScreen.getHeight(10))
                    } else if traveling == 0 {
                        TravelLabel(travelText: "D - \(days)").padding(.top, UIScreen.getHeight(10))
                    }
                    
                    Spacer()
                    
                    Text(travelName)
                        .font(.custom24bold())
                        .padding(.bottom, UIScreen.getHeight(10))
                    
                    Text("\(Image(systemName: "calendar")) \(startDay) ~ \(endDay)")
                        .font(.custom12bold())
                    
                    Spacer()
                        .frame(height: UIScreen.getHeight(16))
                }
                .foregroundColor(.white)
                .frame(maxWidth: UIScreen.getWidth(330), maxHeight: UIScreen.getHeight(190), alignment: .leading)
            }
            
            ZStack{
                Rectangle()
                    .foregroundColor(.white)
                    .frame(width: UIScreen.getWidth(350), height: UIScreen.getWidth(50))
                    .cornerRadius(20, corners: [.bottomLeft, .bottomRight])
                    .background(Color.gray
                        .opacity(0.05)
                        .shadow(color: .black, radius: 1, x: 0, y: 5)
                        .blur(radius: 10, opaque: false)
                    )
                
                HStack(spacing: -10) {
                    if profileImages.count < 4 {
                        ForEach(profileImages, id: \.self) { img in
                            Person(person: img)
                        }
                    } else {
                        ForEach(profileImages[0..<3], id: \.self) { img in
                            Person(person: img)
                        }
                        PlusPerson(plusCount: profileImages.count-3)
                    }
                    if traveling == 1 {
                        Text("\(profileImages.count)명 여행 중")
                            .foregroundColor(Color("G3"))
                            .padding(.leading, 20)
                    } else if traveling == 2 {
                        Text("\(profileImages.count)명 여행 완료")
                            .foregroundColor(Color("G3"))
                            .padding(.leading, 20)
                    } else {
                        Text("\(profileImages.count)명 여행 전")
                            .foregroundColor(Color("G3"))
                            .padding(.leading, 20)
                    }
                    Spacer()
                }
                .frame(maxWidth: UIScreen.getWidth(330))
            }
        }
        .onAppear {
            traveling = mainViewModel.compareDate(startDay, endDay)
            print(traveling)
            if mainViewModel.traveling == 0 {
                days = D_Day(startDay)
            }
            mainViewModel.fetchUser(userDocIds: userId)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
                profileImages = []
                for i in 0..<mainViewModel.users.count {
                    profileImages.append(mainViewModel.users[i].profileImage)
                }
            }
            
        }
    }
}

struct CornerRadiusStyle: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner
    
    struct CornerRadiusShape: Shape {

        var radius = CGFloat.infinity
        var corners = UIRectCorner.allCorners

        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            return Path(path.cgPath)
        }
    }

    func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
}
