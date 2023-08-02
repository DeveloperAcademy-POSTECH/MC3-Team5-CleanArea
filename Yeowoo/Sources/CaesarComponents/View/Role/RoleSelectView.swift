//
//  RoleSelectView.swift
//  YeoWooSimpleView
//
//  Created by 정회승 on 2023/07/14.
//

import SwiftUI

struct RoleSelectView: View {
	
	@EnvironmentObject var appState: AppState
	
    @Environment(\.dismiss) var dismiss
    @State var selectingFox = false
    //선택된 여우 번호
    @State private var selectedIndex: Int? = nil
	
	let noti: Notification
//	var mockData: MockModel
	@ObservedObject var viewModel = InvitationViewModel()
    @StateObject var mainViewModel: MainViewModel
    
    var body: some View {
            VStack {

                    Rectangle()
                        .frame(width: UIScreen.width - 50, height: 3)
                        .padding(.top, 15)
                    .foregroundColor(.mainColor)


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
                LazyVGrid(columns: [
                    .init(.flexible(), spacing: 2),
                    .init(.flexible(), spacing: 2),
                    .init(.flexible(), spacing: 2)
                ], spacing: 30) {
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
                    Button{
                        print("selected fox is number \(selectedIndex ?? -1)")
						print("selected fox \(foxs[selectedIndex ?? 0].foxImage)")
						
						print("@@ \(noti.albumId)")
						
						Task {
							try await viewModel.participateTravel(albumDocId: noti.albumId, role: foxs[selectedIndex ?? 0].foxImage, noti: noti)
                            mainViewModel.finishedFetch = false
                            mainViewModel.openAlarm.toggle()
                            try await mainViewModel.loadAlbum()
						}
						

						// 이거하고 메인으로 가야함
						// 추후에 메인이랑 연결해야함
						// self.appState.moveToRootView = true

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
