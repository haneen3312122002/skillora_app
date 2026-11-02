# Skillora – Freelance Marketplace Mobile App

Skillora is a role-based freelance marketplace mobile application built with **Flutter**, built as a production-style portfolio project.  
The app connects **Clients** and **Freelancers** through a structured and secure workflow, focusing on scalability, clean architecture, and secure session handling.

---
![Image 1](1.png)
![Image 2](2.png)
![Image 3](3.png)


## ✨ Features

### 👩‍💻 Freelancer
- Browse and filter available jobs by category
- Submit proposals to jobs
- Access **job-scoped private chat** after proposal acceptance
- Manage professional profile (bio, skills, projects)

### 🧑‍💼 Client
- Post and manage jobs
- Review submitted proposals
- Accept or reject proposals
- Automatically open private chat after acceptance
- View freelancer public profiles

### 🛡 Admin
- Manage users and roles
- Enable / disable user accounts
- Monitor general platform activity

---

## 🏗 Architecture

The project follows **Clean Architecture** with feature-based modularization:

**Presentation Layer**
- UI, Screens, Widgets, ViewModels
- Riverpod for state & streams
- No direct data source access

**Domain Layer**
- Business logic
- Entities, Use Cases, Failures
- Independent from Flutter & Firebase

**Data / Service Layer**
- Firebase (Auth, Firestore, Storage, FCM)
- Models & mappers

**Flow**

---

## 🔐 Security Highlights

- Role-Based Access Control (RBAC)
- Secure route protection per role
- Job-scoped chat isolation
- Full session reset on logout
- Protection against role UI leakage after account switching

---

## 🧪 Testing

- Manual functional testing for all core flows
- Security testing for session handling & role isolation
- Tested on real Firebase backend in Debug & Release modes

---

## 🛠 Tech Stack

- **Flutter & Dart**
- **Riverpod (State Management)**
- **Clean Architecture & MVVM**
- **Firebase (Auth, Firestore, Storage, FCM)**
- **GoRouter**
- Secure Coding Practices (OWASP awareness)

---

## 📌 Project Status

A production-style Flutter application built to practice Clean Architecture, RBAC and secure session handling.  
It reflects my growth in mobile development, architecture design, and secure coding practices.

---

## 👤 Author

**Haneen Ahmad Khanfar**  
Flutter Developer | Cybersecurity Background  
📍 Jordan  

🔗 GitHub: https://github.com/haneen3312122002
