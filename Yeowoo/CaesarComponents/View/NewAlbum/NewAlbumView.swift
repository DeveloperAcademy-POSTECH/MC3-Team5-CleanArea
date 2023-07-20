//
//  NewAlbum.swift
//  YeoWooSimpleView
//
//  Created by 정회승 on 2023/07/18.
//

import SwiftUI

struct NewAlbumView: View {
    @Environment(\.dismiss) var dismiss
    @State var selectingFox = false

    //선택된 여우 번호
    @State private var selectedIndex: Int? = nil

    @State var albumName: String = ""

    @State private var selectedDate = Date()
    
    
    var body: some View {
            VStack {

                VStack(alignment: .leading){
                    
                    HStack (spacing: 0){
                        Rectangle()
                            .frame(width: (UIScreen.width - 50)/3, height: 3)
                            .padding(.top, 15)
                        .foregroundColor(.mainColor)
                        Rectangle()
                            .frame(width: (UIScreen.width - 50)/3*2, height: 3)
                            .padding(.top, 15)
                            .foregroundColor(.mainColor)
                            .opacity(0.1)
                    }

                    
                    ZStack {
                        GrayTitleMakingView(placeholder: "앨범 이름", text: $albumName)
                        HStack {
                            Spacer()
                                .frame(width: UIScreen.width - 110)
                            Button {
                                albumName = ""
                         } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                .foregroundColor(.alarmGray)
                            }
                        }
                    }
                    .padding(.top, 30)

                    
                    ZStack {
                        
                        DatePicker("여행 시작일",
                                               selection: $selectedDate,
                                               in: Date()...,
                                   // only dates from today onwards
                                               displayedComponents: .date)
                                        .accentColor(.mainColor)
                                        .padding()
                                    .frame(width: UIScreen.width - 50 ,height: 44)
                        
                    }
                    .padding(.top, 10)
                    .background(RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.whiteGray2)
                        .frame(width: UIScreen.width - 50 ,height: 50)
                        .padding(.top, 10))

                }
                
                
                Spacer()



                // 버튼
                if !albumName.isEmpty {
                    NavigationLink{
                            //선택 완료(선택된 albumName, Date() 넘기기)
                        AlbumRoleSelectView()
                            .navigationBarBackButtonHidden()

                        } label: {
                            Rectangle()
                                .frame(width: UIScreen.main.bounds.width - 30, height: 54)
                                .foregroundColor(Color.mainColor)
                                .cornerRadius(10)
                                .overlay(Text("다음").font(.system(size: 18, weight: .bold, design: .default)).foregroundColor(Color.white))
                                .padding(.bottom, 20)
                        }
                    
                } else {
                        Rectangle()
                            .frame(width: UIScreen.main.bounds.width - 30, height: 54)
                            .foregroundColor(Color.unclicked)
                            .cornerRadius(10)
                            .overlay(Text("다음").font(.system(size: 18, weight: .bold, design: .default)).foregroundColor(Color.white))
                            .padding(.bottom, 20)
                }
            }
            .navigationTitle(Text("새 앨범 만들기"))
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.white)
            .modifier(BackToolBarModifier())
    }
}

struct NewAlbumView_Previews: PreviewProvider {
    static var previews: some View {
        NewAlbumView(albumName: "제주도 여행")
    }
}
