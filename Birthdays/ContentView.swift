//
//  ContentView.swift
//  Birthdays
//
//  Created by Scholar on 7/24/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var friends: [Friend]
    //= [Friend(name: "Tracey B", birthday: .now), Friend(name: "Aditi", birthday: Date(timeIntervalSince1970: 0)), Friend(name: "Eliana", birthday: Date(timeIntervalSince1970: 15))]
    @Environment(\.modelContext) private var context
    
    @State private var newName = ""
    @State private var newBirthday = Date.now
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(friends) { friend in
                    HStack {
                        HStack {
                            Text(friend.name)
                            Spacer()
                            Text(friend.birthday, format: .dateTime.month(.wide).day().year())
                        }//hstack
                    }//hstack
                }//foreach
                .onDelete(perform: deleteFriend)
            }//list
            .navigationTitle("Birthdays")
            .safeAreaInset(edge: .bottom) {
                VStack(alignment: .center, spacing: 20) {
                    Text("New Birthday")
                        .font(.headline)
                    DatePicker(selection: $newBirthday, in: Date.distantPast...Date.now, displayedComponents: .date) {
                        TextField("Name", text: $newName)
                            .textFieldStyle(.roundedBorder)
                    }
                    Button("Save") {
                        let newFriend = Friend(name: newName, birthday: newBirthday)
                        //friends.append(newFriend)
                        context.insert(newFriend)
                        newName = ""
                        newBirthday = .now
                    }
                    .bold()
                }
                .padding()
                .background(.bar)
            }
        }//nav stack
        
    }//body
    
    func deleteFriend(at offsets: IndexSet) {
        for index in offsets {
            let friendToDelete = friends[index]
            context.delete(friendToDelete)
        }
    }
}//struct

#Preview {
    ContentView()
        .modelContainer(for: Friend.self, inMemory: true)
}
