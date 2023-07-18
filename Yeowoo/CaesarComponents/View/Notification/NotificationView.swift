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
    @State private var deletingAll = false
    @State private var deletingAlarm = false
    
    @State private var selectedIndex: Int? = nil

    var body: some View {
        
        //같은 날짜 배열값 딕셔너리
        let groupedTravels = travels.reduce(into: [String: [Travel]]()) { result, travel in
            result[travel.Date, default: []].append(travel)
        }
        
            ScrollView{
                LazyVStack(spacing: 70){
                    ForEach(groupedTravels.keys.sorted(by: >), id: \.self) { date in // 최신 날짜부터 순서대로 보여주도록
                        NotiCardView(dayNotiNum: groupedTravels[date]?.count ?? 1, travels: groupedTravels[date] ?? [])
                    }
                }
                .padding(.top, 55)
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
                            print(groupedTravels)
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

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
