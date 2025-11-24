# Expense Tracker App
### Track Your Income and Expenses with Ease - iOS App with Firebase Integration

## About This Project

The **Expense Tracker App** is a native iOS application built with SwiftUI that helps users manage their personal finances efficiently. Users can securely create accounts, log transactions, and monitor their spending habits with real-time data synchronization through Firebase.

This project was developed as part of the **iOS App Development 1** course at LaSalle College, demonstrating proficiency in SwiftUI, Firebase integration, MVVM architecture, and mobile app development best practices.

## Features

- **Secure Authentication** - User registration and login with Firebase Authentication
- **Dashboard with Balance Overview** - Real-time balance calculated from all transactions with income and expense totals
- **Add Transactions** - Record income and expenses with custom categories and notes
- **Edit Transactions** - Update transaction details with ease
- **Swipe to Delete** - Quickly remove unwanted transactions with a swipe gesture
- **Category Filtering** - Filter transactions by category directly on the dashboard
- **Summary Analytics** - View detailed breakdowns of expenses and income by category with percentages
- **Time Period Filters** - Analyze spending by All Time, This Month, Last Month, or This Year
- **User Profile** - Manage account settings and logout functionality
- **Bottom Navigation** - Easy access to Dashboard, Summary, and Profile screens
- **Dynamic Categories** - Different categories for income (Salary, Return of Investments) and expenses (Rent, Transport, Food, Entertainment, Shopping, Bills)

## Screenshots

### Authentication
| Login Screen | Register Screen |
|--------------|-----------------|
| ![Login](Expense%20Tracker%20App/Screenshots/login.png) | ![Register](Expense%20Tracker%20App/Screenshots/register.png) |

### Main Features
| Dashboard | Add Transaction | Summary Analytics |
|-----------|----------------|------------------|
| ![Dashboard](Expense%20Tracker%20App/Screenshots/dashboard.png) | ![Add](Expense%20Tracker%20App/Screenshots/add-transaction.png) | ![Summary](Expense%20Tracker%20App/Screenshots/summary.png) |

### Transaction Management
| Edit Transaction | Delete Transaction | User Profile |
|-----------------|-------------------|--------------|
| ![Edit](Expense%20Tracker%20App/Screenshots/edit-transaction.png) | ![Delete](Expense%20Tracker%20App/Screenshots/delete-swipe.png) | ![Profile](Expense%20Tracker%20App/Screenshots/profile.png) |

## Technologies Used

- **Language:** Swift
- **Framework:** SwiftUI
- **Backend:** Firebase
  - Firebase Authentication
  - Firebase Firestore
  - Firebase Core
- **Development Environment:** Xcode 26.0.1

## Installation

### Prerequisites
- macOS with Xcode 26.0.1 or later
- Firebase account

### Setup Instructions

1. **Clone the repository**
```bash
git clone https://github.com/Rafat-i/Expense-Tracker-App.git
cd Expense-Tracker-App
```

2. **Open in Xcode**
```bash
open "Expense Tracker App.xcodeproj"
```

3. **Configure Firebase**
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Add an iOS app to your Firebase project
   - Download `GoogleService-Info.plist`
   - Add the file to your Xcode project

4. **Install Dependencies**
   - Firebase libraries are already configured in the project
   - Ensure you have:
     - FirebaseAuth
     - FirebaseFirestore
     - FirebaseCore

5. **Build and Run**
   - Select your target device/simulator
   - Press `Cmd + R` or click the Run button

## Usage

### For End Users

1. **Create an Account**
   - Open the app
   - Tap "Sign Up" tab
   - Enter email, password, and username
   - Tap "Sign Up" to create your account

2. **Add a Transaction**
   - Login to your account
   - Tap the blue "+" button on the dashboard
   - Enter amount, select type (Income/Expense)
   - Choose a category
   - Select a date
   - Add an optional note
   - Tap "Save Transaction"

3. **View Your Balance**
   - Dashboard displays your current balance
   - See total income and expenses at a glance
   - Filter by category using the horizontal scroll menu

4. **Manage Transactions**
   - Tap a transaction to edit it
   - Swipe left to delete a transaction
   - Changes sync automatically with Firebase

5. **View Summary Analytics**
   - Tap "Summary" in the bottom navigation
   - Select time period (All Time, This Month, Last Month, This Year)
   - View expenses and income breakdown by category
   - See percentage distributions and average transaction amounts

6. **Manage Profile**
   - Tap "Profile" in the bottom navigation
   - View your account information
   - Tap "Logout" to sign out

## Team Contributions

This project was developed by:

- **Rafat & Kevin**
  - Firebase setup and integration
  - Authentication system (login/register)
  - Transaction CRUD operations
  - Dashboard with real-time data and category filtering
  - Summary view with analytics
  - Profile view with logout
  - Bottom navigation implementation
  - UI/UX design and implementation
  - Swipe-to-delete functionality

## Project Structure
```
Expense Tracker App/
├── Models/
│   ├── UserModel.swift                # User data model
│   └── TransactionModel.swift         # Transaction data model
├── Services/
│   ├── AuthService.swift              # Authentication logic
│   └── TransactionService.swift       # Transaction CRUD operations
├── Views/
│   ├── AuthGate.swift                 # Login/Register toggle
│   ├── LoginView.swift                # Login screen
│   ├── RegisterView.swift             # Registration screen
│   ├── DashboardView.swift            # Main dashboard with transaction list
│   ├── AddTransactionView.swift       # Add transaction form
│   ├── UpdateTransactionView.swift    # Edit transaction form
│   ├── SummaryView.swift              # Analytics and summary statistics
│   └── ProfileView.swift              # User profile and logout
├── Validators.swift                   # Input validation and SimpleError struct
└── ContentView.swift                  # Root view with tab navigation
```

## What I Learned

Through this project, I gained experience in:
- Building iOS apps with SwiftUI
- Integrating Firebase for backend services
- Working with Firestore for real-time data synchronization
- Handling user authentication and data security
- Implementing swipe gestures and List interactions
- Creating data visualizations and analytics
- Managing navigation with custom tab bars

## Future Enhancements

- Budget tracking and alerts
- Export transactions to CSV
- Dark mode support
- Recurring transactions
- Multi-currency support
- Offline mode with local caching

## License

This project was created for educational purposes as part of the iOS App Development 1 course.
