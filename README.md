# EE2026 Digital Design – Final Project  
**National University of Singapore**  
**Academic Year 2020–2021, Semester 2**  

This repository contains the final project for **EE2026: Digital Design**.  
The project involved designing and implementing a set of **mini-games and scenarios** on FPGA hardware using Verilog, integrated peripherals, and real-time inputs (microphone, switches, buttons, and OLED display).  

The aim was to demonstrate creativity, hardware-software integration, and mastery of digital design principles.  

---

## 👥 Team
- **Vishal Jeyaram (A0218188W)**  
- **Sridharan Arvind Srinivasan (A0218441L)**  

**Official Lab Session:** Monday PM  
**Group ID:** S1_20  

---

## 🎮 Project Features

### 1. Real-time Audio Volume Indicator (Vishal)  
- **Inputs:** `SW[0]`, `SW[11]`  
- Displays mic input on 16 LEDs.  
- Switch between raw mic input and peak intensity.  
- Optional display of `L`, `M`, `H` for low, medium, high ranges.  

---

### 2. Graphical Visualisations & Configurations (Arvind)  
- **Inputs:** `SW[12–15]`  
- Configurable border size, color theme, border visibility, and volume bar toggle.  

---

### 3. Menu System (Team)  
- **Inputs:** `btnR`, `btnL`, `btnC`, `SW[1]`  
- Navigate between modes using left/right buttons.  
- Global reset with `SW[1]`.  

---

### 4. Handcuff Game (Team)  
- **Inputs:** `btnR`, `btnL`, `btnU`, `btnD`, `btnC`  
- Press combinations to release a character from handcuffs.  
- Failure to press enough resets the game.  

---

### 5. Corridor (Arvind)  
- **Inputs:** `PmodMIC3`, `btnC`  
- Mic input acts as a password (high/low sequence).  
- Correct password at the right time activates trapdoor to stop the guard.  

---

### 6. Glass Wall (Vishal)  
- **Inputs:** `PmodMIC3`, `btnR`, `btnC`  
- Player cracks the glass by gradually increasing mic intensity.  
- Once cracked, the character can run through to shatter it.  

---

### 7. Fighting Game – Spider-Man vs Venom (Team)  
- **Inputs:** `btnR`, `btnU`, `btnL`, `btnD`, `btnC`, `SW[2]`, `SW[10]`, `PmodMIC3`  
- Two-player game (Spider-Man vs Venom).  
- Attack by toggling switches, reduce opponent’s health.  
- Mic input triggers combat effects.  
- KO screen displayed when one player’s health reaches zero.  

---

## 🛠️ Technical Notes
- **Languages/Tools:** Verilog, Python (for image → Verilog conversion with `imageio`), FPGA peripherals.  
- **Hardware Used:** FPGA board, PmodMIC3, buttons, switches, LEDs, seven-segment display, OLED.  
- **Game Assets:** Converted to Verilog using custom Python scripts.  

---

## 📸 References
- [ImageIO Python Module](https://pypi.org/project/imageio/) for image-to-Verilog conversions.  

---

## 💡 Feedback & Reflections
- The **open-ended improvements** aspect allowed creative freedom in designing unique scenarios.  
- Debugging on the OLED display was challenging without physical hardware; access to personal hardware kits would improve the experience.  
- Exposing all team members to **both mic and OLED subsystems early** would have allowed better role flexibility and learning opportunities.  

---

## 🕹️ Summary
This project explored how digital design concepts can be applied in creative mini-games, blending **hardware signals, audio input, and real-time graphics**.  
It demonstrated the potential of FPGA-based designs for interactive entertainment and problem-solving in embedded systems.  
