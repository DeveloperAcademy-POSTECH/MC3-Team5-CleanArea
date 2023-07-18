//
//  AlbumRoleSelectView.swift
//  YeoWooSimpleView
//
//  Created by 정회승 on 2023/07/18.
//

import SwiftUI

struct AlbumRoleSelectView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var selectingFox = false
    //선택된 여우 번호
    @State private var selectedIndex: Int? = nil
    
    //그리드 아이템
    private let gridItems: [GridItem] = [
        .init(.flexible(), spacing: 2),
        .init(.flexible(), spacing: 2),
        .init(.flexible(), spacing: 2)
    ]


    
    
    var body: some View {
        NavigationView {
            VStack {
                
                HStack (spacing: 0){
                    Rectangle()
                        .frame(width: (UIScreen.width - 50)/3*2, height: 3)
                        .padding(.top, 15)
                    .foregroundColor(.mainColor)
                    Rectangle()
                        .frame(width: (UIScreen.width - 50)/3, height: 3)
                        .padding(.top, 15)
                        .foregroundColor(.mainColor)
                        .opacity(0.1)
                }

                VStack(alignment: .leading){
                    Text("여행에서 맡고 싶은 역할을")
                    Text("선택해주세요")
                }
                .font(.system(size: 24, weight: .bold, design: .default))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
                .padding(.top, 30)
                
                Spacer()
                //FoxGrid 3x2
                LazyVGrid(columns: gridItems, spacing: 30) {
                    ForEach(0..<6, id: \.self) { id in
                        FoxCardView(fox: foxs[id], isSelected: selectedIndex == id)
                            .onTapGesture {
                                //한번 더 누르면 해제
                                selectedIndex = selectedIndex == id ? nil : id
                            }
                    }
                }
                
                Spacer()

                // 버튼
                if selectedIndex != nil {
                    NavigationLink{
                            //선택 완료(선택된 selectedIndex 넘기기)
                        FindFriendView()
                            .navigationBarBackButtonHidden()
                            
                            
                        } label: {
                            Rectangle()
                                .frame(width: UIScreen.main.bounds.width - 30, height: 54)
                                .foregroundColor(Color.mainColor)
                                .cornerRadius(10)
                                .overlay(Text("선택완료").font(.system(size: 18, weight: .bold, design: .default)).foregroundColor(Color.white))
                                .padding(.bottom, 20)
                        }
                    
                } else {
                        Rectangle()
                            .frame(width: UIScreen.main.bounds.width - 30, height: 54)
                            .foregroundColor(Color.unclicked)
                            .cornerRadius(10)
                            .overlay(Text("선택완료").font(.system(size: 18, weight: .bold, design: .default)).foregroundColor(Color.white))
                            .padding(.bottom, 20)
                }
            }
            .navigationTitle(Text("역할 선택하기"))
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.white)
            .modifier(BackToolBarModifier())

        }
    }
}

struct AlbumRoleSelectView_Previews: PreviewProvider {
    static var previews: some View {
        AlbumRoleSelectView()
    }
}
