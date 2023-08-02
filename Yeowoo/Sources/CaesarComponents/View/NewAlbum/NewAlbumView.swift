//
//  NewAlbum.swift
//  YeoWooSimpleView
//
//  Created by 정회승 on 2023/07/18.
//

import SwiftUI

struct NewAlbumView: View {
	
	@Environment(\.dismiss) var dismiss
    @StateObject var mainViewModel: MainViewModel
	@State var newAlbum = Album()
	@State var selectingFox = false
	@State var albumName: String = ""
	@State private var selectedDate = Date()
	
	var body: some View {
		VStack {
			
			VStack(alignment: .leading){
				
				HStack (spacing: 0){
					Rectangle()
						.frame(width: (UIScreen.width - 50)/3, height: 3)
						.padding(.top, 15)
						.foregroundColor(Color("B1"))
					Rectangle()
						.frame(width: (UIScreen.width - 50)/3*2, height: 3)
						.padding(.top, 15)
						.foregroundColor(Color("B1"))
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
							   displayedComponents: .date)
					.accentColor(Color("B1"))
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
			
			if !albumName.isEmpty {
				NavigationLink{
                    AlbumRoleSelectView(mainViewModel: mainViewModel, newAlbum: self.newAlbum)
						.navigationBarBackButtonHidden()
				} label: {
					Rectangle()
						.frame(width: UIScreen.main.bounds.width - 30, height: 54)
						.foregroundColor(Color("B1"))
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
		.onChange(of: albumName) { newValue in
			self.newAlbum.albumTitle = newValue
		}
		.onChange(of: selectedDate) { newValue in
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "yyyy.MM.dd"
			self.newAlbum.startDay = dateFormatter.string(from: newValue)
		}
		.onAppear {
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "yyyy.MM.dd"
			self.newAlbum.startDay = dateFormatter.string(from: Date())
			self.newAlbum.users.append(UserDefaultsSetting.userDocId)
			
		}
		.onDisappear {
			self.endTextEditing()
		}
	}
}
