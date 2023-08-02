//
//  NotificationView.swift
//  YeoWooSimpleView
//
//  Created by 정회승 on 2023/07/14.
//

import SwiftUI
import UIKit

//let travels = [
//	Travel(name: "제임스", description: "제주도 여행", friendImage: "Azhy", Date: "2023. 04. 23"),
//	Travel(name: "제육볶음", description: "일본 여행", friendImage: "Nova", Date: "2023. 01. 05"),
//	Travel(name: "Muhammad", description: "Abu Dhabi Trip", friendImage: "Sunday", Date: "2023. 01. 05"),
//	Travel(name: "룰루", description: "부산 당일치기", friendImage: "Jigu", Date: "2022. 10. 03"),
//	Travel(name: "랄라", description: "스페인 한달살기", friendImage: "Jamie", Date: "2022. 06. 01"),
//	Travel(name: "제이미", description: "포항 여행", friendImage: "Noru", Date: "2023. 04. 23"),
//	Travel(name: "돈까쓰", description: "북한 여행", friendImage: "Noru", Date: "2023. 04. 23"),
//]

struct NotificationView: View {
	
	@ObservedObject var viewModel = NotificationViewModel()
    @StateObject var mainViewModel: MainViewModel
	
	@Environment(\.dismiss) var dismiss
	@State private var deletingAll = false
	@State private var deletingAlarm = false
	
	@State private var selectedIndex: Int? = nil
	
	var body: some View {
		ScrollView{
			LazyVStack(spacing: 70){
				if viewModel.notis.isEmpty {
					Text("알림이 없습니다.")
						.padding(.top, UIScreen.main.bounds.height / 3)
				} else {
					let groupedTravels = Dictionary(grouping: viewModel.notis, by: { $0.sendDate })
					let sortedGroupedTravels = groupedTravels.sorted(by: { $0.key > $1.key })
					NotiCardView(mainViewModel: mainViewModel, sortedGroupedTravels: sortedGroupedTravels)
				}
			}
			.padding(.top, 55)
		}
		.scrollDisabled(viewModel.notis.isEmpty ? true : false)
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
						//                            print ("delete all")
//						print(groupedTravels)
						deletingAlarm = true
						
					}) {
						Label("전체 삭제", systemImage: "trash")
							.foregroundColor(Color("R1"))
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
					.foregroundColor(Color("R1")),
											action: {
												//삭제코드
												
											}),
				secondaryButton: .cancel(Text("취소"))
			)
		}
		.accentColor(.black)
	}
}
