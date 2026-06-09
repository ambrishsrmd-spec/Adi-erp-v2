# ADI Construction ERP v2.0 PRO

A complete browser-based Construction ERP system — single HTML file, no server, no database required. All data stored in browser localStorage.

## 📁 Files

```
adi-construction-erp/
├── index.html      ← Complete ERP application
├── vercel.json     ← Vercel deployment config
└── README.md       ← This file
```

## 🚀 Deploy to Vercel (3 steps)

### Step 1 — Push to GitHub
```bash
git init
git add .
git commit -m "ADI Construction ERP v2.0"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/adi-construction-erp.git
git push -u origin main
```

### Step 2 — Connect to Vercel
1. Go to [vercel.com](https://vercel.com) → Sign in
2. Click **"Add New Project"**
3. Import your GitHub repo `adi-construction-erp`
4. **Framework Preset** → select **Other**
5. **Root Directory** → leave as `/` (default)
6. **Build Command** → leave EMPTY
7. **Output Directory** → leave EMPTY
8. Click **Deploy**

### Step 3 — Done ✅
Your ERP will be live at: `https://adi-construction-erp.vercel.app`

---

## 🔧 Modules Included

| Module | Features |
|---|---|
| Dashboard | Live stats, charts, activity log |
| Clients | Master database with GST details |
| Projects | Auto-code, progress tracking, status |
| Vendors | Supplier & contractor database |
| Materials | Auto-code, dynamic categories |
| Employees | Role-based, project assignment |
| Contracts | PDF generation with signatures |
| Work Orders | PDF with terms & conditions |
| BOQ / Estimation | 21 construction units |
| Rate Analysis | Material + Labour + Machinery |
| Purchase Orders | PDF with standard PO terms |
| Expenses | Category-wise tracking |
| Client Billing | RA Bills with GST & retention |
| Receipts | Payment collection tracking |
| Profit & Loss | Project-wise & consolidated |
| Archive | Password-protected delete & restore |

## 🔐 Security
- Delete password: `Rajveer@5210`
- All data stays in your browser (localStorage)
- Use **⬇ Backup** button to export JSON backup regularly

## 📄 PDF Features
- Tax Invoice / RA Bill
- Purchase Order
- Work Order
- Contract Agreement
- BOQ Report
- Rate Analysis Library
- Expense Report
- Receipt Report
- P&L Report
- Full ERP Report (multi-page)

## 💡 Notes
- Data is stored per-browser. Use the Backup button to transfer data between devices.
- For multi-user / cloud storage, upgrade to Supabase + Next.js backend.
