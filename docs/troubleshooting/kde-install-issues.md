## Login Issues Under KDE (SDDM)
- Initial issue: KDE login loop when using symlinked /home.
- Root cause: SDDM’s XDG session setup fails with nonstandard home paths.
- Solution: Switched to GNOME Display Manager (GDM).
- KDE now accessible from GDM session selector.
- Verified Plasma desktop after cleanup.

