# Network Connection Fix

## Issue Identified

The debug logs showed:
```
Connection refused (OS Error: Connection refused, errno = 111)
address = api.syroltech.com, port = 40786
```

This is a **network connectivity issue** - the app cannot reach the backend API.

## Fixes Applied

### 1. Added Internet Permissions
Added to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

### 2. Enabled Cleartext Traffic
Added `android:usesCleartextTraffic="true"` to the application tag (for development/testing).

### 3. Created Network Security Configuration
Created `android/app/src/main/res/xml/network_security_config.xml` to properly handle HTTPS connections.

## How to Test

### Step 1: Stop the App
Stop the currently running app completely.

### Step 2: Rebuild the App
Run these commands:
```bash
flutter clean
flutter pub get
flutter run
```

### Step 3: Test Login Again
1. Open the app
2. Navigate to login screen
3. Enter credentials:
   - Username: `superadmin@brantro.com`
   - Password: `1234`
4. Click "Login to Dashboard"
5. Check the console output

## Expected Output

If the fix works, you should see:
```
[ApiClient] Response status: 200
[ApiClient] Response data: {success: true, message: ..., payload: {...}}
[AuthRepository] Login response status: 200
[AuthRepository] Parsed login response - Success: true
[AuthRepository] User role: ADMIN
```

## Alternative Solutions (If Still Not Working)

### Solution 1: Check if Backend is Accessible
Test the API directly using curl or Postman:
```bash
curl -X POST https://api.syroltech.com/brantro/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -H "token: NlwvQOhvOgMARJ21Jfs1yLsG" \
  -d '{"username":"superadmin@brantro.com","password":"1234","authProvider":"INTERNAL"}'
```

### Solution 2: Use Android Emulator with Proxy
If you're behind a corporate firewall or proxy:
1. Open Android Studio
2. Go to AVD Manager
3. Edit your emulator
4. Show Advanced Settings
5. Set HTTP Proxy to "Manual proxy configuration"

### Solution 3: Test on Physical Device
If emulator has network issues:
1. Enable USB debugging on your Android phone
2. Connect via USB
3. Run: `flutter run`
4. Select your physical device

### Solution 4: Check Emulator Internet
Test if emulator has internet:
1. Open Chrome browser in the emulator
2. Try to visit https://google.com
3. If it doesn't work, restart the emulator

### Solution 5: Use 10.0.2.2 for Localhost
If your backend is running locally (not the case here, but for reference):
- Replace `localhost` with `10.0.2.2` in Android emulator
- This is the special IP that maps to your host machine's localhost

## Backend API Details

- **Base URL**: `https://api.syroltech.com/brantro`
- **Login Endpoint**: `/api/v1/auth/login`
- **Full URL**: `https://api.syroltech.com/brantro/api/v1/auth/login`
- **Method**: POST
- **Headers**:
  - `Content-Type: application/json`
  - `token: NlwvQOhvOgMARJ21Jfs1yLsG`
- **Body**:
  ```json
  {
    "username": "superadmin@brantro.com",
    "password": "1234",
    "authProvider": "INTERNAL"
  }
  ```

## Port 40786 Issue

The weird port (40786) suggests the emulator might be using a proxy or there's a network configuration issue. The fixes above should resolve this.

## Next Steps

1. **Rebuild the app** with `flutter clean` and `flutter run`
2. **Test login** and check console output
3. **If still failing**, try testing the API with curl/Postman to verify backend is accessible
4. **If backend is accessible**, try running on a physical device instead of emulator
