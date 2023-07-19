//
//  ContentView.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/06.
//

import SwiftUI

struct ContentView: View {
	
	init() {
		UINavigationBar.appearance().backgroundColor = .white
	}
	
	@State private var showingAlert = false
	@State private var showingSheet = false
	@State private var name = ""
	
	var body: some View {
		NavigationView {
			NavigationLink("테스트") {
				AlbumView(albumDocId: "T9eJMPQEGQClFHEahX6r")
					.navigationBarTitle("타이틀")
					.navigationBarTitleDisplayMode(.inline)
					.navigationBarItems(
						trailing:
							Menu {
								Button {
									print("앨범 제목 수정하기")
									// 바텀시트
									showingSheet = true
								} label: {
									Label("앨범 제목 수정하기", systemImage: "pencil")
								}
								Button(role: .destructive) {
									print("여행 종료하기")
									// alert
									showingAlert = true
								} label: {
									Label("여행 종료하기", systemImage: "xmark.circle")
								}
							}
						label: {
							Image(systemName: "ellipsis")
						}
							.sheet(isPresented: $showingSheet) {
								VStack(spacing: 24) {
									Text("앨범 제목 수정하기")
									TextField("20자 이내로 입력해주세요", text: $name)
										.padding()
										.background(Color(uiColor: .secondarySystemBackground))
										.cornerRadius(10)
										.onAppear {
											UITextField.appearance().clearButtonMode = .whileEditing
										}
									Button {
										print("완료")
									} label: {
										Rectangle()
											.fill(Color.green)
											.frame(height: 54)
											.cornerRadius(10)
											.overlay {
												Text("완료")
											}
									}
								}
								.padding(.horizontal, 20)
								.presentationDetents([.height(250)])
							}
						
							.alert(isPresented: $showingAlert) {
								Alert(
									title: Text("여행 종료"),
									message: Text("여행을 종료하면\n사진 및 영상 업로드가 불가능해요"),
									primaryButton: .destructive(Text("종료")) {
										// 여행 종료 동작
									},
									secondaryButton: .cancel(Text("취소")) {
										// 취소 동작
									}
								)
							}
						
					)
			}
			.navigationTitle("")
		}
	}
}
