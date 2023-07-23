//
//  ContentView.swift
//  Yeowoo
//
//  Created by Kim SungHun on 2023/07/06.
//

import SwiftUI
import UIKit

struct ContentView: View {
	
	@ObservedObject var viewModel = AlbumViewModel()
	@State private var isActiveAlbumFeedView = false
	
	init() {
		UINavigationBar.appearance().backgroundColor = .white
	}
	
	@State private var showingFinishAlert = false
	@State private var showingUpdateAlert = false
	@State private var showingSheet = false
	@State private var name = ""
	
	var body: some View {
		NavigationView {
			NavigationLink("테스트", isActive: $isActiveAlbumFeedView) {
				AlbumFeedView(albumDocId: "T9eJMPQEGQClFHEahX6r", viewModel: viewModel)
					.navigationBarTitle(viewModel.albums.albumTitle)
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
									showingFinishAlert = true
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
										.font(.system(size: 18))
										.fontWeight(.bold)
									TextField("20자 이내로 입력해주세요", text: $name)
										.font(.system(size: 16))
										.padding()
										.background(Color(uiColor: .secondarySystemBackground))
										.cornerRadius(10)
										.onAppear {
											UITextField.appearance().clearButtonMode = .whileEditing
										}
									Button {
										Task {
											try await viewModel.updateAlbumTitle(albumDocId: "T9eJMPQEGQClFHEahX6r",
																				 title: name)
											showingUpdateAlert = true
										}
									} label: {
										Rectangle()
											.fill(Color.mainColor)
											.frame(height: 54)
											.cornerRadius(10)
											.overlay {
												Text("완료")
													.font(.system(size: 18))
													.fontWeight(.bold)
													.foregroundColor(Color.white)
											}
									}
									.alert(isPresented: $showingUpdateAlert) {
										Alert(
											title: Text("제목 수정"),
											message: Text("앨범 제목을 수정했어요."),
											dismissButton: .default(Text("확인")) { }
										)
									}
									
								}
								.padding(.horizontal, 20)
								.presentationDetents([.height(250)])
							}
					)
					.alert(isPresented: $showingFinishAlert) {
						Alert(
							title: Text(viewModel.albums.isClosed ? "여행 삭제" : "여행 종료"),
							message: Text(viewModel.albums.isClosed ? "현재 계정에서만 삭제되며 복구가 불가능합니다" :
											"여행을 종료하면\n사진 및 영상 업로드가 불가능해요"),
							primaryButton: .destructive(Text(viewModel.albums.isClosed ? "삭제" : "종료")) {
								Task {
									viewModel.albums.isClosed ? try await viewModel.removeTravel(docId: "") :
									try await viewModel.closedTravel(docId: "")
								}
								self.isActiveAlbumFeedView = false
							},
							secondaryButton: .cancel(Text("취소")) { }
						)
					}
			}
			.navigationTitle("")
		}
		.accentColor(Color("G4"))
	}
}
