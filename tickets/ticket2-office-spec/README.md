# Ticket 2 — Kitting out the new office
**Amirgali A.**  
**Course:** IFT 103 — Operating System Architecture  
**Price check date:** 2026-11-20  

## 1. What was asked

Director Daniyar asked for four computers for the new office: an accountant, a sales manager, a web developer, and a designer. He proposed buying identical machines, set a total budget of 3,000,000 KZT, asked that they last “a few years,” and explicitly said to include monitors.

## 2. What was actually needed

Four identical computers are not automatically the right answer because the roles have different daily loads. Accounting and sales are mainly browser and office workloads; development benefits from extra memory for an editor, browser, containers, and a local database; design may need a discrete GPU and a better calibrated display. Spending the same amount on each machine could leave money unused for light users while leaving the designer short of graphics performance.

The request leaves several things unclear. I would ask Daniyar: (1) Which accounting, CRM, development, and design applications and versions will each person use? (2) How many browser tabs, spreadsheets, containers, virtual machines, or large design files are typical at once? (3) What does “a few years” mean: three, four, or five years, and should the platform allow a CPU or memory upgrade? (4) Does “everything” include keyboard, mouse, cables, backup storage, and setup? (5) Does the designer need Adobe/CUDA workflows, a color-calibrated monitor, or a graphics tablet? (6) Is Windows required by company software, and does the company already own transferable licenses?

For this draft I assume a four-year planning horizon; existing keyboards, mice, network equipment, and backup infrastructure can be reused; the 3,000,000 KZT covers the tower, one monitor, and one licensed Windows 11 Home OEM copy per person; users work in ordinary office-sized files; the designer makes 2D assets and light video rather than heavy 3D; and Windows-compatible applications are preferred because the actual software list was not supplied. I chose a different RAM/GPU allocation by role while keeping the common AM4/DDR4 platform consistent. These are assumptions, not facts confirmed by Daniyar.

## 3. What I built

See [`builds.md`](builds.md) for each role’s load, bottleneck, trade-off, parts, compatibility notes, and total. All four draft builds include at least 16 GB RAM, a 1 TB SSD, one monitor, a licensed OS, and a complete tower. The grand total is **2,185,890 KZT**, below the 3,000,000 KZT cap by **814,110 KZT**.

The common platform uses an AM4 Ryzen 5 5600GT with integrated Radeon graphics, an AM4 B550 motherboard, DDR4-3200 memory, an M.2 NVMe SSD, and a micro-ATX case. The designer receives 32 GB RAM and a GeForce RTX 3050 6 GB; the power supply is raised to 650 W. The other three builds use 16 GB and integrated graphics. A dedicated AM4 cooler is included because the researched 5600GT listing is OEM and does not include a cooler.

## 4. Evidence

- [`budget.csv`](budget.csv) contains one row per component, a KZT price, vendor product/category link, and the date checked. The links point to Kazakhstan retailer White Wind (shop.kz), which lists local delivery and/or Kazakhstan stores.
- [`evidence/pcpartpicker-links.md`](evidence/pcpartpicker-links.md) records the compatibility-check links and explains a limitation: PCPartPicker does not provide a usable KZT-priced bill of materials for these local SKUs. The local vendor configurator should be used for a second compatibility check; its links are listed there.
- [`evidence/vendor-quotes/README.md`](evidence/vendor-quotes/README.md) records the exact evidence files.

## 5. Answers to Daniyar’s questions

1. **Which machine would I upgrade first in 18 months, and why?** I would upgrade the web developer’s memory from 32 GB to 64 GB first, if measurements show memory pressure while containers, a local database, editor, and browser are open together. RAM is a direct response to that workload and is easier to add than replacing the whole platform. The proposed developer build starts at 32 GB, so the upgrade is not assumed to be necessary without observing real use.

2. **What do pre-built machines gain and lose?** The company gains one vendor’s assembly, warranty handling, and support path, and saves staff time on sourcing, assembly, and troubleshooting. It gives up some component choice, may pay a higher price for the same parts, and may have a less clear upgrade path or lower-quality component substitutions. I would compare dated quotes for these exact four specifications before ordering pre-built systems.

3. **Who is most likely to complain first?** The designer is the most likely to notice the trade-off first: the RTX 3050 6 GB and 24-inch 1080p display are entry-level choices for design, especially with large layered files, color-critical work, or GPU-heavy Adobe/video features. I assumed 2D work to stay well under budget; if the designer confirms 3D, heavy video, or color-critical delivery, I would reallocate the remaining budget to a stronger GPU and a color-accurate monitor before buying.

### What I would do differently

With more information I would replace these workload assumptions with a short interview and the actual software/version list, then price the designer’s monitor against a stated color-coverage target and test whether the developer needs 64 GB at purchase. I would also obtain dated pre-built quotes and confirm whether peripherals and support are already available.

