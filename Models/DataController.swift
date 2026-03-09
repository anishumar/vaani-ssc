import Foundation


//Creating Singleton class
@MainActor
class DataController: ObservableObject {
    private var user: User =
    User(
        name: UserDefaults.standard.string(forKey: "userName") ?? "User",
        age: UserDefaults.standard.integer(forKey: "userAge") == 0 ? Int.max : UserDefaults.standard.integer(forKey: "userAge")
    )
    
    private var questionCategories: [QuestionCategory] = []
    
    private var stories: [Story] = []
    
    @Published var checkLists: [CheckList] = [] {
            didSet {
                saveCheckLists()
            }
        }
    
    static let shared = DataController()
    
    private init() {
        loadData()
        loadCheckLists()
        checkAndResetIfNewDay()
        loadQA()
    }
    //MARK: - Data filling
    
    func loadData() {
        stories = [
            Story(
                storyImage: "Priya_Thumbnail",
                title: "Priya's Big Day: \nA Story of Growing Up",
                storyScenes: [
                    StoryScene(
                        descriptions: [
                            "Today was the day—Priya's Thirandu Kalyanam, her first rice ceremony at the temple in Kerala.",
                            "Relatives had come from nearby villages. She wore a new cream-and-gold saree. Everything felt magical."
                            ],
                        backgroundImageName: "Priya_BirthdayBg",
                        characterImageName: "Priya_VeryHappy"
                    ),
                    StoryScene(
                        descriptions: [
                            "But… something felt different.",
                            "As she stood with her cousin Lakshmi, Priya suddenly felt a strange wetness in her underwear."
                        ],
                        backgroundImageName: "Priya_BirthdayBg",
                        characterImageName: "Priya_Shocked"
                    ),
                    StoryScene(
                        descriptions: [
                            "Confused, she slipped away to the washroom.",
                            "Her heart pounded. A deep red stain had appeared on her new saree.",
                            "Is something wrong with me? She'd heard a little about periods at school.",
                            "But no one had said what it really feels like the first time."
                        ],
                        backgroundImageName: "Priya_WashroomBg",
                        characterImageName: "Priya_Shocked"
                    )
                ],
                mcqScene: MCQScene(
                    question: "What should Priya do next?",
                        options: [
                            "Panic and hide it from everyone.",
                            "Use tissue paper and hope it stops.",
                            "Find an elder she trusts and ask for help.",
                            "Ignore it and continue with the ceremony."
                            ],
                        correctOptionIndex: 2,
                        backgroundImageName: "",
                        characterImageName: "Priya_Question"
                ),
                finalScene: StoryScene(
                    descriptions: [
                        "Priya found her mother and whispered, \"Amma, I think I started my period.\"\n\nHer mother smiled. \"You're growing up. It's nothing to fear.\"\n\nShe gave Priya a pad and showed her how to use it. \"We'll take care of the saree. You're fine.\""
                    ],
                    backgroundImageName: "",
                    characterImageName: "Priya_Satisfied"
                )
            ),
            Story(
                storyImage: "Aisha_Thumbnail",
                title: "Aisha's Silent Struggle: \nA Lesson on UTIs",
                storyScenes: [
                    StoryScene(
                        descriptions: [
                            "Aisha had settled into hostel life at her engineering college in North India—early lectures, late nights in the library, endless cups of chai.",
                            "She was so busy she barely noticed small changes in her body."
                        ],
                        backgroundImageName: "Aisha_BedroomBg",
                        characterImageName: "Aisha_Happy"
                    ),
                    StoryScene(
                        descriptions: [
                            "One evening, after rushing back from the library, she felt a burning sensation while urinating.",
                            "\"Maybe I didn't drink enough water,\" she thought, and ignored it.",
                            "Days passed. The discomfort grew. She felt the urge to pee often, but only a few drops came out—each time with a painful sting."
                        ],
                        backgroundImageName: "Aisha_WashroomBg",
                        characterImageName: "Aisha_Confused"
                    ),
                    StoryScene(
                        descriptions: [
                            "Then one night she saw something alarming—a slight trace of blood in her urine."
                        ],
                        backgroundImageName: "Aisha_WashroomBg",
                        characterImageName: "Aisha_Crying"
                    )
                ],
                mcqScene: MCQScene(
                    question: "What should Aisha do now?",
                    options: [
                        "Drink more water and wait for it to go away.",
                        "Ignore it—it's probably nothing serious.",
                        "Ask a senior or warden for help.",
                        "Take random medicine from a friend."
                    ],
                    correctOptionIndex: 2,
                    backgroundImageName: "",
                    characterImageName: "Aisha_Question"
                ),
                finalScene: StoryScene(
                    descriptions: [
                        "Ignoring UTI symptoms can lead to kidney infections. Drinking water helps, but only a doctor can give the right treatment.\n\nAisha went to the warden, then to a doctor. With early help, she recovered. Seeking a trusted elder or healthcare professional prevents complications."
                    ],
                    backgroundImageName: "",
                    characterImageName: "Aisha_Smiling"
                )
            ),
            Story(
                storyImage: "Kavya_Thumbnail",
                title: "The Hidden Itch: \nKavya's Story",
                storyScenes: [
                    StoryScene(
                        descriptions: [
                            "Life in the hostel in South India was thrilling but hectic.",
                            "Between gym, classes, and laundry delays, Kavya often wore damp clothes or stayed in sweaty leggings for hours."
                        ],
                        backgroundImageName: "Kavya_BedroomBg",
                        characterImageName: "Kavya_Happy"
                    ),
                    StoryScene(
                        descriptions: [
                            "One morning she felt a persistent itch down there.",
                            "She ignored it, assuming it would go away."
                        ],
                        backgroundImageName: "Kavya_BedroomBg",
                        characterImageName: "Kavya_Confused"
                    ),
                    StoryScene(
                        descriptions: [
                            "A few days later the itching worsened. She noticed thick, white discharge.",
                            "Sitting in lectures became unbearable.",
                            "She tried washing the area with strong soap—but that only made things worse."
                        ],
                        backgroundImageName: "Kavya_BedroomBg",
                        characterImageName: "Kavya_Crying"
                    )
                ],
                mcqScene: MCQScene(
                    question: "What should Kavya do?",
                    options: [
                        "Ignore it—it will go away.",
                        "Use strong soap to clean the area.",
                        "Try home remedies without consulting anyone.",
                        "Speak to a senior or visit a doctor."
                    ],
                    correctOptionIndex: 3,
                    backgroundImageName: "",
                    characterImageName: "Kavya_Curious"
                ),
                finalScene: StoryScene(
                    descriptions: [
                        "Harsh soaps disrupt the body's natural balance and can make the infection worse.\n\nKavya spoke to a senior and went to a doctor. Clean, dry clothes and proper medical advice made all the difference."
                    ],
                    backgroundImageName: "",
                    characterImageName: "Kavya_Smiling"
                )
            ),
            Story(
                storyImage: "Meera_Thumbnail",
                title: "Meera's Mystery: \nWhen Periods Don't Follow the Rules",
                storyScenes: [
                    StoryScene(
                        descriptions: [
                            "Meera, 16 and living in the city, had always thought her period would settle into a routine, like everyone said."
                        ],
                        backgroundImageName: "Meera_BedroomBg",
                        characterImageName: "Meera_Happy"
                    ),
                    StoryScene(
                        descriptions: [
                            "But things weren't adding up."
                        ],
                        backgroundImageName: "Meera_BedroomBg",
                        characterImageName: "Meera_Casual"
                    ),
                    StoryScene(
                        descriptions: [
                            "Some months her period came with unbearable cramps. Other times it didn't show up at all.",
                            "When it did, it lasted for weeks and left her exhausted.",
                            "She stared at her phone—her last period was over two months ago.",
                            "\"Maybe stress,\" she told herself. But deep down she felt uneasy."
                        ],
                        backgroundImageName: "Meera_BedroomBg",
                        characterImageName: "Meera_Dissatisfied"
                    ),
                    StoryScene(
                        descriptions: [
                            "Then came sudden weight gain, stubborn acne, and tiny dark hairs on her chin.",
                            "Nothing seemed to change no matter what she did.",
                            "One afternoon, tying her hair into a ponytail, she noticed her hairline looked thinner.",
                            "Her stomach dropped. What was happening to her?"
                        ],
                        backgroundImageName: "Meera_BedroomBg",
                        characterImageName: "Meera_Shocked"
                    ),
                    StoryScene(
                        descriptions: [
                            "She turned to her best friend. \"My period's been all over the place. And now my hair…\"",
                            "Her friend frowned. \"That doesn't sound normal. You should get it checked.\""
                        ],
                        backgroundImageName: "Meera_BedroomBg",
                        characterImageName: "Meera_Crying"
                    )
                ],
                mcqScene: MCQScene(
                    question: "What should Meera do next?",
                    options: [
                        "Ignore it and wait for things to fix themselves.",
                        "Try random weight loss diets and acne creams.",
                        "Compare herself to others and feel discouraged.",
                        "Research her symptoms, talk to a doctor, and seek proper diagnosis."
                    ],
                    correctOptionIndex: 3,
                    backgroundImageName: "",
                    characterImageName: "Meera_Curious"
                ),
                finalScene: StoryScene(
                    descriptions: [
                        "Meera's symptoms weren't random—they were connected. A visit to the doctor confirmed it: Polycystic Ovary Syndrome (PCOS).\n\nPCOS can affect weight, skin, hair, and mood. With the right guidance, lifestyle changes, and sometimes medication, it can be managed. When Meera got the right support, things got better."
                    ],
                    backgroundImageName: "",
                    characterImageName: "Meera_Smiling"
                )
            ),
            Story(
                storyImage: "Aisha_Thumbnail",
                title: "Mahira's Roller Coaster: \nUnderstanding PMS",
                storyScenes: [
                    StoryScene(
                        descriptions: [
                            "A week before her period, Mahira felt fine. College, friends, everything normal."
                        ],
                        backgroundImageName: "Aisha_BedroomBg",
                        characterImageName: "Aisha_Happy"
                    ),
                    StoryScene(
                        descriptions: [
                            "Then came the mood swings. One moment she was laughing, the next she wanted to cry. She snapped at her roommate over nothing."
                        ],
                        backgroundImageName: "Aisha_BedroomBg",
                        characterImageName: "Aisha_Confused"
                    ),
                    StoryScene(
                        descriptions: [
                            "Bloating, fatigue, and irritability made her wonder: Is something wrong with me?"
                        ],
                        backgroundImageName: "Aisha_BedroomBg",
                        characterImageName: "Aisha_Crying"
                    )
                ],
                mcqScene: MCQScene(
                    question: "What should Mahira do?",
                    options: [
                        "Ignore it and hope it goes away.",
                        "Blame herself for being moody.",
                        "Track her cycle and talk to a trusted adult or doctor.",
                        "Take random supplements without advice."
                    ],
                    correctOptionIndex: 2,
                    backgroundImageName: "",
                    characterImageName: "Aisha_Question"
                ),
                finalScene: StoryScene(
                    descriptions: [
                        "PMS is common and real. Tracking your cycle helps you prepare. Rest, gentle movement, and talking to someone you trust can make a big difference."
                    ],
                    backgroundImageName: "",
                    characterImageName: "Aisha_Smiling"
                )
            ),
            Story(
                storyImage: "Kavya_Thumbnail",
                title: "Zara's Heavy Days: \nWhen Tiredness Won't Go Away",
                storyScenes: [
                    StoryScene(
                        descriptions: [
                            "Zara had always been active. But lately, climbing the stairs left her breathless."
                        ],
                        backgroundImageName: "Kavya_BedroomBg",
                        characterImageName: "Kavya_Happy"
                    ),
                    StoryScene(
                        descriptions: [
                            "She felt dizzy in class. Her skin looked paler. Even small tasks felt exhausting.",
                            "\"Maybe I'm not sleeping enough,\" she thought."
                        ],
                        backgroundImageName: "Kavya_BedroomBg",
                        characterImageName: "Kavya_Confused"
                    ),
                    StoryScene(
                        descriptions: [
                            "Her periods had been heavy for months. She'd never connected the dots—until a friend mentioned iron and anemia."
                        ],
                        backgroundImageName: "Kavya_BedroomBg",
                        characterImageName: "Kavya_Crying"
                    )
                ],
                mcqScene: MCQScene(
                    question: "What should Zara do?",
                    options: [
                        "Ignore it and push through.",
                        "Take iron supplements without a doctor's advice.",
                        "Visit a doctor, get tested, and follow their guidance.",
                        "Drink more coffee for energy."
                    ],
                    correctOptionIndex: 2,
                    backgroundImageName: "",
                    characterImageName: "Kavya_Curious"
                ),
                finalScene: StoryScene(
                    descriptions: [
                        "Heavy periods can lead to low iron. A simple blood test can confirm anemia. With the right diet, supplements if needed, and medical guidance, energy can return. Zara learned to listen to her body."
                    ],
                    backgroundImageName: "",
                    characterImageName: "Kavya_Smiling"
                )
            ),
            Story(
                storyImage: "Meera_Thumbnail",
                title: "Riya's Missing Dates: \nStress and Irregular Periods",
                storyScenes: [
                    StoryScene(
                        descriptions: [
                            "In her tier-two city, Riya was under constant pressure—exams, assignments, little time to eat or sleep properly."
                        ],
                        backgroundImageName: "Meera_BedroomBg",
                        characterImageName: "Meera_Casual"
                    ),
                    StoryScene(
                        descriptions: [
                            "Her period, which had always been regular, didn't show up. One week passed. Then two. She checked her calendar again and again."
                        ],
                        backgroundImageName: "Meera_BedroomBg",
                        characterImageName: "Meera_Dissatisfied"
                    ),
                    StoryScene(
                        descriptions: [
                            "\"Is it stress? Am I sick?\" She felt alone and worried. She didn't know who to ask."
                        ],
                        backgroundImageName: "Meera_BedroomBg",
                        characterImageName: "Meera_Crying"
                    )
                ],
                mcqScene: MCQScene(
                    question: "What should Riya do?",
                    options: [
                        "Panic and assume the worst.",
                        "Ignore it and wait for it to come back.",
                        "Track her cycle, manage stress, and talk to a doctor or trusted adult.",
                        "Search the internet and try random remedies."
                    ],
                    correctOptionIndex: 2,
                    backgroundImageName: "",
                    characterImageName: "Meera_Curious"
                ),
                finalScene: StoryScene(
                    descriptions: [
                        "Stress, diet, and sleep can affect your cycle. Tracking helps you notice patterns. A doctor can rule out other causes and offer peace of mind. Riya learned that irregular periods have many causes—and help is available."
                    ],
                    backgroundImageName: "",
                    characterImageName: "Meera_Smiling"
                )
            ),
            Story(
                storyImage: "Priya_Thumbnail",
                title: "Sneha's Gentle Journey: \nUnderstanding PCOD",
                storyScenes: [
                    StoryScene(
                        descriptions: [
                            "Sneha had noticed her period wasn't always on time—sometimes a week late, sometimes a few days early. She'd also felt a bit bloated around that time."
                        ],
                        backgroundImageName: "Aisha_BedroomBg",
                        characterImageName: "Priya_Satisfied"
                    ),
                    StoryScene(
                        descriptions: [
                            "Unlike her friend who had PCOS with heavier symptoms, Sneha's signs were milder. Still, she wondered if something was wrong."
                        ],
                        backgroundImageName: "Aisha_BedroomBg",
                        characterImageName: "Priya_Shocked"
                    ),
                    StoryScene(
                        descriptions: [
                            "A friend mentioned PCOD—polycystic ovarian disease. \"It's different from PCOS,\" she said. \"Often it responds well to lifestyle changes.\""
                        ],
                        backgroundImageName: "Aisha_BedroomBg",
                        characterImageName: "Priya_Question"
                    )
                ],
                mcqScene: MCQScene(
                    question: "What should Sneha do?",
                    options: [
                        "Ignore it since her symptoms are mild.",
                        "Try extreme diets to fix it quickly.",
                        "Adopt balanced lifestyle changes and talk to a doctor.",
                        "Take random supplements from the pharmacy."
                    ],
                    correctOptionIndex: 2,
                    backgroundImageName: "",
                    characterImageName: "Priya_Question"
                ),
                finalScene: StoryScene(
                    descriptions: [
                        "PCOD is often manageable with lifestyle. Regular meals, gentle exercise, and stress care can help. A doctor can confirm the diagnosis and guide you. Sneha learned that small, consistent changes make a big difference."
                    ],
                    backgroundImageName: "",
                    characterImageName: "Priya_Satisfied"
                )
            ),
            Story(
                storyImage: "Kavya_Thumbnail",
                title: "Nandini's Hidden Pain: \nWhen Cramps Are More Than Cramps",
                storyScenes: [
                    StoryScene(
                        descriptions: [
                            "Every month Nandini dreaded her period. The pain was so severe she had to stay in bed. Painkillers barely helped."
                        ],
                        backgroundImageName: "Kavya_BedroomBg",
                        characterImageName: "Kavya_Crying"
                    ),
                    StoryScene(
                        descriptions: [
                            "She missed school. She told herself, \"It's just cramps. Everyone has them.\" But deep down she knew this wasn't normal."
                        ],
                        backgroundImageName: "Kavya_BedroomBg",
                        characterImageName: "Kavya_Confused"
                    ),
                    StoryScene(
                        descriptions: [
                            "A teacher noticed her absences and gently asked if she was okay. \"Have you talked to a doctor?\" she said. \"Severe pain isn't something to ignore.\""
                        ],
                        backgroundImageName: "Kavya_BedroomBg",
                        characterImageName: "Kavya_Crying"
                    )
                ],
                mcqScene: MCQScene(
                    question: "What should Nandini do?",
                    options: [
                        "Suffer in silence and hope it gets better.",
                        "Take more painkillers without medical advice.",
                        "See a doctor and describe her pain clearly.",
                        "Assume it will go away on its own."
                    ],
                    correctOptionIndex: 2,
                    backgroundImageName: "",
                    characterImageName: "Kavya_Curious"
                ),
                finalScene: StoryScene(
                    descriptions: [
                        "Severe period pain can signal endometriosis—when tissue similar to the uterine lining grows outside the uterus. Tracking symptoms and seeing a specialist helps. Treatment and support are available. Nandini learned that her pain deserved to be heard."
                    ],
                    backgroundImageName: "",
                    characterImageName: "Kavya_Smiling"
                )
            ),
            Story(
                storyImage: "Meera_Thumbnail",
                title: "Pooja's Tired Body: \nThe Thyroid Connection",
                storyScenes: [
                    StoryScene(
                        descriptions: [
                            "Pooja felt constantly tired. No matter how much she slept, she woke up exhausted. She felt cold when others were fine."
                        ],
                        backgroundImageName: "Meera_BedroomBg",
                        characterImageName: "Meera_Dissatisfied"
                    ),
                    StoryScene(
                        descriptions: [
                            "She'd gained weight without changing her diet. Her hair was thinning. Her period had become irregular. She blamed stress."
                        ],
                        backgroundImageName: "Meera_BedroomBg",
                        characterImageName: "Meera_Shocked"
                    ),
                    StoryScene(
                        descriptions: [
                            "During a routine check-up in town, the doctor suggested a thyroid test. \"These symptoms can point to hypothyroidism,\" she said. A simple blood test confirmed it."
                        ],
                        backgroundImageName: "Meera_BedroomBg",
                        characterImageName: "Meera_Curious"
                    )
                ],
                mcqScene: MCQScene(
                    question: "What should Pooja do?",
                    options: [
                        "Ignore it and push through the fatigue.",
                        "Crash diet to lose the weight quickly.",
                        "Get a thyroid test and follow the doctor's advice.",
                        "Take random supplements for energy."
                    ],
                    correctOptionIndex: 2,
                    backgroundImageName: "",
                    characterImageName: "Meera_Curious"
                ),
                finalScene: StoryScene(
                    descriptions: [
                        "Thyroid issues affect energy, weight, and cycles. Medication and lifestyle can help. A blood test is the first step. Pooja learned that listening to her body—and getting it checked—was the right choice."
                    ],
                    backgroundImageName: "",
                    characterImageName: "Meera_Smiling"
                )
            )
        ]
    }
    
    func loadQA() {
        questionCategories = [
            QuestionCategory (
                name: "Understanding Your Cycle",
                items: [
                    QAItem(
                        question: "What should I know about my first period?",
                        answer: "Your first period is your body’s way of saying, \"You're growing beautifully.\" It might bring surprises—cramps, mood swings, or a \"Wait, what?!\" moment—but don’t worry, you’ve got this. \n\nStay prepared, listen to your body (hello, snacks and cozy blankets!), and remember—every cycle is unique, just like you. \n\nIf you’re unsure, talk to someone you trust. You’re not alone."
                    ),QAItem(
                        question: "What is considered a normal menstrual flow?",
                        answer: "A normal menstrual flow is one that is neither too heavy nor too light. Typically, it means changing a pad or tampon every 4 to 6 hours. Your body follows its rhythm—some variations are normal."
                    ),
                    QAItem(
                        question: "I do not understand periods. What is a period?",
                        answer: "A period is the body’s way of resetting. Every month, the uterus prepares for a possible pregnancy. If that doesn’t happen, the lining sheds, leading to a period. It's natural, it's normal, and it’s a sign of a healthy cycle."
                    ),
                    QAItem(
                        question: "When did a person find out about periods?",
                        answer: "The moment of discovery is different for everyone. Some learn about it in school, others through family. It’s a journey, and the more you know, the more confident you become."
                    ),
                    QAItem(
                        question: "How long does ovulation usually last during the menstrual cycle?",
                        answer: "Ovulation typically lasts 24 to 48 hours. This is when the ovary releases an egg, making it the most fertile time in the cycle."
                    ),
                    QAItem(
                        question: "What percentage of menstruating individuals experience mood swings during their cycle?",
                        answer: "Science says nearly 75% experience mood shifts due to hormonal changes. Think of it as your body fine-tuning emotions—sometimes subtly, sometimes noticeably."
                    ),
                    QAItem(
                        question: "What is the difference between hormonal imbalance and irregular periods?",
                        answer: "Hormonal imbalance means your body has too much or too little of a hormone like estrogen or progesterone. \n\nThis can be triggered by stress, diet, or medical conditions. Irregular periods, on the other hand, happen when your cycle doesn’t follow a predictable pattern. If things seem off, it’s always good to check in with a doctor."
                    ),
                    QAItem(
                        question: "What does it mean if my period blood is pink?",
                        answer: "Pink period blood often means it's mixed with cervical fluid. It could be spotting between cycles, ovulation bleeding, or even a sign of low estrogen levels. If it happens frequently, a doctor’s advice can help."
                    ),
                    QAItem(
                        question: "My periods are a weird color. What should I do?",
                        answer: "Your period’s color can range from bright red to dark brown—it’s all part of the cycle. But if you notice anything unusual, like grayish tones or a sudden drastic change, it might be worth checking in with a healthcare provider."
                    ),
                    QAItem(
                        question: "What are the small clots in my period?",
                        answer: "Period clots are completely normal! They’re just the uterus shedding its lining. As long as they’re small and occasional, there's nothing to worry about."
                    ),
                    QAItem(
                        question: "Why does period blood smell bad?",
                        answer: "Period blood itself doesn’t have an odor, but when it mixes with bacteria, it can develop a scent. \n\nKeeping good hygiene, like changing pads or tampons regularly, helps keep things fresh and comfortable."
                    )
                ]
            ),
            QuestionCategory(
                name: "Frequently Asked",
                items: [
                    QAItem(question: "How can I track my periods?", answer: "You can track your period using the Health app on iPhone. Go to Health > Browse > Cycle Tracking. Log your period dates and the app will help predict your next cycle. Many apps also sync with Apple Health for seamless tracking."),
                    QAItem(question: "How do I track my period?", answer: "Open the Health app, tap ‘Browse’ > ‘Cycle Tracking,’ and log your period dates. Apple HealthKit provides insights over time. You can also use apps that sync with Health for reminders and predictions."),
                    QAItem(question: "How to track menstrual cycle?", answer: "Use the Health app’s Cycle Tracking feature. Log your period start and end dates each month. The app learns your pattern and can predict your next period and fertile window."),
                    QAItem(question: "How can I track my menstrual cycle?", answer: "The Health app lets you log period dates. Tap Browse > Cycle Tracking. With consistent logging, you’ll get predictions and insights. Apple Watch can also track temperature for better accuracy."),
                    QAItem(question: "What is PCOS?", answer: "PCOS (Polycystic Ovary Syndrome) is a hormonal condition that can cause irregular periods, acne, weight changes, and excess hair growth. It’s manageable with lifestyle changes and sometimes medication. A doctor can help."),
                    QAItem(question: "What is PCOD?", answer: "PCOD (Polycystic Ovarian Disease) involves multiple small follicles on the ovaries and can lead to irregular periods. Unlike PCOS, it’s often managed well with lifestyle changes like diet and exercise."),
                    QAItem(question: "What is endometriosis?", answer: "Endometriosis is when tissue similar to the uterine lining grows outside the uterus. It can cause severe period pain, pain during sex, and sometimes fertility issues. A doctor can diagnose and suggest treatment."),
                    QAItem(question: "How to prevent UTI?", answer: "Drink plenty of water, pee when you need to (don’t hold it), wipe front to back, and pee after intimacy. Wear breathable cotton underwear. Cranberry juice may help some people."),
                    QAItem(question: "What causes irregular periods?", answer: "Stress, diet changes, extreme exercise, or hormonal conditions like PCOS can cause irregular periods. Tracking your cycle helps spot patterns. If it persists, see a doctor."),
                    QAItem(question: "Why am I so tired on my period?", answer: "Hormonal shifts and blood loss can cause fatigue. Iron-rich foods help. If you’re very tired often, it could be anemia—a blood test can confirm. Rest and hydration matter."),
                    QAItem(question: "What helps with period cramps?", answer: "Heat (hot water bottle or heating pad), gentle movement, and over-the-counter pain relievers can help. If cramps are severe and disrupt your life, talk to a doctor."),
                    QAItem(question: "Is it normal to have heavy periods?", answer: "Flow varies. Heavy bleeding that soaks through pads quickly or causes fatigue may need a check. Fibroids, hormones, or other conditions can cause it. A doctor can help."),
                    QAItem(question: "How do I know if I have anemia?", answer: "Signs include fatigue, dizziness, pale skin, and weakness. Heavy periods can cause iron loss. A simple blood test can confirm. Iron-rich foods and supplements (if prescribed) help."),
                    QAItem(question: "What is PMS?", answer: "PMS (Premenstrual Syndrome) includes mood swings, bloating, fatigue, and irritability before your period. It’s common. Tracking helps you prepare. Rest, movement, and talking to someone can help."),
                    QAItem(question: "What is a yeast infection?", answer: "A yeast infection is a fungal overgrowth. Symptoms include itching, thick white discharge, and irritation. It’s treatable. Avoid damp clothes and see a doctor if it persists."),
                    QAItem(question: "How long does a period last?", answer: "Most periods last 3 to 7 days. Cycles vary. If yours is very short or very long, or if you’re concerned, a doctor can help."),
                    QAItem(question: "When should I see a doctor about my period?", answer: "See a doctor if you have severe pain, very heavy bleeding, irregular cycles that worry you, or symptoms like fatigue or unusual discharge. Trust your body."),
                    QAItem(question: "Can stress affect my period?", answer: "Yes. Stress can delay or change your period. It affects hormones. Managing stress, sleep, and rest can help. If it’s ongoing, a doctor can rule out other causes."),
                    QAItem(question: "What foods help with periods?", answer: "Iron-rich foods (leafy greens, lentils), magnesium (dark chocolate, nuts), and omega-3s (fish, flaxseed) can help. Stay hydrated. Limit salt if you bloat."),
                    QAItem(question: "How do I use a pad?", answer: "Place the sticky side on your underwear. Change every 4–6 hours or when full. Wash your hands before and after. For first-timers, start with regular pads."),
                    QAItem(question: "How often should I change my pad?", answer: "Every 4–6 hours, or sooner if it’s full or uncomfortable. Change more often on heavy days. Good hygiene helps prevent irritation."),
                    QAItem(question: "How can I track my period on my phone?", answer: "Use the Health app (Cycle Tracking) or any period-tracking app. Log start and end dates. Many apps predict your next period and fertile window."),
                    QAItem(question: "What is thyroid and how does it affect periods?", answer: "The thyroid gland controls metabolism. When it’s underactive (hypothyroidism), it can cause irregular periods, fatigue, and weight gain. A blood test can confirm. Medication helps."),
                    QAItem(question: "Why do I get headaches before my period?", answer: "Hormonal drops before your period can trigger headaches. Staying hydrated, managing stress, and keeping blood sugar stable can help. If severe, see a doctor."),
                    QAItem(question: "Why do I feel bloated before my period?", answer: "Hormones cause fluid retention before your period. Reducing salt, staying hydrated, and gentle movement can help. It’s common and usually temporary."),
                    QAItem(question: "How do I track ovulation?", answer: "Track your cycle length and use apps. Some people track basal body temperature or use ovulation kits. The Health app can help with cycle logging."),
                    QAItem(question: "What is a normal period cycle?", answer: "A normal cycle is usually 21–35 days. Periods last 3–7 days. Your cycle is unique—tracking helps you learn your pattern."),
                    QAItem(question: "How do I know when my period is coming?", answer: "Track your cycle in an app. Many notice PMS signs (bloating, mood changes) a week before. Apps can predict based on your history."),
                ]
            ),
            QuestionCategory(
                    name: "Tracking with Apple Health",
                    items: [
                        QAItem(question: "How can I track my period using Apple HealthKit?", answer: "Seamlessly. Open the Health app, \n\nTap ‘Browse’ > ‘Cycle Tracking,’ and log your period dates. \n\nApple HealthKit does the rest, providing insights over time."),
                        QAItem(question: "What cycle data does the Apple Watch collect?", answer: "Apple Watch can track body temperature, heart rate, and even sleep changes—helping you see how your cycle influences overall health."),
                        QAItem(question: "How accurate is period tracking with smart devices?", answer: "With consistent logging, period tracking apps can predict cycles with high accuracy. Apple HealthKit even refines predictions based on real-time body signals."),
                        QAItem(question: "Can my Apple Watch predict my next period?", answer: "Yes! With cycle data and temperature tracking, Apple Watch offers smarter predictions over time, helping you plan ahead with confidence."),
                        QAItem(question: "How do I enable menstrual tracking in Apple Health?", answer: "Simply go to the Health app, tap ‘Cycle Tracking,’ and start logging. You can enable reminders and sync with Apple Watch for seamless tracking."),
                        QAItem(question: "What are the benefits of tracking my cycle using an app?", answer: "Understanding your body’s rhythm helps manage symptoms, predict fertile windows, and even spot irregularities early—so you're always in sync."),
                        QAItem(question: "How does temperature tracking help in predicting ovulation?", answer: "Apple Watch measures wrist temperature while you sleep, detecting small shifts that indicate ovulation. A smarter way to track fertility."),
                        QAItem(question: "Can fitness trackers like Fitbit or Garmin track my period?", answer: "Yes, many wearables offer cycle tracking, but Apple HealthKit integrates it with your overall wellness—making it more than just a calendar."),
                        QAItem(question: "Does tracking my period help with irregular cycles?", answer: "Absolutely! Noticing patterns (or a lack of them) helps you discuss concerns with a doctor, making period tracking a key part of health awareness."),
                        QAItem(question: "Can I use HealthKit data to track PCOS symptoms?", answer: "Yes! Logging cycle length, symptoms, and body temperature can help identify irregularities. While Apple HealthKit doesn’t diagnose, it gives you valuable insights."),
                        QAItem(question: "How secure is my cycle tracking data in Apple Health?", answer: "Your health data stays yours. Apple HealthKit is designed with privacy in mind—your cycle data is encrypted and never shared without your consent."),
                        QAItem(question: "Can I get notifications about my cycle on my Apple Watch?", answer: "Yes! Enable cycle tracking notifications in the Health app to get gentle reminders about upcoming periods and fertile windows."),
                        QAItem(question: "Does tracking my period help with PMS symptoms?", answer: "Knowing when PMS is coming helps you plan self-care—whether it’s extra hydration, movement, or just some well-timed chocolate."),
                    ]
                ),
            QuestionCategory(
                name: "PCOS & PCOD Made Simple",
                items: [
                    QAItem(
                        question: "What is Polycystic Ovary Syndrome (PCOS)?",
                        answer: "PCOS is a hormonal imbalance that can lead to irregular cycles, acne, weight changes, and excess hair growth.\n\nThe good news? It’s manageable—with the right approach, you can take control of your health."
                    ),
                    QAItem(
                        question: "Tell me about irregular period cycles.",
                        answer: "Your cycle should follow a rhythm. If it's shorter than 21 days, longer than 35, or unpredictable, stress or hormonal shifts might be at play. \n\nTracking it helps you spot patterns and stay informed."
                    ),
                    QAItem(
                        question: "If my period lasts only 3 days, does that mean I have low fertility?",
                        answer: "Not at all! Every body is unique. A 3-day period can be completely normal. What matters most? Ovulation and overall cycle health."
                    ),
                    QAItem(
                        question: "What are the early signs of PCOS in teenagers?",
                        answer: "Irregular periods, stubborn acne, weight fluctuations, and excess hair growth. Noticing these? A quick health check can bring clarity."
                    ),
                    QAItem(
                        question: "Can PCOS cause mood swings or anxiety?",
                        answer: "Yes! Hormonal shifts in PCOS can impact mood, leading to anxiety or mood swings. The key? Balanced nutrition, movement, and stress management can help bring stability."
                    ),
                    QAItem(
                        question: "How does PCOS affect weight and metabolism?",
                        answer: "PCOS can make weight management tricky due to insulin resistance. The secret? Small, consistent lifestyle changes—movement, mindful eating, and stress reduction—make all the difference."
                    ),
                    QAItem(
                        question: "Can someone have PCOS without cysts on their ovaries?",
                        answer: "Absolutely! PCOS is about hormonal imbalances, not just cysts. Some people with PCOS don’t have cysts, and some with ovarian cysts don’t have PCOS."
                    ),
                    QAItem(
                        question: "Why does PCOS cause excessive hair growth?",
                        answer: "Elevated androgens (male hormones) can trigger extra hair growth on the face, chest, or back. The good news? Treatment options exist to help manage this."
                    ),
                    QAItem(
                        question: "Does birth control help with PCOS?",
                        answer: "Yes! It can help regulate cycles, clear acne, and manage symptoms like excess hair growth. The best part? There’s no one-size-fits-all—your doctor can help find what works for you."
                    ),
                    QAItem(
                        question: "What lifestyle changes help manage PCOS symptoms?",
                        answer: "Consistency is key! A balanced diet, quality sleep, and daily movement help regulate hormones and keep symptoms in check."
                    ),
                    QAItem(
                        question: "Can PCOS go away on its own?",
                        answer: "PCOS doesn’t ‘go away,’ but its symptoms can be managed. With the right care, you can feel more in control of your health."
                    ),
                    QAItem(
                        question: "What foods are good for managing PCOS?",
                        answer: "Think whole foods—leafy greens, lean proteins, fiber-rich carbs, and healthy fats. Keeping blood sugar stable is key, so pairing carbs with protein helps."
                    ),
                    QAItem(
                        question: "How does PCOS affect acne and skin health?",
                        answer: "Hormonal imbalances can lead to stubborn breakouts, especially around the jawline. The fix? Hydration, a simple skincare routine, and balancing hormones through lifestyle choices."
                    ),
                    QAItem(
                        question: "What’s the difference between PCOS and PCOD?",
                        answer: "PCOS is a hormonal disorder that affects metabolism and ovulation, while PCOD (Polycystic Ovarian Disorder) primarily refers to ovarian cyst formation. PCOS tends to have a broader impact on health."
                    ),
                    QAItem(
                        question: "What is Polycystic Ovarian Disorder (PCOD)?",
                        answer: "PCOD occurs when the ovaries develop multiple small follicles, leading to irregular periods. The best part? Unlike PCOS, it’s often managed effectively through simple lifestyle changes."
                    ),
                    QAItem(
                        question: "Can PCOD cause weight gain?",
                        answer: "PCOD doesn’t always lead to weight gain, but metabolism can slow down slightly. A balanced diet and movement help keep things in check."
                    ),
                    QAItem(
                        question: "Does PCOD affect fertility?",
                        answer: "Not always. Many with PCOD conceive naturally. Tracking ovulation and maintaining a healthy routine can support fertility."
                    ),
                    QAItem(
                        question: "Can stress make PCOD worse?",
                        answer: "Yes! Stress disrupts hormone levels, which can throw off your cycle. Deep breathing, mindful movement, and sleep can help bring balance."
                    ),
                    QAItem(
                        question: "Do all women with PCOD have irregular periods?",
                        answer: "Not necessarily. Some have regular but lighter periods, while others experience unpredictable cycles. Every body is different."
                    ),
                    QAItem(
                        question: "Is PCOD reversible?",
                        answer: "PCOD symptoms can improve significantly with diet, movement, and stress management. Small, consistent changes make a big impact!"
                    ),
                    QAItem(
                        question: "Can PCOD cause skin issues like acne?",
                        answer: "Yes! Hormonal fluctuations can lead to acne, especially on the jawline and chin. A good skincare routine and hormone balance can help."
                    ),
                    QAItem(
                        question: "What foods should I avoid if I have PCOD?",
                        answer: "Processed foods, excess sugar, and dairy can sometimes trigger symptoms. Think whole foods, fiber, and healthy fats instead!"
                    ),
                    QAItem(
                        question: "How can I naturally regulate my periods with PCOD?",
                        answer: "Regular movement, stress management, and balanced nutrition help create a more predictable cycle. Small changes, big difference!"
                    ),
                    QAItem(
                        question: "Does PCOD lead to excessive hair growth like PCOS?",
                        answer: "PCOD usually doesn’t trigger excessive hair growth like PCOS, but mild fluctuations in hormones can lead to subtle changes."
                    ),
                    QAItem(
                        question: "Can exercise help with PCOD?",
                        answer: "Absolutely! Movement supports hormone balance, improves insulin sensitivity, and helps regulate cycles. It’s about finding what feels good for you."
                    ),
                    QAItem(
                        question: "What role does insulin resistance play in PCOD?",
                        answer: "Unlike PCOS, insulin resistance isn’t a major factor in PCOD. However, stabilizing blood sugar through balanced meals still supports hormonal health."
                    ),
                    QAItem(
                        question: "Do I need medication for PCOD?",
                        answer: "Not always! Many manage PCOD with lifestyle changes alone. If symptoms persist, a doctor can help explore options tailored to you."
                    )
                ]
            ),
            QuestionCategory(
                    name: "UTIs & Infections: Prevention & Care",
                    items: [
                        QAItem(
                            question: "Can I get a urine infection if I am on my periods?",
                            answer: "Yes, but not because of your period itself. Menstrual hygiene plays a big role—changing pads or tampons regularly and staying hydrated helps keep infections away."
                        ),
                        QAItem(
                            question: "Why do I feel itchy during my periods?",
                            answer: "Itching during periods can be due to dryness, irritation from pads, or even mild infections. Switching to breathable cotton underwear and fragrance-free products can help."
                        ),
                        QAItem(
                            question: "What is a Urinary Tract Infection (UTI)?",
                            answer: "A UTI happens when bacteria enter the urinary tract, causing symptoms like burning while peeing, frequent urges, or cloudy urine. It’s common and treatable!"),
                        QAItem(
                            question: "How do I know if I have a UTI?",
                            answer: "If peeing feels like fire, your lower belly aches, or you feel the need to go constantly—those could be signs of a UTI. Drinking water and seeing a doctor early can help."
                        ),
                        QAItem(
                            question: "Can poor menstrual hygiene cause infections?", 
                            answer: "Yes! Changing pads or tampons every 4-6 hours, wiping front to back, and staying dry help prevent bacterial growth and infections."
                        ),
                        QAItem(
                            question: "Why does my urine smell strong during my period?",
                            answer: "Period blood itself doesn’t smell, but when it mixes with natural bacteria, it can create an odor. Staying hydrated and practicing good hygiene helps."
                        ),
                        QAItem(
                            question: "Is it normal to feel a burning sensation while urinating on my period?",
                            answer: "Burning while urinating isn’t a normal period symptom—it could be a UTI, irritation, or even a mild infection. A doctor’s advice can help if it persists."
                        ),
                        QAItem(
                            question: "Can using pads or tampons cause infections?", 
                            answer: "They don’t directly cause infections, but not changing them often enough can trap bacteria and moisture, increasing the risk."
                        ),
                        QAItem(
                            question: "How can I prevent UTIs naturally?",
                            answer: "Simple habits make a big difference! Drink plenty of water, don’t hold your pee, wipe front to back, and urinate after intimacy to flush out bacteria."
                        ),
                        QAItem(
                            question: "What’s the difference between a UTI and a yeast infection?",
                            answer: "UTIs affect the urinary tract, causing pain while peeing. Yeast infections cause itching, thick discharge, and irritation in the vaginal area."
                        ),
                        QAItem(
                            question: "Why do yeast infections happen after my period?",
                            answer: "Hormonal shifts during your cycle can disrupt vaginal pH, making it easier for yeast to grow. Probiotics and breathable fabrics can help."
                        ),
                        QAItem(
                            question: "Can holding pee for too long cause an infection?",
                            answer: "Yes! Holding it too long lets bacteria multiply in the bladder, increasing the risk of UTIs. Listen to your body and go when you need to."
                        ),
                        QAItem(
                            question: "What foods help prevent UTIs?",
                            answer: "Cranberries, blueberries, and probiotic-rich foods like yogurt help keep the urinary tract healthy and balanced."
                        ),
                        QAItem(
                            question: "How do I keep my vaginal area clean during periods?",
                            answer: "Less is more—warm water is enough! Avoid scented products, wear breathable underwear, and change menstrual products regularly."
                        ),
                        QAItem(
                            question: "Does drinking more water help prevent infections?",
                            answer: "Yes! Staying hydrated helps flush out bacteria, keeping your urinary and vaginal health in check."
                        ),
                    ]
                ),
            QuestionCategory(
                    name: "Period Care & Products",
                    items: [
                        QAItem(
                            question: "How to use a tampon?",
                            answer: "Think of it like learning to tie your shoelaces—tricky at first, easy with practice. \n\nWash your hands, get comfy, angle the tampon slightly toward your lower back, and gently insert. If it feels off, adjust. Remove the applicator, leave the string, and change it every 4–8 hours. You’ve got this!"
                        ),QAItem(
                            question: "What are period panties?",
                            answer: "Period panties are leak-proof, reusable underwear designed to absorb menstrual flow. Think of them as a backup for pads or tampons—or even a standalone option for lighter days."
                        ),
                        QAItem(
                            question: "What is the main advantage of reusable menstrual products?",
                            answer: "Sustainability meets savings. Reusable products like menstrual cups and cloth pads reduce waste, save money over time, and offer a comfortable, leak-free experience."
                        ),
                        QAItem(
                            question: "What is the main advantage of menstrual cups in terms of environmental sustainability?",
                            answer: "One cup, years of impact. Unlike disposables, a single menstrual cup can last up to 10 years, drastically cutting down on plastic waste and landfill buildup."
                        ),
                        QAItem(
                            question: "How do eco-friendly menstrual products contribute to reducing waste in landfills?",
                            answer: "Every pad and tampon adds up. By choosing reusable products, you help divert thousands of disposables from landfills, making a small switch with a big environmental impact."
                        ),
                        QAItem(
                            question: "How often should I change my pad or tampon?",
                            answer: "Every 4-6 hours is ideal. For heavier flows, you might need to change more often. Staying fresh means staying comfortable."
                        ),
                        QAItem(
                            question: "Are menstrual cups safe?",
                            answer: "Yes! They’re made from medical-grade silicone, creating a leak-proof seal without disrupting your body’s natural balance. Plus, no more dryness or irritation."
                        ),
                        QAItem(
                            question: "Do menstrual cups hurt?",
                            answer: "Not at all! It’s all about the right fold and placement. With practice, you won’t even feel it—just like wearing your favorite comfy sneakers."
                        ),
                        QAItem(
                            question: "Can I swim while using a menstrual cup?",
                            answer: "Absolutely! Menstrual cups create a secure seal, so no leaks, no worries. Dive in, swim, and enjoy."
                        ),
                        QAItem(
                            question: "What’s the best way to clean a menstrual cup?",
                            answer: "Rinse with warm water and mild soap between uses, and boil for a few minutes at the end of each cycle. Clean, simple, and ready for next time."
                        ),
                        QAItem(
                            question: "What are the benefits of organic cotton pads and tampons?",
                            answer: "Gentle on you, gentle on the planet. Organic products skip the chemicals, dyes, and synthetic fibers—so they’re better for your body and biodegrade faster."
                        ),
                        QAItem(
                            question: "Are period tracking apps useful?",
                            answer: "Absolutely! They help you predict your cycle, track symptoms, and even notice patterns over time. Knowledge is power, and your cycle shouldn’t be a mystery."
                        ),
                        QAItem(
                            question: "Do scented pads or tampons cause irritation?",
                            answer: "They can! Fragrances and synthetic chemicals may disrupt your body’s natural balance, so unscented, breathable options are always a safer choice."
                        ),
                        QAItem(
                            question: "What’s the most eco-friendly menstrual product?",
                            answer: "Menstrual cups, cloth pads, and period panties lead the way. They’re reusable, reduce waste, and are kind to both your body and the planet."
                        ),
                    ]
                ),
            QuestionCategory(
                    name: "Symptoms to Watch For",
                    items: [
                        QAItem(
                            question: "Could I have PCOS?",
                            answer: "If your periods are irregular, you’re noticing excess hair growth, unexplained weight changes, or persistent acne, PCOS might be a factor.\n\nTracking symptoms and checking with a doctor can help bring clarity."
                        ),
                        QAItem(
                            question: "Could I have PCOD?",
                            answer: "PCOD often presents with irregular periods and multiple small ovarian follicles. Unlike PCOS, it’s usually less severe and manageable with lifestyle changes.\n\nIf your cycle feels off, tracking patterns is the first step."
                        ),
                        QAItem(
                            question: "What are signs of hormonal imbalance?",
                            answer: "Sudden mood swings, extreme fatigue, unexpected weight gain, or acne that won’t budge? Your hormones might be asking for attention.\n\nA simple blood test can help uncover the cause."
                        ),
                        QAItem(
                            question: "Could I have endometriosis?",
                            answer: "If your cramps feel unbearable, periods are extremely heavy, or you experience pain during intimacy, endometriosis could be the reason.\n\nA doctor’s visit can provide answers and relief."
                        ),
                        QAItem(
                            question: "Could my period symptoms mean I have thyroid issues?",
                            answer: "A period that’s too light, too heavy, or missing altogether? Paired with fatigue, dry skin, or hair loss? Your thyroid might be out of sync.\n\nA quick test can help rule it out."
                        ),
                        QAItem(
                            question: "Could I have anemia from heavy periods?",
                            answer: "Feeling dizzy, weak, or constantly exhausted during or after your period? Heavy bleeding can deplete iron levels, leading to anemia.\n\nIron-rich foods and a check-in with a doctor can make all the difference."
                        ),
                        QAItem(
                            question: "Are my cramps normal or a sign of something more?",
                            answer: "Mild cramps? Normal. Pain that keeps you from daily life? Not normal.\n\nSevere cramps could indicate endometriosis, fibroids, or PCOS—tracking pain patterns helps uncover the cause."
                        ),
                        QAItem(
                            question: "What if my period has stopped suddenly?",
                            answer: "Missed a period (and you're not pregnant)? Stress, hormonal shifts, extreme exercise, or medical conditions could be the cause.\n\nIf it happens often, a health check can provide answers."
                        )
                    ]
                ),
            QuestionCategory(
                    name: "Managing Symptoms",
                    items: [
                        QAItem(question: "What are some nutrient-rich foods that support menstrual health?", answer: "Fuel your cycle with iron-rich spinach, magnesium-packed dark chocolate, and omega-3-rich nuts. Your body works hard—give it what it needs."),
                        QAItem(question: "What are some dietary strategies for managing common menstrual symptoms?", answer: "Small changes, big relief. Balance your plate with whole foods, fiber, and protein. Reduce salty, processed foods to keep bloating at bay."),
                        QAItem(question: "What should I do when I get cramps?", answer: "Heat, movement, and hydration. A warm compress, gentle stretching, or sipping ginger tea can ease the discomfort. Your body is adjusting—be kind to it."),
                        QAItem(question: "When should I see a doctor for cramps and pain?", answer: "If cramps stop you from living your day, last longer than normal, or don’t improve with home remedies, it’s worth checking in with a doctor."),
                        QAItem(question: "What is causing my Heavy Menstrual Bleeding?", answer: "Hormones, fibroids, or even stress could be at play. If you're soaking through pads quickly or feeling extra fatigued, it's time to seek guidance."),
                        QAItem(question: "How do symptoms vary throughout the cycle?", answer: "Your cycle is a rhythm, not a straight line. Energy may soar after your period, emotions may shift mid-cycle, and cravings or cramps might appear before your next flow."),
                        QAItem(question: "What role does hydration play in menstrual health?", answer: "Water helps everything flow smoothly—literally. Staying hydrated reduces bloating, fatigue, and headaches while keeping your body balanced."),
                        QAItem(question: "Why do I feel exhausted during my period?", answer: "Your body is losing iron, and hormones are shifting. Rest, fuel up on leafy greens, and listen to what your body needs."),
                        QAItem(question: "Is it normal to feel dizzy during my period?", answer: "A little lightheadedness can happen due to low iron or blood pressure shifts. But if it’s frequent or severe, checking with a doctor is a good call."),
                        QAItem(question: "Why do I get headaches before my period?", answer: "Hormonal drops before your period can trigger headaches. Staying hydrated, managing stress, and keeping blood sugar stable can help."),
                        QAItem(question: "Can my period cause nausea?", answer: "Yes, period-related nausea is common due to hormonal shifts and prostaglandins. Small, frequent meals and ginger tea can ease the queasiness."),
                        QAItem(question: "Why do my breasts hurt before my period?", answer: "Hormones cause fluid retention, making breasts feel sore. Wearing a supportive bra and reducing salty foods can help."),
                        QAItem(question: "Is it normal to feel emotional before my period?", answer: "Completely. Mood swings are linked to hormonal shifts. Gentle movement, fresh air, and balanced meals can help stabilize emotions."),
                        QAItem(question: "Why do I crave junk food before my period?", answer: "Your body is prepping for hormone changes, making carbs and sugar extra tempting. Balance cravings with nutrient-rich snacks."),
                        QAItem(question: "Can my period make my skin break out?", answer: "Yes, hormonal fluctuations can cause breakouts, especially around the jawline. A simple, gentle skincare routine keeps things under control."),
                    ]
                ),
            QuestionCategory(
                    name: "Myths vs Facts",
                    items: [
                        QAItem(question: "Is menstruation a taboo subject?", answer: "In many places, yes—but it shouldn’t be. Periods are a natural, biological process. Breaking the silence starts with open conversations."),
                        QAItem(question: "Why do some Indian mothers still tell their daughters to hide their period products?", answer: "Years of conditioning have made periods something to ‘conceal.’ But new generations are rewriting this narrative with openness and confidence."),
                        QAItem(question: "How can LGBTQ+ individuals access menstrual products without stigma?", answer: "Gender-neutral product packaging, inclusive restroom policies, and education help create a more accessible, stigma-free experience for all."),
                        QAItem(question: "How can LGBTQ+ organizations and community centers support menstrual health initiatives?", answer: "By recognizing that not all who menstruate identify as women. Inclusive education, gender-neutral product access, and safe spaces help all individuals manage their health."),
                        QAItem(question: "What role do menstrual taboos play in maintaining social order in certain cultures?", answer: "In some cultures, menstrual taboos stem from ancient beliefs about purity and impurity. While traditions shape societies, education helps rewrite the narrative."),
                        QAItem(question: "How does menstrual inequity impact girls' education in developing nations?", answer: "Lack of access to menstrual products and hygiene facilities forces many girls to miss school. When periods become a barrier, education and opportunity suffer."),
                        QAItem(question: "How did early menstrual product advertisements reflect societal attitudes towards menstruation?", answer: "Early ads avoided direct language, using ‘hygiene’ instead of ‘periods.’ Over time, marketing evolved—now, brands embrace transparency and empowerment."),
                        QAItem(question: "What were some cultural clashes that arose regarding menstrual practices during colonial rule?", answer: "Colonial rulers often dismissed indigenous menstrual practices, imposing Western norms. This led to clashes over beliefs, hygiene, and women’s autonomy."),
                        QAItem(question: "How can sexual health education address menstrual equity and social justice?", answer: "By making periods part of the conversation. Normalizing menstrual health in schools and communities ensures access, dignity, and informed choices for all."),
                        QAItem(question: "How does a father's attitude towards menstruation influence their daughters' perceptions of menstrual health?", answer: "Fathers who talk openly about periods help normalize them. A supportive dad can empower his daughter to embrace her cycle with confidence."),
                        QAItem(question: "How can fathers help reduce menstrual stigma and shame experienced by their daughters?", answer: "By learning, listening, and normalizing. Simple acts—like buying menstrual products or discussing periods casually—break outdated taboos."),
                        QAItem(question: "How do workplace policies regarding menstrual leave vary across different countries?", answer: "Some countries, like Japan and Indonesia, offer menstrual leave, while others barely acknowledge period pain. The conversation on workplace equity is growing."),
                        QAItem(question: "Why are menstruating women still banned from temples in parts of India?", answer: "This belief ties back to purity myths. But times are changing—activists and communities are challenging these outdated restrictions."),
                        QAItem(question: "Why do some Indian families still avoid discussing periods?", answer: "Generations of silence have made periods a ‘women’s issue.’ But with education and awareness, open discussions are finally becoming the norm."),
                        QAItem(question: "Why do some cultures believe menstruating women shouldn't cook or touch food?", answer: "These myths stem from historical misconceptions. Science says otherwise—menstruation doesn’t affect food or energy in any way."),
                        QAItem(question: "How can schools in India improve menstrual health awareness?", answer: "By introducing period education early, providing free products, and training teachers to create safe, stigma-free spaces."),
                        QAItem(question: "How does social media impact menstrual stigma?", answer: "Social media is both a myth-buster and an amplifier of stigma. More open discussions are breaking taboos, one post at a time."),
                        QAItem(question: "What’s the impact of pink tax on menstrual products?", answer: "Some countries still tax pads and tampons as ‘luxury’ items, making them less accessible. Activists worldwide are pushing for tax-free period care."),
                    ]
                ),
            QuestionCategory(
                    name: "When to Seek Help",
                    items: [
                        QAItem(question: "When should I see a doctor about my irregular periods?", answer: "If your cycle is constantly unpredictable, missing for months, or shorter than 21 days, it’s worth a check-in. Your period should work for you, not against you."),
                        QAItem(question: "How many days of period delay is normal before I should worry?", answer: "A few days’ delay is common due to stress, travel, or hormonal shifts. But if you miss multiple cycles or experience sudden changes, a doctor can help."),
                        QAItem(question: "What does it mean if my period suddenly stops?", answer: "Pregnancy, stress, excessive exercise, or hormone imbalances could be at play. If it’s been months with no period, getting checked is a good idea."),
                        QAItem(question: "When should I be concerned about heavy menstrual bleeding?", answer: "If you’re soaking through pads every 1-2 hours, passing large clots, or feeling weak and lightheaded, heavy bleeding isn’t just inconvenient—it’s a sign to seek medical advice."),
                        QAItem(question: "How do I know if my period cramps are abnormal?", answer: "Mild cramps are normal, but if pain keeps you from school, work, or daily activities—even with pain relief—it’s time to explore underlying causes."),
                        QAItem(question: "Is spotting between periods a sign of a serious issue?", answer: "Occasional light spotting can be normal, but if it’s frequent, heavy, or happens after intimacy, it’s best to check in with a doctor."),
                        QAItem(question: "Should I see a doctor if my periods are less than 21 days apart?", answer: "Yes! Frequent cycles could indicate hormonal imbalances or other underlying conditions that need attention."),
                        QAItem(question: "How can I tell if my discharge is normal or a sign of infection?", answer: "Healthy discharge is clear or white with a mild scent. If it's thick, greenish, has a strong odor, or comes with itching, it's time to check in."),
                        QAItem(question: "What symptoms of PCOS or PCOD should I watch out for?", answer: "Irregular cycles, acne, unexplained weight changes, and excess hair growth can be signs. If something feels off, tracking symptoms helps."),
                        QAItem(question: "When should I get tested for hormonal imbalances?", answer: "If you’re dealing with irregular periods, persistent acne, mood swings, or extreme fatigue, testing your hormones can offer answers."),
                        QAItem(question: "What are the signs of anemia due to heavy periods?", answer: "Feeling constantly tired, dizzy, pale, or short of breath? These could be signs of iron deficiency caused by heavy bleeding."),
                        QAItem(question: "How do I know if I have endometriosis?", answer: "Severe cramps, pain during intimacy, heavy bleeding, or trouble with digestion during your cycle might indicate endometriosis. A doctor can help diagnose it."),
                        QAItem(question: "Why do I experience dizziness or fainting during my period?", answer: "Low blood pressure, anemia, or sudden hormonal shifts can cause dizziness. If it’s frequent or extreme, getting checked is a good call."),
                        QAItem(question: "Why do I feel nauseous or have digestive issues during my period?", answer: "Hormones can slow digestion, leading to nausea, bloating, or even period-related diarrhea. If it's severe, a doctor can help."),
                        QAItem(question: "When should I see a doctor about period-related migraines?", answer: "If headaches are intense, happen every cycle, or come with vision issues, period-related migraines could be the cause—and treatment options exist."),
                        QAItem(question: "Can birth control affect my period symptoms?", answer: "Yes! It can lighten periods, ease cramps, or regulate cycles—but it can also cause spotting or changes. A doctor can help find the right fit for you."),
                        QAItem(question: "What does it mean if my periods are extremely painful?", answer: "Pain that interrupts your life isn’t normal. Conditions like endometriosis, fibroids, or hormonal imbalances could be the cause—checking with a doctor helps."),
                        QAItem(question: "Could stress be making my periods irregular?", answer: "Absolutely. Stress affects hormones, which can delay or even skip cycles. Finding ways to relax can help bring your cycle back on track."),
                    ]
                ),
            QuestionCategory(
                    name: "Daily Tips for Your Cycle",
                    items: [
                        QAItem(
                            question: "How does my hair change during periods?",
                            answer: "Ever had a great hair day right before your period? That’s estrogen at work. But during your period, oil production shifts, making hair feel drier or greasier. A little extra care goes a long way!"
                        ),
                        QAItem(
                            question: "How does my menstrual cycle affect my mood?",
                            answer: "Your cycle is a wave of hormonal changes. Some days, you’ll feel energized and social; others, a little more reflective. Knowing your cycle means understanding yourself better."
                        ),
                        QAItem(
                            question: "Is it true that menstruating individuals should avoid physical activity during their period?",
                            answer: "Nope! Movement can actually help with cramps, boost mood, and reduce bloating. Listen to your body—some days call for yoga, others for a rest day."
                        ),
                        QAItem(
                            question: "Why is syncing with your cycle important?",
                            answer: "Your cycle isn’t just about periods—it’s about energy, focus, and emotions. Syncing your workouts, work schedule, and self-care with your cycle helps you feel your best every day."
                        ),
                        QAItem(
                            question: "How does exercise affect my menstrual cycle?",
                            answer: "Movement supports hormone balance, reduces stress, and even helps regulate cycles. Just don’t overdo it—too much intensity can disrupt your cycle."
                        ),
                        QAItem(
                            question: "What should I do when I get cramps?",
                            answer: "Heat, hydration, and movement are your best friends. A warm compress, gentle stretching, or sipping ginger tea can make a world of difference."
                        ),
                        QAItem(
                            question: "At what age do periods stop?",
                            answer: "Menopause typically happens between 45-55 years old. But every body is different—genetics, lifestyle, and health all play a role in the timing."
                        )
                    ]
                )
            
        ]

    }
    
    func loadCheckLists() {
        let expectedCount = 9
        if let savedData = UserDefaults.standard.data(forKey: "savedCheckLists"),
           let decodedCheckLists = try? JSONDecoder().decode([CheckList].self, from: savedData),
           decodedCheckLists.count >= expectedCount {
            checkLists = decodedCheckLists
            let defaults = Self.defaultCheckLists()
            for i in checkLists.indices where checkLists[i].conditionBrief.isEmpty {
                if let match = defaults.first(where: { $0.name == checkLists[i].name }) {
                    checkLists[i].conditionBrief = match.conditionBrief
                }
            }
        } else {
            checkLists = Self.defaultCheckLists()
        }
        // Keep selected index in bounds
        var idx = UserDefaults.standard.integer(forKey: "selectedCheckListIndex")
        if idx < 0 || idx >= checkLists.count { idx = 0 }
        UserDefaults.standard.set(idx, forKey: "selectedCheckListIndex")
    }

    private static func defaultCheckLists() -> [CheckList] {
        [
            // 1. PCOS
            CheckList(
                    name: "PCOS",
                description: "Small, consistent habits create lasting change. This daily checklist supports hormonal balance, reduces inflammation, and boosts metabolism—key in managing PCOS. With mindful nutrition, movement, and recovery, you can take control of your well-being, one check at a time.",
                conditionBrief: "A hormonal condition that can cause irregular periods, cysts on the ovaries, and higher levels of male hormones.",
                    morningList: [
                        CheckListItem(name: "Drink warm lemon water / fenugreek seed water"),
                        CheckListItem(name: "Eat 5 soaked almonds + 2 walnuts + 1 tsp flaxseeds"),
                    CheckListItem(name: "High-protein breakfast (Besan chilla / Sprouts / Ragi dosa / Eggs & toast / Paneer bhurji)"),
                        CheckListItem(name: "10 mins meditation or deep breathing"),
                        CheckListItem(name: "15–30 mins light exercise (walk, Surya Namaskar)")
                    ],
                    afternoonList: [
                        CheckListItem(name: "Drink 1 glass coconut water / buttermilk"),
                        CheckListItem(name: "Eat 1 fruit (Guava, Papaya, Apple, Pomegranate, Berries)"),
                    CheckListItem(name: "Balanced lunch (Dal + Millet/Brown Rice + Sabzi + Curd)"),
                    CheckListItem(name: "10-minute post-lunch walk")
                    ],
                    eveningList: [
                    CheckListItem(name: "Healthy snack (Roasted chana / Makhana / Peanut butter toast / Nuts & seeds)"),
                    CheckListItem(name: "30–45 mins exercise (Yoga, Strength Training, Dance, Brisk Walk)"),
                    CheckListItem(name: "1 cup herbal tea (Spearmint, Cinnamon, Ginger-Turmeric)")
                ],
                    nightList: [
                    CheckListItem(name: "Light dinner (Moong dal khichdi + Ghee / Soup + Sautéed Veggies / 1 Roti + Sabzi + Paneer/Tofu)"),
                    CheckListItem(name: "1 glass warm turmeric milk (Haldi + Almond milk)"),
                        CheckListItem(name: "5 mins deep breathing / gratitude journaling"),
                    CheckListItem(name: "Sleep 7–9 hours")
                    ],
                    commonList: [
                        CheckListItem(name: "Drink 2–3 liters of water"),
                        CheckListItem(name: "Take 5 deep breaths before meals"),
                        CheckListItem(name: "Avoid screens 30 mins before bed")
                    ]
            ),
            // 2. PCOD
            CheckList(
                name: "PCOD",
                description: "PCOD is often managed well with lifestyle. This checklist supports regular cycles and overall wellness through balanced meals, gentle movement, and stress care.",
                conditionBrief: "Polycystic ovarian disease; ovaries may have many small follicles and can lead to irregular cycles and metabolic changes.",
                morningList: [
                    CheckListItem(name: "Warm water with lemon or cumin water"),
                    CheckListItem(name: "Soaked nuts (almonds, walnuts) + seeds"),
                    CheckListItem(name: "Balanced breakfast with protein and fiber"),
                    CheckListItem(name: "10 mins stretching or light walk"),
                    CheckListItem(name: "Short meditation or breathing")
                ],
                afternoonList: [
                    CheckListItem(name: "Fresh fruit or smoothie"),
                    CheckListItem(name: "Lunch with whole grains, dal, vegetables"),
                    CheckListItem(name: "Post-lunch short walk"),
                    CheckListItem(name: "Stay hydrated")
                ],
                eveningList: [
                    CheckListItem(name: "Light snack (fruit, nuts, chana)"),
                    CheckListItem(name: "Yoga or brisk walk 20–30 mins"),
                    CheckListItem(name: "Herbal tea (fennel, cinnamon)")
                ],
                nightList: [
                    CheckListItem(name: "Light, early dinner"),
                    CheckListItem(name: "No heavy screen use before bed"),
                    CheckListItem(name: "Gratitude or journaling"),
                    CheckListItem(name: "Sleep by 10–11 pm")
                ],
                commonList: [
                    CheckListItem(name: "Drink 2+ liters water"),
                    CheckListItem(name: "Eat at regular times"),
                    CheckListItem(name: "Limit junk and excess sugar")
                ]
            ),
            // 3. Endometriosis
            CheckList(
                name: "Endometriosis",
                description: "Daily habits can help manage pain and fatigue. Focus on anti-inflammatory foods, gentle movement, rest, and stress reduction.",
                conditionBrief: "A condition where tissue similar to the lining of the uterus grows outside it, often causing pain and sometimes affecting fertility.",
                morningList: [
                    CheckListItem(name: "Warm water + gentle stretch"),
                    CheckListItem(name: "Anti-inflammatory breakfast (oats, berries, nuts)"),
                    CheckListItem(name: "Take prescribed meds if any, with food"),
                    CheckListItem(name: "10 mins gentle movement or walk"),
                    CheckListItem(name: "Breathing exercise")
                ],
                afternoonList: [
                    CheckListItem(name: "Balanced lunch (avoid heavy fried food)"),
                    CheckListItem(name: "Short rest if needed"),
                    CheckListItem(name: "Hydrate well"),
                    CheckListItem(name: "Light snack (fruit, yogurt)")
                ],
                eveningList: [
                    CheckListItem(name: "Gentle exercise (walk, yoga, swimming)"),
                    CheckListItem(name: "Warm bath or heat pack if helpful"),
                    CheckListItem(name: "Herbal tea (ginger, chamomile)")
                ],
                nightList: [
                    CheckListItem(name: "Light dinner, early"),
                    CheckListItem(name: "Wind-down routine (no screens)"),
                    CheckListItem(name: "Comfortable sleep setup"),
                    CheckListItem(name: "Sleep 7–8 hours")
                ],
                commonList: [
                    CheckListItem(name: "Drink enough water"),
                    CheckListItem(name: "Note pain or symptoms if tracking"),
                    CheckListItem(name: "Avoid overexertion on bad days")
                ]
            ),
            // 4. Thyroid (Hypothyroidism)
            CheckList(
                name: "Thyroid",
                description: "Support energy and metabolism with consistent meals, medication timing, sleep, and gentle activity. Always take thyroid medicine as prescribed.",
                conditionBrief: "When the thyroid gland doesn’t make enough hormones (hypothyroidism), affecting energy, metabolism, and often periods.",
                morningList: [
                    CheckListItem(name: "Take thyroid medication on empty stomach (as prescribed)"),
                    CheckListItem(name: "Wait 30–60 mins before breakfast"),
                    CheckListItem(name: "Protein-rich breakfast (eggs, dal, paneer, oats)"),
                    CheckListItem(name: "Short walk or light exercise"),
                    CheckListItem(name: "Morning sunlight if possible")
                ],
                afternoonList: [
                    CheckListItem(name: "Balanced lunch (whole grains, vegetables, protein)"),
                    CheckListItem(name: "Avoid skipping meals"),
                    CheckListItem(name: "Hydrate"),
                    CheckListItem(name: "Short walk after lunch")
                ],
                eveningList: [
                    CheckListItem(name: "Healthy snack (nuts, fruit)"),
                    CheckListItem(name: "20–30 mins walk or light workout"),
                    CheckListItem(name: "Limit caffeine after 4 pm")
                ],
                nightList: [
                    CheckListItem(name: "Light dinner, 2–3 hours before bed"),
                    CheckListItem(name: "Consistent sleep time"),
                    CheckListItem(name: "Screen off 30–60 mins before bed"),
                    CheckListItem(name: "Sleep 7–8 hours")
                ],
                commonList: [
                    CheckListItem(name: "Drink 2+ liters water"),
                    CheckListItem(name: "Eat at regular times"),
                    CheckListItem(name: "Take supplements if prescribed (e.g. B12, D)")
                ]
            ),
            // 5. Anemia / Iron deficiency
            CheckList(
                name: "Anemia",
                description: "Support iron levels with iron-rich foods, vitamin C with meals, and rest. Avoid tea/coffee with meals to help iron absorb.",
                conditionBrief: "Low red blood cells or hemoglobin, often from low iron, leading to tiredness, weakness, and sometimes paleness.",
                morningList: [
                    CheckListItem(name: "Iron-rich breakfast (poha with greens, eggs, dates, nuts)"),
                    CheckListItem(name: "Vitamin C with meal (lemon, orange, amla)"),
                    CheckListItem(name: "No tea/coffee with or right after breakfast"),
                    CheckListItem(name: "Light walk if energy allows"),
                    CheckListItem(name: "Take iron supplement if prescribed (with vitamin C)")
                ],
                afternoonList: [
                    CheckListItem(name: "Lunch with greens, dal, beetroot, jaggery"),
                    CheckListItem(name: "Fruit (pomegranate, apple, citrus)"),
                    CheckListItem(name: "Hydrate with water, not only tea"),
                    CheckListItem(name: "Rest 10–15 mins if tired")
                ],
                eveningList: [
                    CheckListItem(name: "Snack (dates, nuts, chikki)"),
                    CheckListItem(name: "Light activity, don’t overdo"),
                    CheckListItem(name: "Avoid tea/coffee close to dinner")
                ],
                nightList: [
                    CheckListItem(name: "Dinner with dal, leafy veg, roti"),
                    CheckListItem(name: "Early, light dinner"),
                    CheckListItem(name: "Relax before bed"),
                    CheckListItem(name: "Sleep 7–8 hours")
                ],
                commonList: [
                    CheckListItem(name: "Drink 2+ liters water"),
                    CheckListItem(name: "Pair iron foods with vitamin C"),
                    CheckListItem(name: "Space tea/coffee from meals by 1–2 hours")
                ]
            ),
            // 6. PMS / PMDD
            CheckList(
                name: "PMS / PMDD",
                description: "Ease mood, bloating, and fatigue with regular meals, movement, sleep, and calming routines. Calcium, magnesium, and B vitamins can help.",
                conditionBrief: "PMS is physical and emotional changes before periods; PMDD is a more severe form that can affect daily life.",
                morningList: [
                    CheckListItem(name: "Balanced breakfast (whole grains, protein)"),
                    CheckListItem(name: "Limit salt and processed food"),
                    CheckListItem(name: "10–15 mins walk or stretch"),
                    CheckListItem(name: "Breathing or short meditation"),
                    CheckListItem(name: "Take supplements if prescribed (e.g. calcium, Mg, B6)")
                ],
                afternoonList: [
                    CheckListItem(name: "Lunch with vegetables and protein"),
                    CheckListItem(name: "Fruit or nuts for snack"),
                    CheckListItem(name: "Stay hydrated"),
                    CheckListItem(name: "Short walk")
                ],
                eveningList: [
                    CheckListItem(name: "Light exercise (walk, yoga) to ease mood"),
                    CheckListItem(name: "Avoid heavy dinner"),
                    CheckListItem(name: "Herbal tea (chamomile, peppermint)")
                ],
                nightList: [
                    CheckListItem(name: "Light dinner, early"),
                    CheckListItem(name: "Wind-down routine"),
                    CheckListItem(name: "No screens before bed"),
                    CheckListItem(name: "Sleep 7–8 hours")
                ],
                commonList: [
                    CheckListItem(name: "Drink 2+ liters water"),
                    CheckListItem(name: "Eat small, frequent meals if bloated"),
                    CheckListItem(name: "Note symptoms if tracking cycle")
                ]
            ),
            // 7. Irregular periods
            CheckList(
                name: "Irregular periods",
                description: "Support a more regular cycle with stable meals, sleep, stress management, and gentle movement. Consistency matters more than perfection.",
                conditionBrief: "Cycles that vary a lot in length, are too frequent, or are missed; can have many causes including stress or hormones.",
                morningList: [
                    CheckListItem(name: "Wake and eat around same time"),
                    CheckListItem(name: "Balanced breakfast (protein + fiber)"),
                    CheckListItem(name: "10–15 mins movement (walk, yoga)"),
                    CheckListItem(name: "Breathing or meditation"),
                    CheckListItem(name: "Morning sunlight if possible")
                ],
                afternoonList: [
                    CheckListItem(name: "Balanced lunch, avoid skipping"),
                    CheckListItem(name: "Fruit or nuts snack"),
                    CheckListItem(name: "Hydrate"),
                    CheckListItem(name: "Short walk")
                ],
                eveningList: [
                    CheckListItem(name: "30 mins exercise (walk, yoga, dance)"),
                    CheckListItem(name: "Light snack, no heavy late eating"),
                    CheckListItem(name: "Herbal tea")
                ],
                nightList: [
                    CheckListItem(name: "Dinner 2–3 hours before bed"),
                    CheckListItem(name: "Same bedtime when possible"),
                    CheckListItem(name: "Screen off before bed"),
                    CheckListItem(name: "Sleep 7–8 hours")
                ],
                commonList: [
                    CheckListItem(name: "Drink 2+ liters water"),
                    CheckListItem(name: "Manage stress (rest, hobbies)"),
                    CheckListItem(name: "Track cycle if helpful")
                ]
            ),
            // 8. UTI prevention
            CheckList(
                name: "UTI prevention",
                description: "Reduce UTI risk with hydration, good hygiene, and healthy habits. Don’t hold urine; pee when you need to.",
                conditionBrief: "Urinary tract infections are bacterial infections in the bladder or urethra; prevention focuses on hygiene and hydration.",
                morningList: [
                    CheckListItem(name: "Drink 1–2 glasses water after waking"),
                    CheckListItem(name: "Empty bladder when you feel the urge"),
                    CheckListItem(name: "Wipe front to back"),
                    CheckListItem(name: "Wear breathable cotton underwear"),
                    CheckListItem(name: "Avoid holding urine")
                ],
                afternoonList: [
                    CheckListItem(name: "Drink water through the day"),
                    CheckListItem(name: "Cranberry juice or supplement if advised"),
                    CheckListItem(name: "Pee after being out / after exercise"),
                    CheckListItem(name: "Eat probiotic food (curd, buttermilk) if liked")
                ],
                eveningList: [
                    CheckListItem(name: "Keep hydrating"),
                    CheckListItem(name: "Pee before bed"),
                    CheckListItem(name: "Avoid harsh soaps in intimate area")
                ],
                nightList: [
                    CheckListItem(name: "Pee when you wake at night if needed"),
                    CheckListItem(name: "Change out of tight clothes at home"),
                    CheckListItem(name: "Sleep in loose, clean clothes")
                ],
                commonList: [
                    CheckListItem(name: "Drink 2–3 liters water daily"),
                    CheckListItem(name: "Pee after intimacy"),
                    CheckListItem(name: "Don’t hold urine long")
                ]
            ),
            // 9. General menstrual wellness
            CheckList(
                name: "General wellness",
                description: "For anyone who wants to support their cycle and overall health. Simple daily habits for energy, mood, and balance.",
                conditionBrief: "Supporting overall menstrual and reproductive health through daily habits.",
                morningList: [
                    CheckListItem(name: "Drink water after waking"),
                    CheckListItem(name: "Balanced breakfast"),
                    CheckListItem(name: "10–20 mins movement (walk, stretch)"),
                    CheckListItem(name: "Brief meditation or breathing"),
                    CheckListItem(name: "Take any supplements if advised")
                ],
                afternoonList: [
                    CheckListItem(name: "Balanced lunch"),
                    CheckListItem(name: "Fruit or healthy snack"),
                    CheckListItem(name: "Hydrate"),
                    CheckListItem(name: "Short walk or stretch")
                ],
                eveningList: [
                    CheckListItem(name: "Light exercise or walk"),
                    CheckListItem(name: "Healthy dinner"),
                    CheckListItem(name: "Wind-down (no heavy screens)")
                ],
                nightList: [
                    CheckListItem(name: "Light dinner, not too late"),
                    CheckListItem(name: "Consistent sleep time"),
                    CheckListItem(name: "Sleep 7–8 hours")
                ],
                commonList: [
                    CheckListItem(name: "Drink 2+ liters water"),
                    CheckListItem(name: "Eat at regular times"),
                    CheckListItem(name: "Move and rest consistently")
                ]
            )
        ]
    }
      
    //MARK: - Stories (Life) functions
    
    func getAllStories() -> [Story] {
        stories
    }
    
    func getNumberOfStories() -> Int {
        stories.count
    }

    private static let completedStoryIndicesKey = "completedStoryIndices"

    /// Records that the user completed the story at the given index. Idempotent per story.
    func recordCompletedStory(at index: Int) {
        guard (0..<stories.count).contains(index) else { return }
        var stored = UserDefaults.standard.string(forKey: Self.completedStoryIndicesKey) ?? ""
        let set = Set(stored.split(separator: ",").compactMap { Int($0) })
        if set.contains(index) { return }
        var list = set.sorted()
        list.append(index)
        UserDefaults.standard.set(list.map(String.init).joined(separator: ","), forKey: Self.completedStoryIndicesKey)
        objectWillChange.send()
    }

    /// Number of stories the user has completed (reached and dismissed the final scene).
    func getNumberOfCompletedStories() -> Int {
        let stored = UserDefaults.standard.string(forKey: Self.completedStoryIndicesKey) ?? ""
        return Set(stored.split(separator: ",").compactMap { Int($0) }).count
    }
    
    func getStory(at index: Int) -> Story {
        stories[index]
    }
    
    func getAllStoryScenes(ofStoryIndex index: Int) -> [StoryScene] {
        stories[index].storyScenes
    }
    
    func getNumberOfStoryScenes(ofStoryIndex index: Int) -> Int {
        stories[index].storyScenes.count
    }
    
    func getStoryScene(ofStoryIndex index: Int, sceneIndex: Int) -> StoryScene {
        stories[index].storyScenes[sceneIndex]
    }
    
    func getFinalScene(ofStoryIndex index: Int) -> StoryScene {
        stories[index].finalScene
    }
    
    func getTitleOfStory(ofStoryIndex index: Int) -> String {
        stories[index].title
    }
    
    func getAllTitlesOfStories() -> [String] {
        stories.map { $0.title }
    }
    
    func getTitleOfStory(of index: Int) -> String {
        getAllStories()[index].title
    }
    
    func getAllImagesOfStories() -> [String] {
        stories.map { $0.storyImage }
    }
    
    func getImageOfStory(at index: Int) -> String {
        getAllStories()[index].storyImage
    }
    
    func getMCQScene(ofStoryIndex index: Int) -> MCQScene {
        stories[index].mcqScene
    }
    
    func getNumberOfDescriptionsInScene(ofStoryIndex index: Int, sceneIndex: Int) -> Int {
        stories[index].storyScenes[sceneIndex].descriptions.count
    }
    
    //MARK: - Ask (Talk) functions

    func getAllQuestionCategories() -> [QuestionCategory] {
        questionCategories
    }

    func searchQAItems(query: String) -> QASearchResult {
        let q = query.trimmingCharacters(in: .whitespacesAndNewlines)
        if q.isEmpty { return QASearchResult(items: [], isLowConfidence: false, relatedQuestions: []) }

        let allItems = questionCategories.flatMap { $0.items }
        let qLower = q.lowercased()

        // 1. Exact substring match (fast) – high confidence
        let exactMatches = allItems.filter { $0.question.lowercased().contains(qLower) }
        if !exactMatches.isEmpty {
            return QASearchResult(items: exactMatches, isLowConfidence: false, relatedQuestions: [])
        }

        // 2. Multi-word match – high confidence
        let words = qLower.split(separator: " ").map(String.init).filter { $0.count > 2 }
        if words.count >= 2 {
            let multiWordMatches = allItems.filter { item in
                let questionLower = item.question.lowercased()
                let matchCount = words.filter { questionLower.contains($0) }.count
                return matchCount >= words.count - 1
            }
            if !multiWordMatches.isEmpty {
                return QASearchResult(items: multiWordMatches, isLowConfidence: false, relatedQuestions: [])
            }
        }

        // 3. Semantic search – always return best match (Option 2: "best attempt")
        let semanticScored = SemanticSearchHelper.semanticSearchWithScores(query: q, in: allItems, limit: 5, minThreshold: nil)
        if let best = semanticScored.first {
            let isLowConfidence = best.score < 0.25
            let related = semanticScored.dropFirst().map(\.item)
            return QASearchResult(items: [best.item], isLowConfidence: isLowConfidence, relatedQuestions: Array(related))
        }

        // 4. No semantic match at all – return top 3 as related suggestions
        return QASearchResult(items: [], isLowConfidence: false, relatedQuestions: semanticScored.prefix(3).map(\.item))
    }

    func getSuggestedQAItems() -> [QAItem] {
        questionCategories.prefix(6).compactMap { $0.items.first }
    }

    /// Returns QA items for suggestions, excluding already-asked questions, to keep suggestions populated.
    func getSuggestedQAItems(limit: Int, excluding askedQuestions: Set<String>) -> [QAItem] {
        let allItems = questionCategories.flatMap { $0.items }
        let normalizedAsked = Set(askedQuestions.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) })
        return Array(allItems
            .filter { !normalizedAsked.contains($0.question.trimmingCharacters(in: .whitespacesAndNewlines)) }
            .prefix(limit))
    }
    
    //MARK: - Plans (Logs) functions

    private static let selectedCheckListIndexKey = "selectedCheckListIndex"

    func getSelectedCheckListIndex() -> Int {
        let idx = UserDefaults.standard.integer(forKey: Self.selectedCheckListIndexKey)
        if idx < 0 || idx >= checkLists.count { return 0 }
        return idx
    }

    func setSelectedCheckListIndex(_ index: Int) {
        let idx = max(0, min(index, checkLists.count - 1))
        UserDefaults.standard.set(idx, forKey: Self.selectedCheckListIndexKey)
    }

    private static let enabledCheckListIndicesKey = "enabledCheckListIndices"

    /// Indices of checklists the user chose to show in the Plans tab. Empty = show selection screen.
    func getEnabledCheckListIndices() -> [Int] {
        guard let s = UserDefaults.standard.string(forKey: Self.enabledCheckListIndicesKey), !s.isEmpty else {
            return []
        }
        return s.split(separator: ",").compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
            .filter { $0 >= 0 && $0 < checkLists.count }
    }

    func setEnabledCheckListIndices(_ indices: [Int]) {
        let valid = indices.filter { $0 >= 0 && $0 < checkLists.count }
        let value = valid.map(String.init).joined(separator: ",")
        UserDefaults.standard.set(value, forKey: Self.enabledCheckListIndicesKey)
    }

    func getCheckList(at index: Int) -> CheckList {
        guard index >= 0, index < checkLists.count else {
            return checkLists.first ?? CheckList(name: "", description: "", conditionBrief: "", morningList: [], afternoonList: [], eveningList: [], nightList: [], commonList: [])
        }
        return checkLists[index]
    }

    func getSelectedCheckList() -> CheckList {
        getCheckList(at: getSelectedCheckListIndex())
    }
    
    func getPCOSCheckList() -> CheckList {
        getSelectedCheckList()
    }
    
    func toggleCheckItem(checkListIndex: Int, category: ChecklistCategory, itemIndex: Int) {
        guard checkListIndex < checkLists.count else { return }

        switch category {
        case .morning:
            guard itemIndex < checkLists[checkListIndex].morningList.count else { return }
            checkLists[checkListIndex].morningList[itemIndex].isChecked.toggle()
        case .afternoon:
            guard itemIndex < checkLists[checkListIndex].afternoonList.count else { return }
            checkLists[checkListIndex].afternoonList[itemIndex].isChecked.toggle()
        case .evening:
            guard itemIndex < checkLists[checkListIndex].eveningList.count else { return }
            checkLists[checkListIndex].eveningList[itemIndex].isChecked.toggle()
        case .night:
            guard itemIndex < checkLists[checkListIndex].nightList.count else { return }
            checkLists[checkListIndex].nightList[itemIndex].isChecked.toggle()
        case .common:
            guard itemIndex < checkLists[checkListIndex].commonList.count else { return }
            checkLists[checkListIndex].commonList[itemIndex].isChecked.toggle()
        }

        saveCheckLists()
        objectWillChange.send()
    }

    func setAllCheckedToTrue(checkListIndex: Int, category: ChecklistCategory) {
        guard checkListIndex < checkLists.count else { return }
        switch category {
        case .morning:
            for i in checkLists[checkListIndex].morningList.indices {
                checkLists[checkListIndex].morningList[i].isChecked = true
            }
        case .afternoon:
            for i in checkLists[checkListIndex].afternoonList.indices {
                checkLists[checkListIndex].afternoonList[i].isChecked = true
            }
        case .evening:
            for i in checkLists[checkListIndex].eveningList.indices {
                checkLists[checkListIndex].eveningList[i].isChecked = true
            }
        case .night:
            for i in checkLists[checkListIndex].nightList.indices {
                checkLists[checkListIndex].nightList[i].isChecked = true
            }
        case .common:
            for i in checkLists[checkListIndex].commonList.indices {
                checkLists[checkListIndex].commonList[i].isChecked = true
            }
        }
        saveCheckLists()
        objectWillChange.send()
    }

    func addCheckListItem(checkListIndex: Int, category: ChecklistCategory, name: String) {
        guard checkListIndex < checkLists.count, !name.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        let item = CheckListItem(name: name.trimmingCharacters(in: .whitespaces), isChecked: false, isUserAdded: true)
        switch category {
        case .morning: checkLists[checkListIndex].morningList.append(item)
        case .afternoon: checkLists[checkListIndex].afternoonList.append(item)
        case .evening: checkLists[checkListIndex].eveningList.append(item)
        case .night: checkLists[checkListIndex].nightList.append(item)
        case .common: checkLists[checkListIndex].commonList.append(item)
        }
        saveCheckLists()
        objectWillChange.send()
    }

    func removeCheckListItem(checkListIndex: Int, category: ChecklistCategory, itemId: UUID) {
        guard checkListIndex < checkLists.count else { return }
        switch category {
        case .morning: checkLists[checkListIndex].morningList.removeAll { $0.id == itemId }
        case .afternoon: checkLists[checkListIndex].afternoonList.removeAll { $0.id == itemId }
        case .evening: checkLists[checkListIndex].eveningList.removeAll { $0.id == itemId }
        case .night: checkLists[checkListIndex].nightList.removeAll { $0.id == itemId }
        case .common: checkLists[checkListIndex].commonList.removeAll { $0.id == itemId }
        }
        saveCheckLists()
        objectWillChange.send()
    }
    
    func saveCheckLists() {
        if let encodedData = try? JSONEncoder().encode(checkLists) {
            UserDefaults.standard.set(encodedData, forKey: "savedCheckLists")
        }
    }


    func getCheckLists() -> [CheckList] {
        return checkLists
    }
    
    func getCheckListsProgress() -> Double {
        getSelectedCheckList().progress
    }

    // MARK: - Streak / completion history
    private static let planCompletionDatesKey = "planCompletionDates"

    /// Call when user completes 100% for the day (e.g. when showing celebration). Idempotent per day.
    func recordPlanCompletionDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        let today = formatter.string(from: Date())
        var stored = UserDefaults.standard.string(forKey: Self.planCompletionDatesKey) ?? ""
        let set = Set(stored.split(separator: ",").map(String.init))
        if set.contains(today) { return }
        var list = set.sorted()
        list.append(today)
        list = list.suffix(14).map { String($0) }
        UserDefaults.standard.set(list.joined(separator: ","), forKey: Self.planCompletionDatesKey)
    }

    /// Dates (yyyy-MM-dd) when user completed plan, most recent last. Limited to last 14 days.
    func getPlanCompletionDateStrings() -> [String] {
        let stored = UserDefaults.standard.string(forKey: Self.planCompletionDatesKey) ?? ""
        return stored.split(separator: ",").map(String.init)
    }

    /// Consecutive days with completion ending today. Today counts if completed.
    func getCurrentStreak() -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        let today = formatter.string(from: Date())
        let completed = Set(getPlanCompletionDateStrings())
        var streak = 0
        var date = Date()
        let cal = Calendar.current
        for _ in 0..<14 {
            let dayStr = formatter.string(from: date)
            if !completed.contains(dayStr) {
                if cal.isDateInToday(date) { break }
                break
            }
            streak += 1
            guard let next = cal.date(byAdding: .day, value: -1, to: date) else { break }
            date = next
        }
        return streak
    }

    /// Number of days in the last 7 days (including today) when the user completed the plan.
    func getCompletedDaysInLastSevenDays() -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        let completed = Set(getPlanCompletionDateStrings())
        let cal = Calendar.current
        var count = 0
        var date = Date()
        for _ in 0..<7 {
            let dayStr = formatter.string(from: date)
            if completed.contains(dayStr) { count += 1 }
            guard let next = cal.date(byAdding: .day, value: -1, to: date) else { break }
            date = next
        }
        return count
    }

    /// Last 7 days (most recent first) with true if plan was completed that day.
    func getLastSevenDaysCompletion() -> [(dayLabel: String, completed: Bool)] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        let shortFormatter = DateFormatter()
        shortFormatter.dateFormat = "EEE"
        shortFormatter.timeZone = TimeZone.current
        let completed = Set(getPlanCompletionDateStrings())
        let cal = Calendar.current
        var result: [(String, Bool)] = []
        var date = Date()
        for _ in 0..<7 {
            let dayStr = formatter.string(from: date)
            let label = shortFormatter.string(from: date)
            result.append((label, completed.contains(dayStr)))
            guard let next = cal.date(byAdding: .day, value: -1, to: date) else { break }
            date = next
        }
        return result.reversed()
    }

    // MARK: - Daily notes
    private static let dailyNotesKey = "planDailyNotes"

    private static func noteKey(for date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.timeZone = TimeZone.current
        return f.string(from: date)
    }

    func getNote(for date: Date) -> String {
        let key = Self.noteKey(for: date)
        guard let dict = UserDefaults.standard.dictionary(forKey: Self.dailyNotesKey) as? [String: String] else { return "" }
        return dict[key] ?? ""
    }

    func setNote(for date: Date, text: String) {
        var dict = (UserDefaults.standard.dictionary(forKey: Self.dailyNotesKey) as? [String: String]) ?? [:]
        let key = Self.noteKey(for: date)
        if text.isEmpty {
            dict.removeValue(forKey: key)
        } else {
            dict[key] = text
        }
        UserDefaults.standard.set(dict, forKey: Self.dailyNotesKey)
    }

    // MARK: - Mood

    private static func moodKey(for date: Date) -> String {
        let f = DateFormatter(); f.dateFormat = "yyyy-MM-dd"
        return "mood_\(f.string(from: date))"
    }

    func getMood(for date: Date) -> Int? {
        let val = UserDefaults.standard.integer(forKey: Self.moodKey(for: date))
        return val == 0 ? nil : val
    }

    func setMood(for date: Date, mood: Int) {
        UserDefaults.standard.set(mood, forKey: Self.moodKey(for: date))
        objectWillChange.send()
    }

    
    private func checkAndResetIfNewDay() {
            let calendar = Calendar.current
            let lastSavedDate = UserDefaults.standard.object(forKey: "lastSavedDate") as? Date ?? Date.distantPast
            let currentDate = Date()
            
            if !calendar.isDate(lastSavedDate, inSameDayAs: currentDate) {
                resetAllCheckItems()
                objectWillChange.send()
            }
                UserDefaults.standard.set(currentDate, forKey: "lastSavedDate")
        }
        
        private func resetAllCheckItems() {
            for i in checkLists.indices {
                resetListItems(&checkLists[i].morningList)
                resetListItems(&checkLists[i].afternoonList)
                resetListItems(&checkLists[i].eveningList)
                resetListItems(&checkLists[i].nightList)
                resetListItems(&checkLists[i].commonList)
            }
            saveCheckLists()
        }
        
        private func resetListItems(_ list: inout [CheckListItem]) {
            for j in list.indices {
                list[j].isChecked = false
            }
        }
    
    
    //MARK: - User functions
    func getUserName() -> String {
        user.name
    }
    
    func setUserName(name: String) {
        user.name = name
        UserDefaults.standard.set(name, forKey: "userName")
    }
    
    func getUserAge() -> Int {
        user.age
    }
    
    func setUserAge(age: Int) {
        user.age = age
        UserDefaults.standard.set(age, forKey: "userAge")
    }

    private static let questionsAskedKey = "more_questionsAsked"
    func getQuestionsAskedCount() -> Int {
        UserDefaults.standard.integer(forKey: Self.questionsAskedKey)
    }
    func incrementQuestionsAsked() {
        let n = UserDefaults.standard.integer(forKey: Self.questionsAskedKey)
        UserDefaults.standard.set(n + 1, forKey: Self.questionsAskedKey)
    }

    // MARK: - More (Badges, Conditions, Glossary, Myth, Progress)

    func getBadgeDefinitions() -> [BadgeDef] {
        [
            BadgeDef(id: "first_story", title: "First story", systemImage: "book.fill", customImage: "badge_first_story"),
            BadgeDef(id: "week_streak", title: "Week streak", systemImage: "flame.fill", customImage: "badge_week_streak"),
            BadgeDef(id: "plan_complete", title: "Plan complete", systemImage: "checkmark.circle.fill", customImage: "badge_plan_complete"),
            BadgeDef(id: "explorer", title: "Explorer", systemImage: "star.fill", customImage: "badge_explorer"),
        ]
    }

    func getUnlockedBadgeIds() -> Set<String> {
        var ids: Set<String> = []
        if getNumberOfCompletedStories() > 0 { ids.insert("first_story") }
        if getCurrentStreak() >= 7 { ids.insert("week_streak") }
        if getCheckListsProgress() >= 100 { ids.insert("plan_complete") }
        ids.insert("explorer")
        return ids
    }

    func getConditions() -> [ConditionInfo] {
        let imageMap: [String: String] = [
            "PCOS":               "PCOS",
            "PCOD":               "PCOD",
            "Endometriosis":      "Endometriosis",
            "Thyroid":            "Thyroid",
            "Anemia":             "Anemia",
            "PMS / PMDD":         "PMS_PMDD",
            "Irregular periods":  "IrregularPeriods",
            "UTI prevention":     "UTIPrevention",
            "General wellness":   "GeneralWellness",
        ]
        return checkLists.enumerated().map { index, list in
            ConditionInfo(
                id: list.id.uuidString,
                title: list.name,
                summary: list.conditionBrief.isEmpty ? list.description : list.conditionBrief,
                whenToSeeDoctor: "If symptoms persist or worry you, see a doctor.",
                storyIndex: nil,
                glossaryTermId: nil,
                tipWhenSelected: nil,
                imageName: imageMap[list.name]
            )
        }
    }

    func getGlossaryTerms() -> [GlossaryTerm] {
        [
            GlossaryTerm(id: "pcos", term: "PCOS", definition: "Polycystic Ovary Syndrome – a hormonal condition that can affect periods, weight, and skin."),
            GlossaryTerm(id: "pcod", term: "PCOD", definition: "Polycystic Ovarian Disease – often managed with lifestyle changes."),
            GlossaryTerm(id: "endometriosis", term: "Endometriosis", definition: "When tissue similar to the uterine lining grows outside the uterus, often causing pain."),
            GlossaryTerm(id: "uti", term: "UTI", definition: "Urinary Tract Infection – can be prevented with good hygiene and hydration."),
            GlossaryTerm(id: "anemia", term: "Anemia", definition: "Low red blood cells or hemoglobin, often causing fatigue; can be linked to heavy periods."),
            GlossaryTerm(id: "pms", term: "PMS", definition: "Premenstrual Syndrome – physical and emotional symptoms before a period."),
        ]
    }

    func getMythFacts() -> [MythFact] {
        [
            MythFact(id: "1", myth: "You shouldn't exercise during your period.", fact: "Light to moderate exercise can ease cramps and boost mood. Movement releases endorphins that help with pain.", topic: "period"),
            MythFact(id: "2", myth: "Irregular periods always mean something is wrong.", fact: "Stress, diet, or travel can cause temporary irregularity. Track patterns and see a doctor only if it persists.", topic: "period"),
            MythFact(id: "3", myth: "PCOS means you can't have children.", fact: "PCOS can affect fertility, but many people with PCOS conceive with the right lifestyle changes and/or treatment.", topic: "pcos"),
            MythFact(id: "4", myth: "Period blood is dirty or impure.", fact: "Period blood is simply the uterine lining shedding. It is a normal, healthy biological process — nothing impure about it.", topic: "period"),
            MythFact(id: "5", myth: "You can't get a UTI if you drink enough water.", fact: "Staying hydrated helps, but UTIs are caused by bacteria entering the urethra. Hygiene habits and wiping front to back matter more.", topic: "uti"),
            MythFact(id: "6", myth: "Tampons are only for adults.", fact: "Anyone who menstruates can use a tampon, regardless of age. It's about comfort and preference, not maturity.", topic: "period"),
            MythFact(id: "7", myth: "PCOD and PCOS are the same condition.", fact: "PCOD involves multiple follicles on the ovaries and is often lifestyle-manageable. PCOS is a hormonal disorder with broader metabolic effects and needs medical management.", topic: "pcos"),
            MythFact(id: "8", myth: "Period cramps are just a normal pain you should tolerate.", fact: "Mild cramps are common, but severe pain that disrupts daily life is not normal. It could signal endometriosis or fibroids — always worth discussing with a doctor.", topic: "period"),
            MythFact(id: "9", myth: "You only need to see a gynaecologist if something is seriously wrong.", fact: "Regular check-ins help catch issues early. You don't need a crisis to visit a doctor — routine care is preventive care.", topic: "general"),
            MythFact(id: "10", myth: "Yeast infections are caused by poor hygiene.", fact: "Yeast infections are caused by an imbalance of natural bacteria and fungi. Overwashing or using harsh soaps can actually make it worse.", topic: "yeast"),
            MythFact(id: "11", myth: "Stress doesn't affect your period.", fact: "Cortisol (the stress hormone) directly disrupts the hormones that regulate your cycle. High stress can delay, shorten, or even skip periods.", topic: "period"),
            MythFact(id: "12", myth: "Thyroid problems only affect older people.", fact: "Thyroid conditions like hypothyroidism can affect teenagers and young adults too, causing fatigue, weight changes, and irregular periods.", topic: "thyroid"),
            MythFact(id: "13", myth: "If your period is light, it means you're healthier.", fact: "Flow varies widely. Very light periods can sometimes indicate low estrogen or other hormonal issues. There's no 'better' flow — just yours.", topic: "period"),
        ]
    }

    func progressGardenStage() -> Int {
        let streak = getCurrentStreak()
        let completed = getCompletedDaysInLastSevenDays()
        if streak >= 7 || completed >= 7 { return 4 }
        if streak >= 5 || completed >= 5 { return 3 }
        if streak >= 3 || completed >= 2 { return 2 }
        if completed >= 1 { return 1 }
        return 0
    }

    struct GardenInfo {
        let stage: Int
        let stageName: String
        let progressFraction: Double
        let daysToNextStage: Int
        let streak: Int
        let completedDays: Int
        let isMaxStage: Bool
    }

    func progressGardenInfo() -> GardenInfo {
        let streak = getCurrentStreak()
        let completed = getCompletedDaysInLastSevenDays()
        let stage = progressGardenStage()

        let stageNames = ["Bare Soil", "Seed", "Sprout", "Plant", "Blooming Tree"]
        let stageName = stageNames[min(stage, stageNames.count - 1)]

        // Thresholds: streak OR completedDays needed to reach next stage
        // Stage 0→1: 1 completed, Stage 1→2: streak 3 or 2 days, Stage 2→3: streak 5 or 5 days, Stage 3→4: streak 7 or 7 days
        let stageStreakThresholds = [0, 1, 3, 5, 7]
        let stageDayThresholds   = [0, 1, 2, 5, 7]

        let isMaxStage = stage >= 4

        let progressFraction: Double
        let daysToNextStage: Int

        if isMaxStage {
            progressFraction = 1.0
            daysToNextStage = 0
        } else {
            let prevStreak = stageStreakThresholds[stage]
            let nextStreak = stageStreakThresholds[stage + 1]
            let prevDays   = stageDayThresholds[stage]
            let nextDays   = stageDayThresholds[stage + 1]

            // Progress via streak
            let streakProgress = nextStreak > prevStreak
                ? Double(streak - prevStreak) / Double(nextStreak - prevStreak)
                : 0.0
            // Progress via completed days
            let daysProgress = nextDays > prevDays
                ? Double(completed - prevDays) / Double(nextDays - prevDays)
                : 0.0

            progressFraction = min(max(streakProgress, daysProgress), 1.0)

            let daysNeededViaStreak = max(0, nextStreak - streak)
            let daysNeededViaDays   = max(0, nextDays - completed)
            daysToNextStage = min(daysNeededViaStreak, daysNeededViaDays)
        }

        return GardenInfo(
            stage: stage,
            stageName: stageName,
            progressFraction: progressFraction,
            daysToNextStage: daysToNextStage,
            streak: streak,
            completedDays: completed,
            isMaxStage: isMaxStage
        )
    }

    // MARK: - Playlist

    func getPlaylistItems() -> [PlaylistItem] {
        [
            PlaylistItem(id: "calm1", title: "Calm focus", subtitle: "When you need to slow down", urlString: "https://www.apple.com", group: "Calm"),
            PlaylistItem(id: "focus1", title: "Gentle energy", subtitle: "Light movement and breath", urlString: "https://www.apple.com", group: "Focus"),
            PlaylistItem(id: "energy1", title: "Morning lift", subtitle: "Start the day with clarity", urlString: "https://www.apple.com", group: "Energy"),
        ]
    }

    // MARK: - Period tracker

    private static let periodEntriesKey = "periodEntries"

    private func loadPeriodEntries() -> [PeriodEntry] {
        guard let data = UserDefaults.standard.data(forKey: Self.periodEntriesKey) else { return [] }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return (try? decoder.decode([PeriodEntry].self, from: data)) ?? []
    }

    private func savePeriodEntries(_ entries: [PeriodEntry]) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard let data = try? encoder.encode(entries) else { return }
        UserDefaults.standard.set(data, forKey: Self.periodEntriesKey)
    }

    func getPeriodEntries() -> [PeriodEntry] {
        loadPeriodEntries().sorted { $0.startDate > $1.startDate }
    }

    func addPeriodEntry(startDate: Date, flow: String) {
        var entries = loadPeriodEntries()
        let entry = PeriodEntry(id: UUID().uuidString, startDate: startDate, endDate: nil, flow: flow, notes: nil)
        entries.append(entry)
        savePeriodEntries(entries)
        objectWillChange.send()
    }

    func predictedNextPeriodStart() -> Date? {
        let entries = loadPeriodEntries().sorted { $0.startDate < $1.startDate }
        guard entries.count >= 2 else { return nil }
        let lastTwo = entries.suffix(2)
        let days = Calendar.current.dateComponents([.day], from: lastTwo.first!.startDate, to: lastTwo.last!.startDate).day ?? 28
        let cycleDays = max(21, min(35, abs(days)))
        return Calendar.current.date(byAdding: .day, value: cycleDays, to: entries.last!.startDate)
    }
}
