import SwiftUI

struct LandmarkDetail: View {
    @EnvironmentObject var userData: UserData
    var landmark: Landmark

    var landmarkIndex: Int {
        userData.landmarks.firstIndex(where: { $0.id == landmark.id })!
    }

    var body: some View {
        VStack {
            ScrollView{
                MapView(coordinate: landmark.locationCoordinate)
                               .edgesIgnoringSafeArea(.top)
                               .frame(height: 300)

                CircleImage(image: landmark.image.resizable())
                
                               .offset(y: -150)
                    .padding(.bottom, -150)
                    .frame(width: 280, height: 280)

                           VStack(alignment: .leading) {
                               HStack {
                                   Text(landmark.name)
                                       .font(.title)

                                   Button(action: {
                                       self.userData.landmarks[self.landmarkIndex].isFavorite.toggle()
                                   }) {
                                       if self.userData.landmarks[self.landmarkIndex].isFavorite {
                                           Image(systemName: "star.fill")
                                               .foregroundColor(Color.yellow)
                                       } else {
                                           Image(systemName: "star")
                                               .foregroundColor(Color.gray)
                                       }
                                   }
                               }
                               
                               

                               HStack(alignment: .top) {
                                   Text(landmark.park)
                                       .font(.subheadline)
                                   Spacer()
                                   Text(landmark.state)
                                       .font(.subheadline)
                               }
                           }
                           .padding(.horizontal, 40.0)
                           .padding(.top, -70.0)
                           
                
                Text(landmark.content)
                    .lineLimit(6)
                    .padding(.top, 40.0)
                    .frame(width: 300.0)
                
                Button(action: {}) {
                    Text(landmark.data)
                        .multilineTextAlignment(.trailing)
                        .lineLimit(1)
                        .frame(width: 300.0)
                        
                }
                
                
              
                           
                           
                           Spacer()
            }
        }
            
            
        .navigationBarTitle(Text(landmark.name), displayMode: .inline)
        
    }
}


