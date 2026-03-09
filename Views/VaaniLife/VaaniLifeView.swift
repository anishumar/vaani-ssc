import SwiftUI

struct VaaniLifeView: View {
    @AppStorage("currentStoryIndex") private var storedStoryIndex: Int = -1
    @State private var currentStoryIndex: Int = -1
    @State private var currentSceneIndex: Int = 0
    @State private var currentSceneTextIndex: Int = 0
    @State private var showMCQScene: Bool = false
    @State private var showFinalScene: Bool = false
    @State private var moveToCenter = false
    @State private var moveToLeft = false
    
    var body: some View {
        ZStack {
            if currentStoryIndex == -1 {
                VStack(spacing: 0) {
                    Text("Stories")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8)
                        .padding(.bottom, 4)
                    StoryListView { index in
                        selectStory(index)
                    }
                }
                .background(Color(.systemGroupedBackground))
            } else if showFinalScene && currentStoryIndex >= 0 {
                let finalScene = DataController.shared.getFinalScene(ofStoryIndex: currentStoryIndex)
                FinalSceneView(
                    text: finalScene.descriptions[0],
                    characterImageName: finalScene.characterImageName
                )
                .onTapGesture {
                    DataController.shared.recordCompletedStory(at: currentStoryIndex)
                    showFinalScene = false
                    moveToNextStory()
                }
                .overlay(alignment: .topLeading) {
                    backButton
                }
            } else if showMCQScene && currentStoryIndex >= 0 {
                let story = DataController.shared.getStory(at: currentStoryIndex)
                MCQSceneView(
                    question: story.mcqScene.question,
                    options: story.mcqScene.options,
                    correctOptionIndex: story.mcqScene.correctOptionIndex,
                    characterImageName: story.mcqScene.characterImageName,
                    showMCQScene: $showMCQScene,
                    showFinalScene: $showFinalScene
                )
                .overlay(alignment: .topLeading) {
                    backButton
                }
            } else if currentStoryIndex < DataController.shared.getNumberOfStories() {
                let story = DataController.shared.getStory(at: currentStoryIndex)
                ZStack {
                    StorySceneView(
                        characterImage: story.storyScenes[currentSceneIndex].characterImageName,
                        storyTitle: story.title,
                        description: story.storyScenes[currentSceneIndex].descriptions[currentSceneTextIndex],
                        backgroundImage: story.storyScenes[currentSceneIndex].backgroundImageName
                    )
                    
                    if currentSceneIndex == 0 && currentSceneTextIndex == 0 {
                        VStack {
                            Text(DataController.shared.getTitleOfStory(ofStoryIndex: currentStoryIndex))
                                .font(.title3)
                                .bold()
                                .italic()
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.indigo.opacity(0.8))
                                .cornerRadius(12)
                                .padding(20)
                            Spacer()
                        }
                        GeometryReader { geometry in
                            NewStoryGradientView()
                                .position(x: moveToLeft ? -200 : (moveToCenter ? geometry.size.width / 2 : geometry.size.width + 100),
                                          y: geometry.size.height / 2)
                                .onAppear { restartAnimation(geometry: geometry) }
                                .onChange(of: currentStoryIndex) { restartAnimation(geometry: geometry) }
                        }
                    }
                    
                    VStack {
                        HStack(alignment: .top) {
                            backButton
                            Spacer()
                        }
                        Spacer()
                    }
                }
                .onTapGesture {
                    progressStory()
                }
            }
        }
    }
    
    private var backButton: some View {
        Button(action: goBackToList) {
            Image(systemName: "chevron.left")
                .fontWeight(.semibold)
                .padding(10)
        }
        .buttonStyle(.plain)
        .padding()
    }
    
    private func selectStory(_ index: Int) {
        currentStoryIndex = index
        storedStoryIndex = index
        currentSceneIndex = 0
        currentSceneTextIndex = 0
        showMCQScene = false
        showFinalScene = false
    }
    
    private func goBackToList() {
        currentStoryIndex = -1
        showMCQScene = false
        showFinalScene = false
    }
    
    private func restartAnimation(geometry: GeometryProxy) {
        moveToCenter = false
        moveToLeft = false

        withAnimation(.bouncy(duration: 1)) {
            moveToCenter = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.bouncy(duration: 1)) {
                    moveToLeft = true
                }
            }
        }
    }
    
    private func progressStory() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()

        let totalStories = DataController.shared.getNumberOfStories()

        if currentStoryIndex == -1 {
            if totalStories > 0 {
                currentStoryIndex = 0
                storedStoryIndex = 0
                currentSceneIndex = 0
                currentSceneTextIndex = 0
                showMCQScene = false
                showFinalScene = false
            }
            return
        }

        if currentStoryIndex >= totalStories {
            currentStoryIndex = 0
            storedStoryIndex = 0
            currentSceneIndex = 0
            currentSceneTextIndex = 0
            showMCQScene = false
            showFinalScene = false
        }
        guard currentStoryIndex < totalStories else { return }

        
        let totalScenes = DataController.shared.getNumberOfStoryScenes(ofStoryIndex: currentStoryIndex)
        let totalTexts = DataController.shared.getNumberOfDescriptionsInScene(ofStoryIndex: currentStoryIndex, sceneIndex: currentSceneIndex)

        if currentSceneTextIndex < totalTexts - 1 {
            currentSceneTextIndex += 1
        } else if currentSceneIndex < totalScenes - 1 {
            currentSceneIndex += 1
            currentSceneTextIndex = 0
        } else {
            showMCQScene = true
        }
    }

    private func moveToNextStory() {
        let totalStories = DataController.shared.getNumberOfStories()
        
        if currentStoryIndex < totalStories - 1 {
            currentStoryIndex += 1
            storedStoryIndex = currentStoryIndex
            currentSceneIndex = 0
            currentSceneTextIndex = 0
            showMCQScene = false
            showFinalScene = false
        } else {
            currentStoryIndex = -1
            storedStoryIndex = totalStories
            currentSceneIndex = 0
            currentSceneTextIndex = 0
            showMCQScene = false
            showFinalScene = false
        }
    }
}


#Preview {
    VaaniLifeView()
}
