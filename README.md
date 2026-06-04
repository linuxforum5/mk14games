# mk14games

## Led Match Octal
```text
     ══                    ══  ══ ══  ══             ══   ══  ══ ══  ══
║   ║   ║                 ║  ║   ║   ║    ║  ║      ║  ║ ║      ║   ║  ║ ║
     ══  ══        ══ ══   ══              ══                        ══
║   ║   ║  ║      ║  ║  ║ ║  ║   ║   ║    ║  ║      ║  ║ ║      ║   ║  ║ ║
 ══  ══  ══                           ══             ══   ══              ══
```
[Magyar nyelvű leírás](#Magyar-nyelvű-leírás)

An entertaining logic game for the standard SC-MK14 computer, even with as little as 256 bytes of memory.

## 🕹️ Game Description and Rules

The goal of the game is to create the pattern shown at the beginning of the row by overlapping the digits.
Each digit consists of 7 segments, and overlapping identical segments alternates the visibility of that segment.
Thus, if an even number of segments overlap, the segment is not visible; if an odd number overlap, it is visible (XOR).
To generate the pattern shown at the beginning of the row, digits from the octal number system can be used: 0–7
Pressing a selected digit adds that number to the used digits; pressing it again removes it from use.
Every problem can be solved by selecting a maximum of 5 digits, so more than 5 digits cannot be used.
The combined pattern formed by the currently selected numbers is displayed in the position next to the problem on the left.
If you have successfully solved the problem, a flashing "GO" message will appear in positions 2 and 3, indicating that you can request a new problem by pressing the Go button.
If a given problem is too difficult, you can cancel it by pressing the [Term] button and request a new problem.

### Download the game

The game is available in the dist folder in binary, hex (intel hex), and wav formats.

### Compiling the game

The ASM source code can be compiled into a binary using the sbasm3 compiler, and a WAV file can be generated using the mk14bin2wav utility.

### The game parameters
- Load address: 0x0F12.
- Entry address: 0x0F12.
- Size: 230 bytes.

### Running the game on an original MK14 console

By playing the WAV file located in the dist folder via a tape deck connection, as follows:

After power on

- [0][F][F][9][Term]
- [0][F][Mem]
- [1][2][Mem]
- [Abort]
- [7][C][Go]

Start playing the audio, then after it finishes

- [Reset]
- [0][F][1][2][Go]

### Running the game on an emulator

The .hex file is generally compatible with emulators.
Tested with the [MK14.py](https://github.com/dallday/MK14_Emulator_python) emulator.

---

## Magyar nyelvű leírás

Egy élvezetes logikai játék az alapkiépítésű SC-MK14 számítógépre, akár már 256 bájt memóriával is.

## 🕹️ A játék leírása és szabályai

A játék célja, hogy a számjegyek egymásraillesztésével előállítsuk a sor elején látható mintát.
Minden számjegy 7 szegmensből áll, és az egymásra illesztett azonos szegmensek váltják az adott szegmens láthatóságát.
Tehát páros számú egymásraillesztés esetén nem látható az adott szegmens, páratlanszámú fedés esetén láthatóak (XOR).
A sor elején látható minta előállításához a 8-as számrendszer számjegyei használhatók: 0-7
A kiválasztott számjegy lenyomása beteszi a felhasznált számjegyek közé az adott számot, majd újbóli lenyomása esetén törli annak használatát.
Minden feladat maximum 5 számjegy kiválasztásával biztosan megoldható, így 5 számjegynél több nem is használható fel.
Az aktuálisan kiválasztott számokból adódó egyesített minta a baloldalon látható feladvány melleti pozíción látható.
Ha sikerült megoldani a feladatot, úgy a 2. és 3. pozíción megjelenik egy villogó GO felirat, ami azt jelzi, hogy a Go gomb megynomásával 
új feladvány kérhető.
Ha egy adott feladvány túl nehéz, a [Term] gomb megynomásával új megszakítható az adott feladvány, és új feladvány kérhető.

### A játék letöltése

A dist mappában elérhető a játk bináris, hex (intel hex) és wav formátumban.

### A játék fordítása

Az asm forráskód sbasm3 fordítóval fordítható binárissá, és az mk14bin2wav utility segítségével állítható elő a wav fájl.

### A játék paraméterei
- Betöltési címe: 0x0F12.
- Indítási címe: 0x0F12.
- Mérete: 230 bájt.

### A játék futtatása eredeti MK14 gépen
Egy magnóillesztó kapcsoláson keresztül a dist mappában található wav fájl lejátszásával a következő módon:

Bekapcsolás után

- [0][F][F][9][Term]
- [0][F][Mem]
- [1][2][Mem]
- [Abort]
- [7][C][Go]

hang lejátszásának indítása, majd a befejezés után

- [Reset]
- [0][F][1][2][Go]

### A játék futtatása emulátoron

Emulátorhoz általában az hex fájl használható.
Az [MK14.py](https://github.com/dallday/MK14_Emulator_python) emulátorral tesztelve.
