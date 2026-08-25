import numpy as np
import matplotlib.pyplot as plt

# ============================================================
# SYSTEM PARAMETERS
# ============================================================

# Root-locus form:
#
# 1 + H*G(s) = 0
#
# G(s) = 10s / (s^2 + 13.5714s + 357.1429)

wn2 = 357.1429
wn = np.sqrt(wn2)

# Desired Butterworth damping ratio
zeta = 1 / np.sqrt(2)

# Fixed circuit values
R3 = 1000


# ============================================================
# DESIRED POLE
# ============================================================

sigma = zeta * wn
wd = wn * np.sqrt(1 - zeta**2)

desired_pole = complex(-sigma, wd)

# Damping-ratio angle
theta = np.degrees(np.arccos(zeta))


# ============================================================
# REQUIRED GAIN H
# ============================================================

# Characteristic equation:
#
# s^2 + (13.5714 + 10H)s + 357.1429 = 0
#
# At the desired pole:
#
# H = (2*sigma - 13.5714) / 10

H_required = (2 * sigma - 13.5714) / 10

# Corresponding R1
R1_required = R3 / H_required


# ============================================================
# ROOT LOCUS CALCULATION (smooth path for plotting)
# ============================================================

# For every value of H:
#
# s^2 + (13.5714 + 10H)s + 357.1429 = 0

H_values_smooth = np.linspace(0, 30, 3000)

pole_1 = []
pole_2 = []

for H in H_values_smooth:

    coefficients = [
        1,
        13.5714 + 10 * H,
        357.1429
    ]

    poles = np.roots(coefficients)

    pole_1.append(poles[0])
    pole_2.append(poles[1])

pole_1 = np.array(pole_1)
pole_2 = np.array(pole_2)


# ============================================================
# POLES AT REQUIRED GAIN
# ============================================================

required_coefficients = [
    1,
    13.5714 + 10 * H_required,
    357.1429
]

required_poles = np.roots(required_coefficients)


# ============================================================
# ORIGINAL DESIGN: H = 25 (reference only, NOT plotted)
# ============================================================

H_original = 25

original_coefficients = [
    1,
    13.5714 + 10 * H_original,
    357.1429
]

original_poles = np.roots(original_coefficients)
R1_original = R3 / H_original


# ============================================================
# PRINT ALL IMPORTANT CALCULATIONS
# ============================================================

print("=" * 60)
print("ROOT-LOCUS ANALYSIS")
print("=" * 60)

print("\nRoot-locus equation:")
print("1 + H*G(s) = 0")

print("\nOpen-loop transfer function:")
print("G(s) = 10s / (s^2 + 13.5714s + 357.1429)")

print("\nOpen-loop poles:")

open_loop_poles = np.roots([
    1,
    13.5714,
    357.1429
])

for p in open_loop_poles:
    print(f"  {p:.6f}")

print("\nOpen-loop zero:")
print("  s = 0")

print("\nNatural frequency:")
print(f"  wn = {wn:.6f} rad/s")

print("\nDesired damping ratio:")
print(f"  zeta = {zeta:.6f}")

print("\nDamping-ratio angle:")
print(f"  theta = {theta:.2f} degrees")

print("\nDesired pole:")
print(
    f"  s = {desired_pole.real:.6f}"
    f" + j{desired_pole.imag:.6f}"
)

print("\nRequired gain:")
print(f"  H = {H_required:.6f}")

print("\nRequired R1:")
print(f"  R1 = {R1_required:.6f} Ohm")

print("\nPoles at required gain:")

for p in required_poles:
    print(f"  s = {p:.6f}")

print("\nInitial design (reference only, not plotted):")
print(f"  H = {H_original}")
print(f"  R1 = {R1_original:.6f} Ohm")

print("\nPoles at initial design:")

for p in original_poles:
    print(f"  s = {p:.6f}")


# ============================================================
# PRINT ALL CALCULATED POLE POINTS (max 100 H samples)
# ============================================================

print("\n" + "=" * 60)
print("CALCULATED POLE POSITIONS AS H CHANGES (up to 100 points)")
print("=" * 60)

H_values_table = np.linspace(0, 30, 100)

for H in H_values_table:

    coefficients = [
        1,
        13.5714 + 10 * H,
        357.1429
    ]

    poles_h = np.roots(coefficients)

    print(f"\nH = {H:.4f}")
    print(f"  s1 = {poles_h[0]:.6f}")
    print(f"  s2 = {poles_h[1]:.6f}")


# ============================================================
# SINGLE ROOT-LOCUS / POLE MAP FIGURE
# ============================================================

fig, ax = plt.subplots(figsize=(16, 12))

# ------------------------------------------------------------
# Pole path (thick, dominant visual element)
# ------------------------------------------------------------

ax.plot(
    pole_1.real,
    pole_1.imag,
    linewidth=4,
    color="tab:blue",
    label="Pole locus (as H varies)"
)

ax.plot(
    pole_2.real,
    pole_2.imag,
    linewidth=4,
    color="tab:blue"
)

# ------------------------------------------------------------
# Open-loop poles / zero
# ------------------------------------------------------------

ax.scatter(
    open_loop_poles.real,
    open_loop_poles.imag,
    s=160,
    marker="x",
    color="black",
    linewidths=3,
    label="Open-loop poles (H = 0)"
)

ax.scatter(
    [0],
    [0],
    s=200,
    marker="o",
    facecolors="none",
    edgecolors="black",
    linewidths=2,
    label="Open-loop zero (s = 0)"
)

# ------------------------------------------------------------
# 45 degree damping-ratio line from the origin
# ------------------------------------------------------------

line_length = 30

x_line = np.linspace(-line_length, 0, 500)
y_line = -x_line  # zeta = 0.7071 -> theta = 45 deg

ax.plot(
    x_line,
    y_line,
    "--",
    linewidth=2.5,
    color="darkorange",
    label=r"45° damping-ratio line ($\zeta = 0.7071$)"
)

ax.plot(
    x_line,
    -y_line,
    "--",
    linewidth=2.5,
    color="darkorange"
)

# ------------------------------------------------------------
# Desired Butterworth pole (intersection point)
# ------------------------------------------------------------

ax.scatter(
    desired_pole.real,
    desired_pole.imag,
    s=260,
    marker="o",
    color="red",
    zorder=5,
    label=f"Desired pole (intersection), H = {H_required:.4f}"
)

ax.scatter(
    desired_pole.real,
    -desired_pole.imag,
    s=260,
    marker="o",
    color="red",
    zorder=5
)

ax.annotate(
    f"Desired Butterworth pole\n"
    f"s = {desired_pole.real:.2f} + j{desired_pole.imag:.2f}\n"
    f"H = {H_required:.4f}",
    xy=(desired_pole.real, desired_pole.imag),
    xytext=(desired_pole.real - 12, desired_pole.imag + 6),
    arrowprops=dict(arrowstyle="->", linewidth=1.5),
    fontsize=12,
    fontweight="bold"
)

ax.annotate(
    f"s = {desired_pole.real:.2f} - j{desired_pole.imag:.2f}",
    xy=(desired_pole.real, -desired_pole.imag),
    xytext=(desired_pole.real - 12, -desired_pole.imag - 6),
    arrowprops=dict(arrowstyle="->", linewidth=1.5),
    fontsize=12
)

# ------------------------------------------------------------
# Reference note (initial design), text only, not plotted
# ------------------------------------------------------------

ax.text(
    0.02,
    0.02,
    f"Initial design (reference only, not plotted):\n"
    f"H = {H_original},  R1 = {R1_original:.0f} \u03A9",
    transform=ax.transAxes,
    fontsize=12,
    verticalalignment="bottom",
    bbox=dict(boxstyle="round", facecolor="wheat", alpha=0.6)
)

# ------------------------------------------------------------
# Axes / formatting
# ------------------------------------------------------------

ax.axhline(0, linewidth=1, color="black")
ax.axvline(0, linewidth=1, color="black")

ax.set_xlabel("Real Axis", fontsize=14)
ax.set_ylabel("Imaginary Axis", fontsize=14)

ax.set_title(
    "Classical Root Locus: 1 + H·G(s) = 0\n"
    r"G(s) = 10s / (s$^2$ + 13.5714s + 357.1429)",
    fontsize=17
)

ax.set_xlim(-30, 5)
ax.set_ylim(-25, 25)

ax.grid(True, which="both", linestyle=":", linewidth=0.8)
ax.legend(fontsize=11, loc="upper right")

ax.set_aspect("equal")

fig.tight_layout()

plt.show()
