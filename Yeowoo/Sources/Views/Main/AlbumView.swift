//
//  AlbumView.swift
//  Yeowoo
//
//  Created by 김용주 on 2023/07/17.
//

import SwiftUI

struct AlbumView: View {
    @State var arr: [Color]
    @State var personCount = 0
    var traveling: Bool
    var travelName: String
    var startDay: String
    var endDay: String
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                ZStack {
                    Text("사진사진사진")
                    
                    RadialGradient(colors: [Color("ButtonColor"), .clear], center: .bottomLeading, startRadius: 0, endRadius: 270)
                        .opacity(0.4)
                }.frame(width: UIScreen.getWidth(350), height: UIScreen.getHeight(190))
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                
                VStack(alignment: .leading, spacing: 0) {
                    traveling == true ? TravelLabel(travelText: "여행중").padding(.top, UIScreen.getHeight(10)) : TravelLabel(travelText: "여행전").padding(.top, UIScreen.getHeight(10))
                    
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
                    if arr.count < 4 {
                        ForEach(arr, id: \.self) { img in
                            Person(person: img)
                        }
                    } else {
                        ForEach(arr[0..<3], id: \.self) { img in
                            Person(person: img)
                        }
                        PlusPerson(plusCount: arr.count-3)
                    }
                    traveling == true ?
                    Text("\(arr.count)명 여행 중")
                        .foregroundColor(Color(uiColor: .systemGray))
                        .padding(.leading, 20) :
                    Text("\(arr.count)명 여행 완료")
                        .foregroundColor(Color(uiColor: .systemGray))
                        .padding(.leading, 20)
                    Spacer()
                }
                .frame(maxWidth: UIScreen.getWidth(330))
            }
        }
    }
}

struct AlbumView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumView(arr: [.blue, .black, .brown, .pink], traveling: true, travelName: "일본 여행", startDay: "2023. 01. 05", endDay: "2023. 01. 20")
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
