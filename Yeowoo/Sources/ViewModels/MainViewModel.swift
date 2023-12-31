//
//  MainViewModel.swift
//  Yeowoo
//
//  Created by 김용주 on 2023/07/17.
//
import Combine
import SwiftUI

final class MainViewModel: ObservableObject {
    @Published var albums: [Album] = []
    @Published var users: [User] = []
    @Published var currentDocId: String = ""
    @Published var today: String = ""
    @Published var role: String = ""
    @Published var finishedFetch: Bool = false
    @Published var openSetting: Bool = false
    @Published var fetchState: Bool = false
    @Published var openChange: Bool = false
    @Published var openAlarm: Bool = false
    @Published var openAlbum: Bool = false
    @Published var openMake: Bool = false
    @Published var hasAlarm: Bool = true
    @Published var traveling: Int = 0
    @Published var hasAlbum: Int = 0
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
                self.isEmpty()
                self.getCurrentDateTime()
                self.sortAlbum()
                self.hasTraveling()
                self.getDocId()
            }
            .store(in: &cancellables)
    }
    
    // 유저 정보 불러오기
    @MainActor
    func fetchUser(userDocIds: [String]) async throws {
		self.users = try await FirebaseService.fetchUser(userDocIds: userDocIds)
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
        let day = Int(ceil(startDay.timeIntervalSinceNow / 86400))
        
        return day
    }

    // 여행 끝난 당일 3개의 랜덤 이미지 선택
    @MainActor
    func randomPicture(_ album: [ImagesEntity] , _ pic: inout [String]) {
        var three: [String] = ["", "", ""]
        var images: [String] = []
        var one: String
        var isHave = false
        
        if album.isEmpty || (album.count < 3) {
            if album.isEmpty {
                for change in 0..<3 {
                    pic[change] = ""
                }
            } else {
                for change in 0..<album.count {
                    pic[change] = album[change].url
                }
                
                for change in album.count..<3 {
                    pic[change] = ""
                }
            }
        } else {
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
            }
        }
    }
    
    // 진행중인 여행에서의 내 역할 가져오기
    @MainActor
    func searchRole(_ userId: String) {
        role = albums[0].role[albums[0].users.firstIndex(of: userId) ?? 1]
    }
    
    @MainActor
    func loadAlbum() async throws {
		try await fetchUser(userDocIds: [UserDefaultsSetting.userDocId])
        await fetchAlbums()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(3)) {
            if self.hasAlbum == 2 {
                self.searchRole(UserDefaultsSetting.userDocId)
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1)) {
                self.finishedFetch = true
            }
        }
    }
    
    @MainActor
    func imageUpload(image: UIImage, albumDocId: String, comment: String, uploadUser: String) async throws {
        _ = try await FirebaseService.uploadAlbumImage(image: image,
                                                       albumDocId: albumDocId,
                                                       fileName: String(describing: UUID()),
                                                       comment: comment,
                                                       uploadUser: uploadUser)
    }
    
    func getDocId() {
		if !albums.isEmpty {
			currentDocId = albums[0].id
		}
    }
    
    @MainActor
    func refetch(didPhoto: inout Bool, showModal: inout Bool) {
        didPhoto = false
        showModal = false
        self.finishedFetch = false
    }
    
    // 앨범 순서 정리
    func sortAlbum() {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateStyle = .medium
        formatter.dateFormat = "yyyy.MM.dd"
        
        albums.sort { album1, album2 in
            if album1.startDay == album2.startDay {
                if album1.endDay.isEmpty && album2.endDay.isEmpty {
                    return false
                } else if album1.endDay.isEmpty {
                    return true
                } else if album2.endDay.isEmpty {
                    return false
                } else {
                    return album1.endDay < album2.endDay
                }
            } else {
                return album1.startDay > album2.startDay
            }
        }
    }
}
