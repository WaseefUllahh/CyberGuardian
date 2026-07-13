import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../models/learning_models.dart';

class LearningContent {
  static final List<Course> allCourses = [
    _buildIntroCourse(),
    _buildPhishingCourse(),
    _buildPasswordCourse(),
    _buildSafeBrowsingCourse(),
  ];

  static Course _buildIntroCourse() {
    return Course(
      id: 'c_intro',
      title: 'Introduction to Cybersecurity',
      subtitle: 'Learn the fundamentals of keeping yourself safe in the digital world.',
      description: 'Cybersecurity is the practice of protecting systems, networks, and programs from digital attacks. This course covers basic concepts, terminology, and essential habits to build your foundation in digital safety.',
      icon: PhosphorIcons.shieldCheck(),
      difficulty: 'Beginner',
      durationMinutes: 45,
      xpReward: 200,
      skills: ['Security Fundamentals', 'Threat Recognition', 'Basic Cyber Hygiene'],
      requirements: ['No prior knowledge required', 'Internet connection'],
      objectives: [
        'Understand what cybersecurity is and why it matters',
        'Learn to identify common threats',
        'Establish basic habits for online safety',
      ],
      lessons: [
        Lesson(
          id: 'l_intro_1',
          title: 'What is Cybersecurity?',
          readingTimeMinutes: 5,
          youtubeVideoId: 'inWWhr5tnEA', // Placeholder educational video ID (e.g. Cisco/IBM)
          content: [
            LessonSection(type: SectionType.heading, content: 'The Digital Battlefield'),
            LessonSection(type: SectionType.text, content: 'Cybersecurity is the practice of protecting systems, networks, and programs from digital attacks. These cyberattacks are usually aimed at accessing, changing, or destroying sensitive information; extorting money from users; or interrupting normal business processes.'),
            LessonSection(type: SectionType.tip, content: 'Think of cybersecurity as the locks on your doors, but for your digital life.'),
            LessonSection(type: SectionType.heading, content: 'Core Concepts (CIA Triad)'),
            LessonSection(type: SectionType.bullet, content: 'Confidentiality: Ensuring data is kept secret from unauthorized individuals.'),
            LessonSection(type: SectionType.bullet, content: 'Integrity: Ensuring data has not been altered maliciously or accidentally.'),
            LessonSection(type: SectionType.bullet, content: 'Availability: Ensuring data is available to authorized users when needed.'),
            LessonSection(type: SectionType.warning, content: 'Cybercriminals exploit weaknesses in any of these three pillars to compromise your data.'),
          ],
        ),
        Lesson(
          id: 'l_intro_2',
          title: 'Common Threat Types',
          readingTimeMinutes: 7,
          youtubeVideoId: 'yr8iHq7zDkE',
          content: [
            LessonSection(type: SectionType.heading, content: 'Know Your Enemy'),
            LessonSection(type: SectionType.text, content: 'To defend yourself, you must know what you are defending against. Threats come in many forms, each designed to trick you or exploit software vulnerabilities.'),
            LessonSection(type: SectionType.bullet, content: 'Malware: Malicious software designed to cause damage to a computer, server, client, or network (e.g., viruses, worms).'),
            LessonSection(type: SectionType.bullet, content: 'Phishing: Social engineering attacks where criminals impersonate legitimate organizations via email or text.'),
            LessonSection(type: SectionType.bullet, content: 'Ransomware: A type of malware that locks your data and demands payment to release it.'),
            LessonSection(type: SectionType.tip, content: 'The vast majority of attacks rely on human error—like clicking a bad link—rather than hacking into a system directly.'),
          ],
        ),
        Lesson(
          id: 'l_intro_3',
          title: 'Your Role in Defense',
          readingTimeMinutes: 4,
          youtubeVideoId: 'bPVaOlJ6ln0',
          content: [
            LessonSection(type: SectionType.heading, content: 'The Human Firewall'),
            LessonSection(type: SectionType.text, content: 'No matter how many antivirus programs you have, you are the ultimate defense. Security software cannot stop you from handing over your password voluntarily.'),
            LessonSection(type: SectionType.bullet, content: 'Always verify unexpected requests for sensitive data.'),
            LessonSection(type: SectionType.bullet, content: 'Keep your software and operating systems updated.'),
            LessonSection(type: SectionType.bullet, content: 'Use a password manager to handle complex credentials.'),
            LessonSection(type: SectionType.text, content: 'Cyber hygiene is just like physical hygiene: doing small, daily tasks (like brushing your teeth) prevents massive problems down the line.'),
          ],
        ),
      ],
      quizzes: [
        Quiz(
          id: 'q_intro',
          title: 'Cybersecurity Basics Quiz',
          xpReward: 100,
          passPercentage: 80,
          questions: [
            Question(
              text: 'What does the CIA triad stand for in cybersecurity?',
              options: [
                'Central Intelligence Agency',
                'Confidentiality, Integrity, Availability',
                'Cybersecurity, Information, Access',
                'Control, Identification, Authentication'
              ],
              correctIndex: 1,
              explanation: 'The CIA triad (Confidentiality, Integrity, Availability) is a model designed to guide policies for information security.',
            ),
            Question(
              text: 'Which of the following is considered malware?',
              options: ['A VPN application', 'A password manager', 'Ransomware', 'A web browser'],
              correctIndex: 2,
              explanation: 'Ransomware is malicious software designed to block access to a computer system until a sum of money is paid.',
            ),
            Question(
              text: 'Who is the ultimate line of defense against cyber threats?',
              options: ['The antivirus software', 'The internet service provider', 'The government', 'You (the user)'],
              correctIndex: 3,
              explanation: 'You are the human firewall. Most attacks rely on manipulating the user to bypass technical defenses.',
            ),
          ],
        )
      ],
      resources: [
        Resource(title: 'NIST Cybersecurity Framework', url: 'https://www.nist.gov/cyberframework'),
        Resource(title: 'CISA Security Tips', url: 'https://www.cisa.gov/tips'),
      ],
    );
  }

  static Course _buildPhishingCourse() {
    return Course(
      id: 'c_phishing',
      title: 'Phishing Awareness',
      subtitle: 'Identify and avoid deceptive emails, texts, and websites.',
      description: 'Phishing remains the #1 way attackers gain unauthorized access to accounts. In this course, you will learn to spot the psychological tricks hackers use, analyze deceptive URLs, and safely handle suspicious messages.',
      icon: PhosphorIcons.fishSimple(),
      difficulty: 'Beginner',
      durationMinutes: 60,
      xpReward: 250,
      skills: ['Email Analysis', 'Link Inspection', 'Social Engineering Resistance'],
      requirements: ['Basic email knowledge'],
      objectives: [
        'Recognize the red flags of a phishing attempt',
        'Differentiate between legitimate and fake URLs',
        'Learn what to do if you accidentally click a phishing link',
      ],
      lessons: [
        Lesson(
          id: 'l_phish_1',
          title: 'The Psychology of Phishing',
          readingTimeMinutes: 5,
          youtubeVideoId: 'Y7zNIGMELQ4',
          content: [
            LessonSection(type: SectionType.heading, content: 'Hacking the Human Mind'),
            LessonSection(type: SectionType.text, content: 'Phishing doesn\'t rely on technical genius; it relies on psychology. Attackers want you to act quickly without thinking.'),
            LessonSection(type: SectionType.bullet, content: 'Urgency: "Your account will be suspended in 24 hours!"'),
            LessonSection(type: SectionType.bullet, content: 'Fear: "We detected a login attempt from Russia."'),
            LessonSection(type: SectionType.bullet, content: 'Greed: "You have won a free iPhone!"'),
            LessonSection(type: SectionType.bullet, content: 'Curiosity: "Check out this embarrassing photo of you."'),
            LessonSection(type: SectionType.tip, content: 'If a message invokes a strong emotion and asks you to click a link or download a file, pause. That is exactly what the attacker wants.'),
          ],
        ),
        Lesson(
          id: 'l_phish_2',
          title: 'Anatomy of a Fake Email',
          readingTimeMinutes: 8,
          youtubeVideoId: '8l4-8I3vJ9w',
          content: [
            LessonSection(type: SectionType.heading, content: 'Spotting the Fakes'),
            LessonSection(type: SectionType.text, content: 'Attackers are getting better at mimicking real brands, but they always leave clues.'),
            LessonSection(type: SectionType.warning, content: 'Check the sender address carefully. The display name might say "PayPal Support", but the email address might be "security-update@paypal-verify-account.com".'),
            LessonSection(type: SectionType.text, content: 'Real organizations rarely ask for sensitive information (passwords, SSNs) directly via email.'),
            LessonSection(type: SectionType.bullet, content: 'Generic greetings like "Dear Customer" instead of your real name.'),
            LessonSection(type: SectionType.bullet, content: 'Slight typos or poor grammar (though this is becoming less common with AI).'),
            LessonSection(type: SectionType.bullet, content: 'Hover over links before clicking. Ensure the domain exactly matches the official website (e.g., paypal.com vs paypal.com.update-info.net).'),
          ],
        ),
      ],
      quizzes: [
        Quiz(
          id: 'q_phish',
          title: 'Phishing Identification Test',
          xpReward: 120,
          questions: [
            Question(
              text: 'Which of the following is a major red flag in an email?',
              options: ['A sense of extreme urgency to act now', 'A link to a privacy policy', 'Your full name used in the greeting', 'An offer for a minor discount'],
              correctIndex: 0,
              explanation: 'Creating a sense of urgency (e.g., "account suspension") forces users to act hastily without verifying the sender.',
            ),
            Question(
              text: 'You receive an email that looks like it is from Netflix, asking you to update your billing info. What should you do?',
              options: ['Click the link in the email and update your info', 'Reply to the email with your credit card details', 'Delete the email and log into Netflix directly from your browser', 'Forward the email to all your contacts'],
              correctIndex: 2,
              explanation: 'Never click links in unexpected emails. Always go directly to the official website by typing the address into your browser.',
            ),
          ],
        )
      ],
      resources: [
        Resource(title: 'Google Phishing Quiz', url: 'https://phishingquiz.withgoogle.com/'),
      ],
    );
  }

  static Course _buildPasswordCourse() {
    return Course(
      id: 'c_password',
      title: 'Password Security',
      subtitle: 'Master the art of creating uncrackable credentials.',
      description: 'Your password is the key to your digital life. Weak passwords are the root cause of millions of compromised accounts. Learn how to create strong passwords, utilize password managers, and implement Multi-Factor Authentication (MFA).',
      icon: PhosphorIcons.key(),
      difficulty: 'Beginner',
      durationMinutes: 40,
      xpReward: 200,
      skills: ['Credential Management', 'MFA Implementation', 'Password Strength Analysis'],
      requirements: ['None'],
      objectives: [
        'Understand how attackers crack passwords',
        'Learn the difference between a password and a passphrase',
        'Set up a password manager and MFA',
      ],
      lessons: [
        Lesson(
          id: 'l_pass_1',
          title: 'How Passwords Get Cracked',
          readingTimeMinutes: 5,
          youtubeVideoId: '3njO3P22wV8',
          content: [
            LessonSection(type: SectionType.heading, content: 'Brute Force & Dictionary Attacks'),
            LessonSection(type: SectionType.text, content: 'Hackers do not guess passwords manually. They use automated software capable of guessing billions of passwords per second.'),
            LessonSection(type: SectionType.bullet, content: 'Dictionary Attack: The software tries every word in the dictionary, including common substitutions (e.g., P@ssw0rd).'),
            LessonSection(type: SectionType.bullet, content: 'Credential Stuffing: Attackers take passwords leaked in a previous breach (e.g., Yahoo) and try them on other sites (e.g., Netflix).'),
            LessonSection(type: SectionType.warning, content: 'If you reuse the same password across multiple sites, a breach on one site compromises all of them.'),
          ],
        ),
        Lesson(
          id: 'l_pass_2',
          title: 'The Power of Passphrases',
          readingTimeMinutes: 4,
          youtubeVideoId: 'U_P23SqXaC8',
          content: [
            LessonSection(type: SectionType.heading, content: 'Length > Complexity'),
            LessonSection(type: SectionType.text, content: 'A password like "Tr0ub4dor&3" is hard for a human to remember, but easy for a computer to crack. A passphrase like "correct horse battery staple" is easy for a human to remember, but incredibly hard for a computer to crack due to its length.'),
            LessonSection(type: SectionType.tip, content: 'Aim for at least 14 characters. Stringing 4 random words together is a highly effective strategy.'),
          ],
        ),
        Lesson(
          id: 'l_pass_3',
          title: 'Password Managers & MFA',
          readingTimeMinutes: 6,
          youtubeVideoId: 'vC3I8Tebp6k',
          content: [
            LessonSection(type: SectionType.heading, content: 'Your Digital Vault'),
            LessonSection(type: SectionType.text, content: 'You should have a unique, long, random password for every single account. Since human brains cannot remember 100 random passwords, you need a Password Manager (e.g., Bitwarden, 1Password, Google Password Manager).'),
            LessonSection(type: SectionType.heading, content: 'Multi-Factor Authentication (MFA)'),
            LessonSection(type: SectionType.text, content: 'MFA requires a second piece of evidence (like a code from your phone) besides your password. Even if a hacker steals your password, they cannot log in without your physical device.'),
            LessonSection(type: SectionType.tip, content: 'Always enable MFA on your email, banking, and social media accounts. Use an Authenticator App instead of SMS text messages when possible.'),
          ],
        ),
      ],
      quizzes: [
        Quiz(
          id: 'q_pass',
          title: 'Credential Security Quiz',
          xpReward: 100,
          questions: [
            Question(
              text: 'Why is password reuse dangerous?',
              options: ['It slows down your computer', 'If one site is breached, hackers can access your other accounts', 'It takes too long to type', 'It confuses password managers'],
              correctIndex: 1,
              explanation: 'Credential stuffing is a common attack where hackers use leaked passwords from one site to break into your other accounts.',
            ),
            Question(
              text: 'Which is the most secure password?',
              options: ['P@ssw0rd123!', 'PurpleMonkeyDishwasher', 'JohnSmith1990', 'admin123'],
              correctIndex: 1,
              explanation: 'Length is the most important factor in password strength. "PurpleMonkeyDishwasher" is a long passphrase and the hardest for a computer to crack.',
            ),
          ],
        )
      ],
      resources: [
        Resource(title: 'HaveIBeenPwned', url: 'https://haveibeenpwned.com/'),
      ],
    );
  }

  static Course _buildSafeBrowsingCourse() {
    return Course(
      id: 'c_browsing',
      title: 'Safe Browsing',
      subtitle: 'Navigate the web securely and privately.',
      description: 'The internet is filled with malicious websites, invasive trackers, and drive-by downloads. Learn how to secure your browser, identify secure connections, and maintain your digital privacy.',
      icon: PhosphorIcons.globe(),
      difficulty: 'Intermediate',
      durationMinutes: 50,
      xpReward: 220,
      skills: ['Browser Security', 'Privacy Protection', 'URL Analysis'],
      requirements: ['Basic internet usage'],
      objectives: [
        'Understand HTTPS and encryption',
        'Learn how to manage cookies and trackers',
        'Identify malicious downloads and websites',
      ],
      lessons: [
        Lesson(
          id: 'l_browse_1',
          title: 'HTTPS and Secure Connections',
          readingTimeMinutes: 5,
          youtubeVideoId: 'hExRDVZHhig',
          content: [
            LessonSection(type: SectionType.heading, content: 'The Padlock Icon'),
            LessonSection(type: SectionType.text, content: 'HTTPS ensures that the communication between your browser and the website is encrypted. This means anyone intercepting the traffic (like someone on the same public Wi-Fi) cannot see what you are doing (e.g., viewing your passwords).'),
            LessonSection(type: SectionType.warning, content: 'A padlock icon only means the connection is secure. It does NOT mean the website is safe. Phishers use HTTPS too!'),
          ],
        ),
        Lesson(
          id: 'l_browse_2',
          title: 'Public Wi-Fi Risks',
          readingTimeMinutes: 6,
          youtubeVideoId: 'k7Bv6_V82wA',
          content: [
            LessonSection(type: SectionType.heading, content: 'The Coffee Shop Danger'),
            LessonSection(type: SectionType.text, content: 'Public Wi-Fi networks (airports, cafes, hotels) are inherently insecure. Attackers on the same network can potentially intercept your data.'),
            LessonSection(type: SectionType.bullet, content: 'Never log into banking or sensitive accounts on public Wi-Fi without a VPN.'),
            LessonSection(type: SectionType.bullet, content: 'Use a Virtual Private Network (VPN) to encrypt all your internet traffic.'),
            LessonSection(type: SectionType.tip, content: 'If you do not have a VPN, use your phone\'s cellular hotspot instead of public Wi-Fi.'),
          ],
        ),
      ],
      quizzes: [
        Quiz(
          id: 'q_browse',
          title: 'Safe Browsing Quiz',
          xpReward: 100,
          questions: [
            Question(
              text: 'What does the padlock icon next to a website URL signify?',
              options: ['The website is 100% safe and trustworthy', 'The connection to the website is encrypted', 'The website has no viruses', 'The website belongs to a verified company'],
              correctIndex: 1,
              explanation: 'The padlock indicates HTTPS encryption. It protects data in transit, but malicious sites can also use HTTPS.',
            ),
            Question(
              text: 'What is the best way to secure your connection on public Wi-Fi?',
              options: ['Turn on Incognito mode', 'Use a Virtual Private Network (VPN)', 'Clear your browser cache', 'Turn down your screen brightness'],
              correctIndex: 1,
              explanation: 'A VPN creates a secure, encrypted tunnel for your internet traffic, protecting it from others on the same public network.',
            ),
          ],
        )
      ],
      resources: [
        Resource(title: 'EFF Privacy Badger', url: 'https://privacybadger.org/'),
      ],
    );
  }
}
