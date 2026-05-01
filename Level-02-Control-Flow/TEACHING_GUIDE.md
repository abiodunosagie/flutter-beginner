# Teaching Guide: Level 2 (Control Flow)

This guide is for **you, the teacher**. It is not for the students. Read this once before recording each video, then teach from your own voice, not from the script.

The goal is simple: by the end of Level 2 your students should be able to **make a program decide things** and **make a program repeat things**. Everything else is detail.

---

## The Mental Model You Need to Hold

Programs run top to bottom. That is the default. Control flow is what we use to change that default.

There are only two ways to change it:

1. **Branching**, which is choosing one path out of many. This is `if`, `else`, and `switch`.
2. **Looping**, which is repeating the same code multiple times. This is `for`, `while`, and `do-while`.

That is the whole level. If a student leaves with those two ideas locked in, you have done your job.

---

## How To Teach Each Topic (In Order)

### Topic 1: If Statements (40 min video)

**Open with a question, not code:**
"How do you decide what to wear in the morning?"
Let students answer. Steer them: "You check the weather. If it is raining, you take an umbrella. If it is hot, you wear shorts. That is exactly what an `if` statement does."

**Then show the syntax**, but only the simple form first:

```dart
if (condition) {
  // do this
}
```

Stop. Make sure they understand:
- The thing in `()` must be a boolean (true or false). Refer back to Level 1 booleans.
- The code in `{}` only runs if the condition is true.

**Only after they get that**, add `else`. Then `else if`. Do not show all three at once. It overwhelms.

**Live demo**, type this in front of them:

```dart
void main() {
  int age = 20;

  if (age >= 18) {
    print('You can vote');
  } else {
    print('Too young to vote');
  }
}
```

Now change `age` to `15` and run again. Show them the output flips. This single demo teaches more than ten slides.

**Things students will ask:**
- *"Why double `=` in `==`?"* Single `=` assigns. Double `==` compares. Do not skip this. Write both on screen.
- *"What if I have many conditions?"* Show `else if` chain.
- *"Can I check two things at once?"* Now introduce `&&` and `||`.
- *"What is the `?` thing?"* That is the ternary. Save it for the end. It confuses beginners.

**End the video with a Flutter teaser**, one line:
"In Flutter, every screen is full of `if` statements. If the user is logged in, show the dashboard. If the cart has items, show the checkout button. You will use this every day."

---

### Topic 2: Switch Statements (20 min video)

This is where most students get lazy. They think `if-else` works fine, so why learn switch? You must answer that question in the first 60 seconds.

**Open with a comparison, not theory:**

Show this on screen:

```dart
if (day == 'Monday') print('Start');
else if (day == 'Tuesday') print('Day 2');
else if (day == 'Wednesday') print('Day 3');
else if (day == 'Thursday') print('Day 4');
else if (day == 'Friday') print('TGIF');
else if (day == 'Saturday') print('Weekend');
else if (day == 'Sunday') print('Weekend');
```

Say: "This is ugly and repeats `day ==` seven times. Switch fixes that."

Then show the same logic in switch. The "wow, that is cleaner" reaction is the lesson.

**The rules students must memorise:**

1. Switch only matches **exact values**. It cannot do ranges. `case > 18` is not legal.
2. Every `case` needs a `break`, otherwise it **falls through** to the next case. Demo this on purpose to show the bug.
3. `default` is the catch-all. It is optional, but always include it for safety.
4. To make multiple values run the same code, stack the cases without code between them.

**Live demo the fall-through bug**, this is critical:

```dart
int x = 1;
switch (x) {
  case 1:
    print('One');
    // no break, on purpose
  case 2:
    print('Two');
    break;
}
```

Run it. Output: `One` then `Two`. Now add `break` after `case 1`. Run again. Output: `One`. The students will never forget.

**Then show the modern switch expression (Dart 3+):**

```dart
String name = switch (dayNum) {
  1 => 'Monday',
  2 => 'Tuesday',
  _ => 'Other',
};
```

Tell them: "This is the new way. Cleaner. No `break`. The `_` is the default. Use this when you want to **return a value** based on a match. Use the old `switch (x) { case ... }` form when you want to **do work** like print or call a function."

That distinction is the most useful thing you can teach about switch.

**Flutter teaser:**
"In Flutter, switch is how you handle enums. A loading state has three values: loading, success, error. Switch picks the right widget for each. You will see this in Level 6."

---

### Topic 3: For Loops (40 min video) ← THIS IS WHERE YOU CONTINUE FROM

This topic intimidates students because of the three-part syntax. You must break it down slowly. Do not rush.

**Open with the pain it solves:**

Show:
```dart
print('Hello');
print('Hello');
print('Hello');
print('Hello');
print('Hello');
```

Say: "What if I want to print this 1000 times? You would not type it 1000 times. That is what loops are for."

Then write:
```dart
for (int i = 0; i < 5; i++) {
  print('Hello');
}
```

Same result, three lines.

**Now break the syntax. Use this exact teaching order:**

```dart
for (int i = 0; i < 5; i++) {
   ─────┬──── ──┬── ─┬─
        1       2    3
}
```

1. **Init**: `int i = 0`. Runs once at the start. Like setting a counter.
2. **Condition**: `i < 5`. Checked **before** each loop. If true, run the body. If false, stop.
3. **Update**: `i++`. Runs **after** each loop body. Adds 1 to `i`.

**Then walk through the execution by hand on the board:**

| Step | i | Condition `i < 5` | Action |
|------|---|-------------------|--------|
| Start | 0 | true | print, then i++ |
| Round 2 | 1 | true | print, then i++ |
| Round 3 | 2 | true | print, then i++ |
| Round 4 | 3 | true | print, then i++ |
| Round 5 | 4 | true | print, then i++ |
| Stop | 5 | false | exit |

This table is the single most important thing you can show. Draw it live. Do not paste it.

**Things students will ask:**
- *"Why `i`?"* Tradition. Stands for "index". You can use any name but `i`, `j`, `k` are universal.
- *"Why `i++` and not `i = i + 1`?"* Same thing. `i++` is shorter.
- *"What is `<` vs `<=`?"* This is the off-by-one trap. `i < 5` runs 5 times (0,1,2,3,4). `i <= 5` runs 6 times (0,1,2,3,4,5). Drill this.
- *"Can I count down?"* Yes. `for (int i = 5; i > 0; i--)`.
- *"Can I count by 2s?"* Yes. `i += 2` instead of `i++`.

**Then introduce for-in.** Save this for the second half of the video.

```dart
List<String> names = ['Ada', 'Bola', 'Chidi'];
for (String name in names) {
  print(name);
}
```

Tell them: "This is for when you have a list of things and want to touch each one. You do not care about the index. You only care about the item. This is what you will use most in Flutter."

**Flutter teaser:**
"In Flutter, you build a list of products by looping over a list of items and creating a widget for each one. Every shopping app on your phone uses a for-loop under the hood."

---

### Topic 4: While Loops (30 min video)

Quick and clean. By now they understand what a loop is, they just need a different shape.

**Open with the difference:**

> "Use **for** when you know how many times. Use **while** when you do not know, you just know when to stop."

Examples:
- "Print 1 to 10" → for (you know it is 10).
- "Keep asking for password until correct" → while (you do not know how many tries).

**Show the syntax:**

```dart
while (condition) {
  // runs while condition is true
}
```

**The bug to demo on purpose**, infinite loop:

```dart
int count = 0;
while (count < 5) {
  print(count);
  // forgot count++
}
```

Run this. It prints 0 forever. Stop the program with Ctrl+C. Tell them: "This is the most common bug in loops. Always update something inside the loop or you will hang your program."

**Then show do-while** as a one-line difference:
- `while`: check first, maybe never run.
- `do-while`: run first, then check. Always runs at least once.

Use a menu as the example. A menu must show at least once before asking "do you want to quit?".

---

### Topic 5: Loop Control (20 min video)

Two keywords. Do not over-complicate.

- `break` = stop the loop now.
- `continue` = skip the rest of this round, go to the next.

Demo both with `for (int i = 1; i <= 5; i++)` and an `if` inside. Five minutes total.

Then mention labels for nested loops, but tell them: "You will rarely need this. Move on."

---

## Total Lesson Plan (3 sessions, 90 min each)

### Session 1: Decisions (90 min)
- 5 min: recap booleans and operators from Level 1.
- 40 min: if statements video and live-code.
- 5 min: break.
- 20 min: switch statements video and live-code.
- 20 min: in-class practice. Have them write a grade calculator (`Example01-GradeChecker.dart`) and a day-of-week converter (`Example02-DayOfWeek.dart`).

### Session 2: Repetition (90 min)
- 5 min: recap session 1 by asking "what is the difference between if and switch?".
- 40 min: for loops video and live-code.
- 5 min: break.
- 30 min: while loops video and live-code.
- 10 min: in-class practice. Multiplication table.

### Session 3: Polish and Practice (90 min)
- 20 min: loop control (break, continue).
- 60 min: students complete `Exercises.md` with you on call.
- 10 min: Q&A and capstone preview.

---

## Things You Must NOT Do When Teaching

1. **Do not paste long code.** Type it live. Students learn from watching your fingers.
2. **Do not skip the bug demos.** Showing the off-by-one error and the missing `break` is worth more than ten clean examples.
3. **Do not introduce ternary in the same minute as if-else.** It is shorthand and confuses people who do not yet understand the long form.
4. **Do not say "do not worry about this for now".** If you say it, remove it from the lesson. Either teach it or do not show it.
5. **Do not move on if a student is silent.** Silent often means lost. Ask: "Can you tell me in your own words what this line does?"

---

## Quick Cheat Sheet (Print This)

```dart
// Decisions
if (cond) { } else if (cond) { } else { }
switch (val) { case 1: ...; break; default: ...; }
String x = switch (val) { 1 => 'one', _ => 'other' };
String x = cond ? 'yes' : 'no';

// Repetition
for (int i = 0; i < n; i++) { }
for (var item in list) { }
while (cond) { }
do { } while (cond);

// Loop control
break;     // exit the loop
continue;  // skip to the next iteration
```

If you can teach a student to read every line above and explain what it does, you have taught Level 2 perfectly.

---

**Next step:** Open `Theory/02-SwitchStatements.md` for the upgraded student-facing notes.
