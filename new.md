Start at the authentication flow. Need explicit fixes completed before moving to UI polish. Do not make silent assumptions or leave placeholder logic.

Tasks:

1. Fix authentication state
   - The auth flow is currently broken.
   - After signing in successfully, the navbar still displays "Sign In" even though the user is authenticated.
   - The upload page is accessible, but attempting to upload incorrectly reports that the user must sign in.
   - Audit the entire authentication flow and ensure there is a single source of truth for auth state.
   - Use the Supabase auth session correctly (I have already enabled Email/Password authentication and have already run the SQL migrations).
   - Ensure authentication state persists after refresh.
   - Ensure auth state updates immediately after sign in, sign up, and logout.

2. Fix signup flow
   - Verify that signing up creates the account correctly.
   - Once signup succeeds, automatically transition into the authenticated experience (or sign the user in if required).
   - Do not leave the user in an unauthenticated state after successful account creation.

3. Navbar authenticated state
   - When unauthenticated:
     - Show "Sign In".
   - When authenticated:
     - Replace "Home" with "Dashboard".
     - Replace the current auth button "Sign in" with a profile/avatar button.
   - The profile button should open a small dropdown/menu containing at minimum:
     - Dashboard
     - Profile
     - Logout
   - Logout should immediately update the navbar back to the unauthenticated state.

4. Upload permissions
   - Remove the inconsistency where the UI appears authenticated but uploads fail.
   - Uploading should work immediately after authentication.
   - Ensure upload permission checks use the real authenticated Supabase session instead of stale UI state.
   - Verify upload works after:
     - Sign in
     - Sign up
     - Refresh
     - Returning to the app later with a persisted session

5. Update storage limit everywhere
   - The UI currently says:
       "10 MB max"
   - This is incorrect.
   - Replace it with:
       "120 MB max"
   - Update every occurrence across the application.

6. Fix layout issue
   - On the upload screen, the "Account required" section is clipped by its parent container.
   - Adjust the layout so the full content is visible.
   - Check desktop, tablet, and mobile responsiveness.

7. Improve error messages
   - Current error messages are too small and look like mobile UI.
   - Redesign them so they:
     - occupy more horizontal space
     - use larger typography
     - have improved padding
     - are much easier to notice
     - remain responsive
   - Apply consistently throughout the application.

8. Auth form UX
   - Switching between:
     - Sign In
     - Sign Up
   - should completely clear every text field.
   - Also clear validation errors and loading states where appropriate.

9. Authentication audit
   - Review the complete auth implementation.
   - Remove duplicate auth logic.
   - Ensure every page derives authentication from the same provider/service.
   - Eliminate any stale state causing UI and backend authentication to disagree.

10. Final verification
   Verify all of the following:
   - Sign up works.
   - Sign in works.
   - Session persists.
   - Navbar updates immediately.
   - Dashboard button appears when authenticated.
   - Profile menu works.
   - Logout works.
   - Upload works while authenticated.
   - Upload is blocked only when actually unauthenticated.
   - All "10 MB" labels have been replaced with "120 MB".
   - "Account required" is fully visible.
   - Error messages use the improved design.
   - Switching between Sign In and Sign Up clears all form fields.

Do not stop after implementing individual fixes. Continue until the authentication flow, upload flow, and UI polish are fully integrated and functioning consistently across the application.