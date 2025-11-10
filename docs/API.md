# API Documentation

## Overview

The 8Club application communicates with a remote API to fetch experience data. This document outlines the API structure and integration.

## Base Configuration

- **Environment Variable**: `API_BASE_URL` (defined in `.env`)
- **HTTP Client**: `http` package
- **Service Layer**: `HttpService` wrapper

## API Endpoints

### Get Experiences

**Endpoint**: `GET /experiences` (or similar, based on your API)

**Purpose**: Fetch available experience types for selection

**Request**:
```http
GET {API_BASE_URL}/experiences
Headers:
  Content-Type: application/json
  Authorization: Bearer {API_KEY} (if required)
```

**Response**:
```json
[
  {
    "id": 1,
    "name": "Adventure",
    "description": "Thrilling adventure experiences",
    "icon": "https://example.com/icons/adventure.png"
  },
  {
    "id": 2,
    "name": "Food & Dining",
    "description": "Culinary experiences",
    "icon": "https://example.com/icons/food.png"
  }
  // ... more experiences
]
```

**Model**: `ExperienceModel`
- Maps to `Experience` entity
- Used in `ExperiencesRemoteDataSource`

## Data Flow

```
UI (Screen)
    ↓
BLoC (ExperiencesBloc)
    ↓
Use Case (GetExperiences)
    ↓
Repository (ExperiencesRepository)
    ↓
Data Source (ExperiencesRemoteDataSource)
    ↓
HTTP Service (HttpService)
    ↓
API
```

## Error Handling

### Network Errors

- **No Internet**: Handled by `ConnectivityBloc`
- **Timeout**: Handled in `HttpService`
- **Server Error**: Handled in data source layer

### Error States

- `ExperiencesError`: Displayed in UI
- User-friendly error messages
- Retry functionality available

## Data Models

### Experience Model

**Location**: `lib/features/experiences/data/models/experience_model.dart`

**Fields**:
- `id`: Unique identifier (int)
- `name`: Experience name (String)
- `description`: Experience description (String)
- `icon`: Icon URL (String)

**Serialization**: Uses `json_serializable` for JSON parsing

## Future API Endpoints

### Submit Experiences

**Endpoint**: `POST /experiences/submit`

**Purpose**: Submit selected experiences and note

**Request Body**:
```json
{
  "selectedIds": [1, 2, 3],
  "note": "User's note about perfect hotspot"
}
```

### Submit Onboarding Response

**Endpoint**: `POST /onboarding/submit`

**Purpose**: Submit onboarding question response

**Request Body**:
```json
{
  "question": "Why do you want to host with us?",
  "answer": "User's text answer",
  "audioUrl": "https://...", // if audio provided
  "videoUrl": "https://..."  // if video provided
}
```

**Note**: These endpoints are placeholders for future implementation.

## Authentication

Currently, the API may not require authentication. If authentication is needed:

1. Add token storage in `LocalStorageService`
2. Update `HttpService` to include auth headers
3. Implement token refresh logic if needed

## Testing API Integration

### Mock Data

For development/testing, you can:
1. Use mock data in `ExperiencesRemoteDataSource`
2. Create a mock API server
3. Use tools like Postman for testing

### Example Mock Response

```dart
// In ExperiencesRemoteDataSourceImpl
final mockExperiences = [
  ExperienceModel(
    id: 1,
    name: 'Adventure',
    description: 'Thrilling experiences',
    icon: 'https://example.com/icon.png',
  ),
  // ... more experiences
];
```

## Environment Variables

Required in `.env`:

```env
API_BASE_URL=https://api.example.com
API_KEY=your-api-key (if required)
```

## Network Monitoring

The app includes `ConnectivityBloc` to monitor network status:
- Shows snackbar when connection is lost
- Automatically detects connection restoration
- App-wide connectivity state management

