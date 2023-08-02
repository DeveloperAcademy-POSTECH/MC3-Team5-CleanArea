//
//  NotificationView.swift
//  YeoWooSimpleView
//
//  Created by 정회승 on 2023/07/14.
//

import SwiftUI
import UIKit

struct NotificationView: View {
	
	@Environment(\.dismiss) var dismiss
	
	@ObservedObject var viewModel = NotificationViewModel()
	@StateObject var mainViewModel: MainViewModel
	
	@State private var deletingAll = false
	@State private var deletingAlarm = false
	@State private var selectedIndex: Int? = nil
	
	var body: some View {
		ScrollView{
			LazyVStack(spacing: 70){
				if viewModel.notifications.isEmpty {
					Text("알림이 없습니다.")
						.padding(.top, UIScreen.main.bounds.height / 3)
				} else {
					let groupedTravels = Dictionary(grouping: viewModel.notifications, by: { $0.sendDate })
					let sortedGroupedTravels = groupedTravels.sorted(by: { $0.key > $1.key })
					NotiCardView(mainViewModel: mainViewModel,
								 sortedGroupedTravels: sortedGroupedTravels)
				}
			}
			.padding(.top, 55)
		}
		.scrollDisabled(viewModel.notifications.isEmpty ? true : false)
		.onAppear {
			viewModel.fetchNotification()
		}
		.navigationTitle("알림")
		.navigationBarTitleDisplayMode(.inline)
		.background(Color.white)
		.toolbar {
			ToolbarItem(placement: .navigationBarLeading){
				Image(systemName: "chevron.left")
					.opacity(0.3)
					.imageScale(.large)
					.padding(.trailing, 20)
					.padding(.bottom, 20)
					.onTapGesture {
						dismiss()
					}
			}
			ToolbarItem(placement: .navigationBarTrailing){
				Menu {
					Button(role: .destructive, action: {
						deletingAlarm = true
					}) {
						Label("전체 삭제", systemImage: "trash")
							.foregroundColor(.warningRed)
					}
				} label: {
					Label("", systemImage: "ellipsis")
						.rotationEffect(Angle(degrees: 90))
						.foregroundColor(.gray)
						.opacity(0.7)
						.padding(.leading, 20)
						.padding(.bottom, 20)
				}
			}
		}
		.alert(isPresented: $deletingAlarm) {
			Alert(
				title: Text("알림 삭제"),
				message: Text("알림을 정말 모두 삭제하시겠어요?"),
				primaryButton: .destructive(Text("삭제")
					.foregroundColor(.warningRed),
											action: {
												//삭제코드
											}),
				secondaryButton: .cancel(Text("취소"))
			)
		}
		.accentColor(.black)
	}
}
