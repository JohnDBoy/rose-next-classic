# Gemini Session Startup Checklist

Use this checklist every time you start a new Gemini Code Assist session.

---

## 🔹 Step 1: Prepare VS Code Workspace

- [ ] Open **rose-next-classic** project in Visual Studio Code.
- [ ] Ensure the `/gemini` folder is visible in the Explorer panel.
- [ ] Open these files in editor tabs:
  - `gemini_prompt.md`  *(Behavior control)*
  - `gemini_boot.md`  *(Startup sequence)*

---

## 🔹 Step 2: Initiate Gemini Agent Mode (if available)

- [ ] Open **Gemini Code Assist** from sidebar or command palette.
- [ ] Start **Agent Mode** *(if available)*.
- [ ] If Agent Mode is not available, use **inline chat mode**.

---

## 🔹 Step 3: Load Initialization Prompt (Manual Trigger)

Paste this into Gemini to load your context:

```
Gemini, begin by reading and following `gemini/gemini_boot.md`. Load the files in the order specified. After loading is complete, wait for my confirmation before continuing with any tasks.
```

---

## 🔹 Step 4: Confirm Behavior and Token Rules Are Active

Ensure Gemini confirms:

- [ ] Behavior is governed by `gemini_prompt.md`.
- [ ] Token Efficiency Protocol is active:
  - One step at a time.
  - No summaries after each step.
  - Logs progress in `gemini_memory.md` and `gemini_gameplan.md`.
- [ ] Final summary will be provided only after all steps are complete.

---

## 🔹 Step 5: Start Work Session

- [ ] Clearly define the first task (e.g., “Begin cleaning gemini_files.md”).
- [ ] Wait for Gemini to complete **only step 1**, then say **“Continue”** to proceed.
- [ ] Repeat until task is finished.

---

## 🔹 End of Session Tasks (Optional)

- [ ] Request final summary from Gemini.
- [ ] Confirm summary is logged in:
  - `gemini_memory.md`
  - `gemini_gameplan.md`
- [ ] Save and commit all updated `gemini_*.md` files to Git.

---

_Last Updated: 2025-08-05_  
_Maintainer: Gemini / Developer JDoeBoy  
_File Version: 1.0_
