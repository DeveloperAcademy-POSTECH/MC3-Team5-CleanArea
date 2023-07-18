//
//  EmptyNotificationView.swift
//  YeoWooSimpleView
//
//  Created by 정회승 on 2023/07/17.
//

import SwiftUI

struct EmptyNotificationView: View {
    @Environment(\.dismiss) var dismiss
    @State private var deletingAll = false
    @State private var deletingAlarm = false

    var body: some View {
        NavigationStack{
            VStack{
                Text("알림이 비어있어요")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .foregroundColor(.alarmGray)
            }
            .navigationTitle("알림")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.white)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    Image(systemName: "chevron.left")
                        .opacity(0.3)
                        .imageScale(.large )
                        .onTapGesture {
                            dismiss()
                        }
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Menu {
                        Button(role: .destructive, action: {
                            print ("delete all")
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
        }
        
    }
}

struct EmptyNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyNotificationView()
    }
}
