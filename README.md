# 🌌 Luminous Ledger - Financial Nebula

A premium, glassmorphic financial management application designed for visual excellence and atomic data integrity. **Luminous Ledger** transforms the mundane task of tracking expenses into a world-class ambient experience.

## ✨ Premium Features
- **💎 Fluid Visual Experience**: Powered by the "Financial Nebula" design system, featuring advanced glassmorphism, mesh gradients, and curated Manrope/Inter typography.
- **🏦 Multi-Wallet Intelligence**: Manage and switch between multiple funding sources (Cash, Card, Savings) with real-time balance calculations.
- **✍️ Atomic Transaction Management**: Seamlessly add, edit, or delete transactions. The engine ensures balance integrity across all wallets using robust revert-and-apply logic.
- **📊 Intuitive Spending Analysis**: Interactive donut charts and time-series trend analysis (Weekly/Monthly) powered by `fl_chart`.
- **🇻🇳 Multi-Language Support**: Complete localization for English (US) and Vietnamese (VN) to support global financial journeys.
- **☁️ Cloud-Backed Data**: Persistent storage and authentication through **Supabase** (PostgreSQL), so your ledgers stay consistent across devices when you are signed in.

## 🎨 Design Philosophy
Luminous Ledger prioritizes **Visual Excellence**. Avoid generic colors and boring lists. The app uses:
- **Ambient Glows**: Soft radial gradients that react to financial health.
- **Premium Mesh Gradients**: Deep, high-contrast backgrounds for readability.
- **No-Boundary Layouts**: Modern, fluid interfaces without unnecessary lines or borders.

## 🛠️ Technology Stack
- **Framework**: [Flutter](https://flutter.dev)
- **State Management**: [GetX](https://pub.dev/packages/get)
- **Backend & Auth**: [Supabase Flutter](https://pub.dev/packages/supabase_flutter)
- **Charts**: [fl_chart](https://pub.dev/packages/fl_chart)
- **Calendar**: [table_calendar](https://pub.dev/packages/table_calendar)
- **HTTP**: [dio](https://pub.dev/packages/dio) (e.g. in-app update metadata)
- **Configuration**: [flutter_dotenv](https://pub.dev/packages/flutter_dotenv)
- **Fonts**: [Google Fonts (Manrope, Inter)](https://fonts.google.com/)

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest stable)
- Dart SDK
- A [Supabase](https://supabase.com/) project with tables and auth configured for this app
- A root `.env` file (not committed) with at least:
  - `SUPABASE_URL`
  - `SUPABASE_ANON_KEY`
  - Optional: `UPDATE_METADATA_URL` for custom update checks

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/trieu-dev/luminous_ledger.git
   ```
2. Add your `.env` in the project root with the variables above.
3. Fetch dependencies:
   ```bash
   flutter pub get
   ```
4. Run the application:
   ```bash
   flutter run
   ```

---

## 📈 Roadmap
- [ ] 🎯 **Monthly Budgeting & Targets**: Visual progress rings for category spending.
- [ ] 🤖 **Smart Insights**: AI-style descriptive spending feedback.
- [ ] 🔒 **Biometric Security**: FaceID/Fingerprint protection.
- [ ] 🗓️ **Recurring Bills Manager**: Automatic subscription tracking.

Developed with ❤️ by the **Luminous Design Team**.
