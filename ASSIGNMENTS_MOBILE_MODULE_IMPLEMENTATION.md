# Assignments/Homework Mobile Module Implementation

Date: 2026-03-01

## Overview

The mobile app now includes a complete Assignments/Homework module integrated with the backend assignment APIs.

Implemented capabilities:

- Assignment listing and detail summary
- Submission listing with status/score visibility
- Teacher/staff assignment creation
- Student submission/update workflow
- Teacher/staff grading workflow
- Assignment status management (Draft/Published/Closed)
- Submission regeneration trigger
- Role-based dashboard menu integration

## Files Added

- `lib/models/AssignmentModel.dart`
- `lib/models/AssignmentSubmissionModel.dart`
- `lib/models/AssignmentApi.dart`
- `lib/screens/assignments/AssignmentsHomeScreen.dart`

## Files Updated

- `lib/screens/full_app/section/SectionDashboard.dart`

## API Endpoints Used

- `GET /api/assignments`
- `GET /api/assignment-submissions`
- `POST /api/assignments`
- `POST /api/assignments/{id}/status`
- `POST /api/assignments/{id}/regenerate-submissions`
- `POST /api/assignment-submissions/{id}/submit`
- `POST /api/assignment-submissions/{id}/grade`

## UX and Behavior

## Dashboard Access

A new dashboard tile named **Assignments** opens the module screen.

Visibility condition:

- teacher, student, parent, admin, dos, hm roles

## Assignments Tab

Shows:

- title, status, type, target class/stream, due date, progress
- subject (when available)

Actions:

- Staff:
  - open submissions filtered by assignment
  - set status (Draft/Published/Closed)
  - regenerate submissions
  - create assignment (FAB)
- Non-staff:
  - submit/update own assignment submission when a submission record exists

## Submissions Tab

Shows:

- assignment title
- submission status
- score/max score
- submitted date
- class/stream
- feedback (if available)

Actions:

- Staff: grade/edit submission
- Non-staff: submit/update own submission

## Form Flows

## Create Assignment

Fields:

- title (required)
- class (required)
- subject (optional)
- type
- submission type
- max score / assessed toggle
- status
- marks visibility
- due date / issue date
- description / instructions

## Submit Assignment

- text submission
- optional image attachment from gallery

## Grade Submission

- status
- score
- feedback
- teacher comment

## Error Handling and Stability

- All API interactions use `RespondModel` and show user feedback via `Utils.toast`
- Network and API failures do not crash UI; user gets actionable message
- Refresh controls added for assignments/submissions re-sync
- Loading states shown for initial load and fetch actions
- Data parsing is defensive (`Utils.int_parse`, `Utils.to_str`, nullable numeric parsing)

## Verification Summary

Checks completed:

- Dart compile checks for all changed files: **no compile errors**
- Flutter analyze on changed module files: only non-blocking info-level lints remain (legacy naming/style conventions and existing dashboard file infos)

## Notes

- File attachment support currently uses image picker (gallery image attachment).
- The module follows existing app architecture (`Get`, `Utils`, `RespondModel`) for consistency.
