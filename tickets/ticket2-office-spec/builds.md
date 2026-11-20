# Ticket 2 — Four role-based builds

**Price date:** 2026-11-20. Prices are retailer listings observed on the date shown in `budget.csv`; confirm availability and final checkout price before purchase. Common component links and prices are in the CSV.

## Compatibility baseline

All builds use the same AM4 CPU socket and B550 motherboard, which supports Ryzen 5000 G-series processors and DDR4 memory. The M.2 NVMe SSD fits the motherboard’s M.2 slot. The micro-ATX motherboard fits the selected micro-ATX case. The 5600GT has integrated Radeon graphics; the designer’s RTX 3050 is an additional PCIe graphics card. The included OEM CPU cooler supports AM4. The 500 W units are selected for the integrated-graphics systems; the designer gets a 650 W unit to provide headroom for the discrete GPU. Confirm the exact motherboard BIOS revision and physical GPU clearance with the seller before ordering.

All four include a 24-inch-class 1080p monitor and a licensed Windows 11 Home OEM license. Windows is an explicit planning assumption because the required accounting and creative software were not identified. Windows 11 Home OEM is listed by the retailer as sold with a computer and not for activation outside Kazakhstan. If the company already owns eligible licenses, remove these line items and preserve the saved amount.

## Build 1 — Accountant

- **Load:** 6–8 hours/day in accounting software, spreadsheets, browser, email, and PDF documents; assume 10–20 browser tabs and one large workbook open concurrently.
- **Bottleneck:** 16 GB RAM is the likely first limit if the spreadsheet, browser, and accounting application grow together; the integrated GPU is adequate for office display output.
- **Trade-off:** Keep 16 GB and integrated graphics to avoid paying for a discrete GPU the assumed workload does not need. The board has expansion room for a later memory upgrade.
- **Parts:** Ryzen 5 5600GT; ASUS Prime B550M-K; 16 GB DDR4-3200; Kingston NV3 1 TB NVMe; 500 W PSU; AeroCool CS-111-G-BK-V1 mATX case; DeepCool AG200 AM4 cooler; Samsung 24-inch IPS monitor; Windows 11 Home OEM.
- **Total:** **471,220 KZT**.

## Build 2 — Sales manager

- **Load:** 6–8 hours/day in CRM/browser, email, spreadsheets, presentations, and video calls; assume 20–30 tabs and one call while keeping CRM and a spreadsheet open.
- **Bottleneck:** Memory pressure from many browser tabs and a video call is the likely first complaint; the 6-core CPU and integrated graphics are adequate for this assumed office load.
- **Trade-off:** Keep 16 GB and integrated graphics, spending on the required SSD, OS, and monitor instead. If the CRM is cloud-hosted, confirm browser compatibility and network reliability before purchase.
- **Parts:** Same as Accountant.
- **Total:** **471,220 KZT**.

## Build 3 — Web developer

- **Load:** 7–9 hours/day with an editor, browser, local database, and several containers or development services running together; assume 20–40 browser tabs.
- **Bottleneck:** Memory is the first likely limit, so start at 32 GB (2 × 16 GB DDR4-3200). CPU time may become the next constraint during parallel builds; integrated graphics is acceptable unless the role includes GPU compute.
- **Trade-off:** Spend on 32 GB RAM while retaining the 6-core CPU and integrated graphics. This avoids buying a GPU for a role where the assumed workload is CPU/RAM and storage-heavy.
- **Parts:** Ryzen 5 5600GT; ASUS Prime B550M-K; 32 GB DDR4-3200 (2 × 16 GB); Kingston NV3 1 TB NVMe; 500 W PSU; AeroCool CS-111-G-BK-V1 mATX case; DeepCool AG200 AM4 cooler; Samsung 24-inch IPS monitor; Windows 11 Home OEM.
- **Total:** **536,210 KZT**.

## Build 4 — Designer

- **Load:** 6–8 hours/day in 2D illustration/layout and light video; assume several large layered files plus browser/reference images open together.
- **Bottleneck:** GPU acceleration and 6 GB VRAM are the most likely limits for effects, large canvases, and video export; 32 GB RAM helps with layered files. Monitor color accuracy is an unresolved risk because no coverage target was provided.
- **Trade-off:** Add an RTX 3050 6 GB and 32 GB RAM, but retain a basic 24-inch 1080p monitor and entry-level GPU to keep the system affordable. This is only appropriate for the assumed non-3D workload.
- **Parts:** Ryzen 5 5600GT; ASUS Prime B550M-K; 32 GB DDR4-3200 (2 × 16 GB); Kingston NV3 1 TB NVMe; MSI MAG A650BN 650 W PSU; AeroCool CS-111-G-BK-V1 mATX case; DeepCool AG200 AM4 cooler; Samsung 24-inch IPS monitor; Windows 11 Home OEM; Palit RTX 3050 StormX 6 GB.
- **Total:** **716,810 KZT**.

## Totals

| Role | Total (KZT) |
|---|---:|
| Accountant | 468,030 |
| Sales manager | 468,030 |
| Web developer | 533,020 |
| Designer | 716,810 |
| **Grand total** | **2,185,890** |
| **Budget remaining** | **814,110** |

### Buying ready-made instead

Use the four totals as target prices, not as proof that pre-built systems cost the same. A pre-built quote must meet the same minimums (16 GB RAM, 1 TB SSD, licensed OS, monitor), state the exact PSU/motherboard/GPU models, include warranty and delivery, and be dated. Compare it against the corresponding role build, then record the vendor quote in a separate dated table.

