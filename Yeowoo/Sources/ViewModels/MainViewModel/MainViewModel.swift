//
//  MainViewModel.swift
//  Yeowoo
//
//  Created by 김용주 on 2023/07/17.
//
import Combine
import SwiftUI

final class MainViewModel: ObservableObject {

    @Published var notStartAlbums: [Album] = []
    @Published var progressAlbums: [Album] = []
    @Published var finishAlbums: [Album] = []
    @Published var albums: [Album] = []
    @Published var users: [User] = []
    @Published var traveling = 0
    @Published var openAlarm = false
    @Published var hasAlarm = true
    @Published var hasAlbum = 0
    @Published var today: String = ""
    @Published var role: String = ""
    @Published var finishedFetch: Bool = false
    @Published var randomUser: [User] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    // 앨범 정보 불러오기
    @MainActor
    func fetchAlbums() async {
        FirebaseService.fetchAlbums()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    return
                }
            } receiveValue: { albums in
                self.albums = albums
                let tempNowDate = Double(Date().timeIntervalSince1970)
                
                self.notStartAlbums = albums.filter { !$0.isClosed && (tempNowDate < Double($0.startDay) ?? 0.0) }
                self.progressAlbums = albums.filter { !$0.isClosed && (tempNowDate > Double($0.startDay) ?? 0.0) }
                self.finishAlbums = albums.filter { $0.isClosed }
                
                print("notStartAlbums \(self.notStartAlbums.count)")
                print("progressAlbums \(self.progressAlbums.count)")
                print("finishAlbums \(self.finishAlbums.count)")
                print("albums \(albums.count)")
                print("albumsName \(albums)")
                
                self.hasTraveling()
                self.isEmpty()
                self.getCurrentDateTime()
            }
            .store(in: &cancellables)
    }
    
    // 유저 정보 불러오기
    @MainActor
    func fetchUser(userDocIds: [String]) async {
        FirebaseService.fetchUser(userDocIds: userDocIds)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    return
                }
            } receiveValue: { user in
                self.users = user
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    func randomImageUsers(userDocIds: [String]) async {
        FirebaseService.fetchUser(userDocIds: userDocIds)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    return
                }
            } receiveValue: { user in
                self.randomUser = user
            }
            .store(in: &cancellables)
    }
    
    // 여행 중인지 확인
    @MainActor
    func hasTraveling() {
        if !albums.isEmpty {
            let day = compareDate(albums[0].startDay, albums[0].endDay)
            traveling = day
        }
    }
    
    // 오늘 날짜 기준으로 여행 여부 확인
    @MainActor
    func compareDate(_ start: String, _ end: String) -> Int {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateStyle = .medium
        formatter.dateFormat = "yyyy.MM.dd"
        
        print("==")
        print(start)
        let startDay = formatter.date(from: start)!
        let current = Date()
        
        // 여행 완료
        if end != "" {
            let endDay = formatter.date(from: end)!
            if current >= endDay {
                return 2
            }
        }
        
        // 여행중
        if startDay <= current {
            return 1
        }
        
        // 여행전
        return 0
    }
    
    // 오늘 날짜 확인
    @MainActor
    func getCurrentDateTime() {
        let formatter = DateFormatter() //객체 생성
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateStyle = .medium
        formatter.dateFormat = "yyyy.MM.dd" //데이터 포멧 설정
        today = formatter.string(from: Date()) //문자열로 바꾸기
        
    }
    
    // 앨범이 비어있는지 확인
    @MainActor
    func isEmpty() {
        hasAlbum = albums.isEmpty == true ? 1 : 2

        print(albums.isEmpty)
    }
    
    // 여행 시작일로부터 몇일 지났는지
    @MainActor
    func travelingDate(_ start: String) -> Int {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateStyle = .medium
        formatter.dateFormat = "yyyy.MM.dd"
        
        let startDay = formatter.date(from: start)!
        let day = Int(ceil(Date().timeIntervalSince(startDay) / 86400))
        
        return day
    }

    // 여행일까지 앞으로 남은 기간
    @MainActor
    func D_Day(_ start: String) -> Int {
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateStyle = .medium
        formatter.dateFormat = "yyyy.MM.dd"
        
        let startDay = formatter.date(from: start)!
        print(startDay)
        print(Date())
        
        let day = Int(ceil(startDay.timeIntervalSinceNow / 86400))
        
        return day
    }

    // 여행 끝난 당일 3개의 랜덤 이미지 선택
    @MainActor
    func randomPicture(_ album: [ImagesEntity] , _ pic: inout [String]){
        var three: [String] = ["", "", ""]
        var images: [String] = []
        var one: String
        var isHave = false
        
        for insert in 0..<album.count {
            images.append(album[insert].url)
        }
        
        for i in 0..<3{
            one = images.randomElement()!
            
            while true {
                for j in 0..<i {
                    if three[j] == one {
                        one = images.randomElement()!
                        isHave = true
                        break
                    }
                }
                if isHave {
                    isHave = false
                    continue
                } else {
                    break
                }
            }
            three[i] = one
        }
        for k in 0..<3 {
            pic[k] = three[k]
            print(pic[k])
        }
    }
    
    // 진행중인 여행에서의 내 역할 가져오기
    @MainActor
    func searchRole(_ userId: String) {
        role = albums[0].role[albums[0].users.firstIndex(of: userId) ?? 1]
        
        print(role)
    }
    
    @MainActor
    func loadAlbum() async {
        await fetchAlbums()
        await fetchUser(userDocIds: [UserDefaultsSetting.userDocId])
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(3)) {
            if self.hasAlbum == 2 {
                self.searchRole(UserDefaultsSetting.userDocId)
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
                self.finishedFetch = true
            }
        }
    }
}
