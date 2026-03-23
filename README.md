# Expense Splitter App

A full-stack mobile app to track and split shared expenses.

## Tech Stack
- **Frontend:** Flutter (Android)
- **Backend:** Node.js + Express.js
- **Database:** MongoDB Atlas

## Features
- Create groups with members
- Add expenses and split equally
- View balances (who owes whom)

## Setup

### Backend
cd backend
npm install
# Add your MongoDB URI to .env file
node server.js

### Frontend
cd frontend
flutter pub get
flutter run

## API Endpoints
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | /api/groups | Create a group |
| GET | /api/groups | Get all groups |
| POST | /api/expenses | Add an expense |
| GET | /api/expenses/:groupId | Get group expenses |
| GET | /api/expenses/:groupId/balances | Get balances |