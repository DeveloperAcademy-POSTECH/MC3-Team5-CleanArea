//
//  DoneTravelLayout.swift
//  Yeowoo
//
//  Created by 김용주 on 2023/07/17.
//

import SwiftUI

struct DoneTravelLayout: View {
    @StateObject var mainViewModel = MainViewModel()
    var userNames: [String]
    var images: [ImagesEntity]
    var nickname: String
    var albumName: String
    @State var picture: [String] = ["", "", ""]
    @State var numbers: [Int] = []
    @State var fetch: Bool = false
    
    var body: some View {
        VStack {
            HStack(spacing: UIScreen.getWidth(10)) {
                VStack(alignment: .leading, spacing: UIScreen.getHeight(3)) {
                    Text("\(nickname)님")
                    Text("\(albumName)").foregroundColor(Color("ButtonColor")) +
                    Text("에서")
                    Text("즐거웠던 추억을 되돌아보세요!")
                }
                Spacer()
            }
            .font(.custom24bold())
            .frame(width: UIScreen.getWidth(350), height: UIScreen.getHeight(102))
            
            ZStack {
                VStack {
                    ZStack {
                        Spacer()
                            .frame(height: UIScreen.getHeight(20))
                        
                        Image("Line")
                        
                        HStack {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: UIScreen.getWidth(48), height: UIScreen.getHeight(7))
                                .background(
                                    LinearGradient(
                                        stops: [
                                            Gradient.Stop(color: .white, location: 0.43),
                                            Gradient.Stop(color: .white.opacity(0), location: 1.00),
                                        ],
                                        startPoint: UnitPoint(x: 0, y: 0.57),
                                        endPoint: UnitPoint(x: 1, y: 0.57)
                                    )
                                )
                            
                            Spacer()
                            
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: UIScreen.getWidth(48), height: UIScreen.getHeight(7))
                                .background(
                                    LinearGradient(
                                        stops: [
                                            Gradient.Stop(color: .white, location: 0.43),
                                            Gradient.Stop(color: .white.opacity(0), location: 1.00),
                                        ],
                                        startPoint: UnitPoint(x: 0, y: 0.57),
                                        endPoint: UnitPoint(x: 1, y: 0.57)
                                    )
                                )
                        }
                    }
                    
                    Spacer()
                }
                HStack(spacing: 18) {
                    ForEach(0..<3) { num in
                        NavigationLink(destination: {
                            if fetch {
                                AlbumDetailView(entitys: images[images.indices.filter({images[$0].url == picture[num]}).first!],
                                                user: mainViewModel.randomUser.first(where: {$0.docId == images[images.indices.filter({images[$0].url == picture[num]}).first!].uploadUser}) ?? User(),
                                                tempLikeState: images[images.indices.filter({images[$0].url == picture[num]}).first!].likeUsers.contains(UserDefaultsSetting.userDocId),
                                                tempLikeCount: images[images.indices.filter({images[$0].url == picture[num]}).first!].likeUsers.count,
                                                viewModel: AlbumViewModel())
                            }
                        }) {
                        TapePicture(picture: picture[num])
                        }
                    }
                }
            }.frame(maxHeight: UIScreen.getHeight(160))
            
            Spacer()
                .frame(height: UIScreen.getHeight(24))
        }
        .task {
            if !fetch {
                mainViewModel.randomPicture(images, &picture)
                
                await mainViewModel.randomImageUsers(userDocIds: userNames)
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                    self.fetch = true
                }
            }
        }
    }
}
