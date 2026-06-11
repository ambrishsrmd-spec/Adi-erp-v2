-- ============================================================
-- ADI CONSTRUCTION ERP - SUPABASE DATABASE SCHEMA
-- Run this ENTIRE file in Supabase SQL Editor
-- ============================================================

-- ── 1. USER PROFILES & ROLES ──────────────────────────────
CREATE TABLE IF NOT EXISTS public.user_profiles (
  id            UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email         TEXT NOT NULL UNIQUE,
  full_name     TEXT,
  role          TEXT NOT NULL DEFAULT 'pending',
  -- roles: admin | account | site_head | site_engineer | purchase | viewer | pending
  status        TEXT NOT NULL DEFAULT 'pending',
  -- status: active | pending | rejected | suspended
  approved_by   UUID REFERENCES public.user_profiles(id),
  approved_at   TIMESTAMPTZ,
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  last_login    TIMESTAMPTZ,
  avatar_url    TEXT
);

-- ── 2. CLIENTS ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.clients (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name          TEXT NOT NULL,
  contact       TEXT,
  mobile        TEXT,
  email         TEXT,
  gst           TEXT,
  address       TEXT,
  created_by    UUID REFERENCES public.user_profiles(id),
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW()
);

-- ── 3. PROJECTS ────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.projects (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code          TEXT UNIQUE,
  name          TEXT NOT NULL,
  client_id     UUID REFERENCES public.clients(id),
  location      TEXT,
  start_date    DATE,
  end_date      DATE,
  contract_value NUMERIC(15,2) DEFAULT 0,
  status        TEXT DEFAULT 'Planning',
  progress      INTEGER DEFAULT 0,
  manager       TEXT,
  remarks       TEXT,
  created_by    UUID REFERENCES public.user_profiles(id),
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW()
);

-- ── 4. VENDORS ─────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.vendors (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name          TEXT NOT NULL,
  contact       TEXT,
  mobile        TEXT,
  gst           TEXT,
  category      TEXT,
  address       TEXT,
  created_by    UUID REFERENCES public.user_profiles(id),
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW()
);

-- ── 5. MATERIALS ───────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.materials (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code          TEXT UNIQUE,
  name          TEXT NOT NULL,
  category      TEXT,
  unit          TEXT,
  rate          NUMERIC(12,2) DEFAULT 0,
  created_by    UUID REFERENCES public.user_profiles(id),
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW()
);

-- ── 6. EMPLOYEES ───────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.employees (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code          TEXT UNIQUE,
  name          TEXT NOT NULL,
  designation   TEXT,
  mobile        TEXT,
  role          TEXT,
  project_id    UUID REFERENCES public.projects(id),
  salary        NUMERIC(12,2) DEFAULT 0,
  created_by    UUID REFERENCES public.user_profiles(id),
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW()
);

-- ── 7. CONTRACTS ───────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.contracts (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  no            TEXT UNIQUE,
  date          DATE,
  project_id    UUID REFERENCES public.projects(id),
  client_name   TEXT,
  value         NUMERIC(15,2) DEFAULT 0,
  status        TEXT DEFAULT 'Draft',
  retention_pct NUMERIC(5,2) DEFAULT 5,
  advance_pct   NUMERIC(5,2) DEFAULT 10,
  scope         TEXT,
  terms         TEXT,
  created_by    UUID REFERENCES public.user_profiles(id),
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW()
);

-- ── 8. WORK ORDERS ─────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.work_orders (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  no            TEXT UNIQUE,
  date          DATE,
  project_id    UUID REFERENCES public.projects(id),
  vendor_id     UUID REFERENCES public.vendors(id),
  value         NUMERIC(15,2) DEFAULT 0,
  retention_pct NUMERIC(5,2) DEFAULT 5,
  start_date    DATE,
  end_date      DATE,
  status        TEXT DEFAULT 'Active',
  payment_terms TEXT,
  scope         TEXT,
  created_by    UUID REFERENCES public.user_profiles(id),
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW()
);

-- ── 9. BOQ ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.boq (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  item_no       TEXT,
  project_id    UUID REFERENCES public.projects(id),
  description   TEXT NOT NULL,
  unit          TEXT,
  qty           NUMERIC(12,3) DEFAULT 0,
  rate          NUMERIC(12,2) DEFAULT 0,
  amount        NUMERIC(15,2) DEFAULT 0,
  created_by    UUID REFERENCES public.user_profiles(id),
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW()
);

-- ── 10. RATE ANALYSIS ──────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.rate_analysis (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  code          TEXT UNIQUE,
  name          TEXT NOT NULL,
  unit          TEXT,
  material_cost NUMERIC(12,2) DEFAULT 0,
  labour_cost   NUMERIC(12,2) DEFAULT 0,
  machinery_cost NUMERIC(12,2) DEFAULT 0,
  overhead_pct  NUMERIC(5,2) DEFAULT 10,
  total_rate    NUMERIC(12,2) DEFAULT 0,
  created_by    UUID REFERENCES public.user_profiles(id),
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW()
);

-- ── 11. PURCHASE ORDERS ────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.purchase_orders (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  no            TEXT UNIQUE,
  date          DATE,
  vendor_id     UUID REFERENCES public.vendors(id),
  project_id    UUID REFERENCES public.projects(id),
  amount        NUMERIC(15,2) DEFAULT 0,
  status        TEXT DEFAULT 'Pending',
  items         TEXT,
  delivery_terms TEXT,
  created_by    UUID REFERENCES public.user_profiles(id),
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW()
);

-- ── 12. EXPENSES ───────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.expenses (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  date          DATE,
  project_id    UUID REFERENCES public.projects(id),
  category      TEXT,
  amount        NUMERIC(15,2) DEFAULT 0,
  description   TEXT,
  paid_to       TEXT,
  created_by    UUID REFERENCES public.user_profiles(id),
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW()
);

-- ── 13. BILLS ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.bills (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  no            TEXT UNIQUE,
  date          DATE,
  project_id    UUID REFERENCES public.projects(id),
  client_name   TEXT,
  gross_amount  NUMERIC(15,2) DEFAULT 0,
  retention_pct NUMERIC(5,2) DEFAULT 0,
  gst_pct       NUMERIC(5,2) DEFAULT 0,
  net_amount    NUMERIC(15,2) DEFAULT 0,
  status        TEXT DEFAULT 'Submitted',
  remarks       TEXT,
  created_by    UUID REFERENCES public.user_profiles(id),
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW()
);

-- ── 14. RECEIPTS ───────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.receipts (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  date          DATE,
  project_id    UUID REFERENCES public.projects(id),
  client_name   TEXT,
  bill_ref      TEXT,
  amount        NUMERIC(15,2) DEFAULT 0,
  payment_mode  TEXT,
  txn_ref       TEXT,
  created_by    UUID REFERENCES public.user_profiles(id),
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  updated_at    TIMESTAMPTZ DEFAULT NOW()
);

-- ── 15. ARCHIVE ────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.archive (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  record_type   TEXT NOT NULL,
  record_id     UUID,
  record_name   TEXT,
  record_data   JSONB NOT NULL,
  deleted_by    UUID REFERENCES public.user_profiles(id),
  deleted_at    TIMESTAMPTZ DEFAULT NOW()
);

-- ── 16. MATERIAL CATEGORIES ────────────────────────────────
CREATE TABLE IF NOT EXISTS public.material_categories (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name          TEXT NOT NULL UNIQUE,
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

-- Insert defaults
INSERT INTO public.material_categories (name) VALUES
  ('Cement'),('Steel'),('Aggregate'),('Sand'),('Brick'),
  ('Gabion Box'),('Timber'),('Paint'),('Tiles'),('Electrical'),
  ('Plumbing'),('Hardware'),('Waterproofing'),('Chemicals'),('Other')
ON CONFLICT (name) DO NOTHING;

-- ── 17. ACTIVITY LOG ───────────────────────────────────────
CREATE TABLE IF NOT EXISTS public.activity_log (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID REFERENCES public.user_profiles(id),
  user_email    TEXT,
  action        TEXT NOT NULL,
  table_name    TEXT,
  record_id     UUID,
  created_at    TIMESTAMPTZ DEFAULT NOW()
);

-- ============================================================
-- ENABLE REALTIME on all tables
-- ============================================================
ALTER PUBLICATION supabase_realtime ADD TABLE public.clients;
ALTER PUBLICATION supabase_realtime ADD TABLE public.projects;
ALTER PUBLICATION supabase_realtime ADD TABLE public.vendors;
ALTER PUBLICATION supabase_realtime ADD TABLE public.materials;
ALTER PUBLICATION supabase_realtime ADD TABLE public.employees;
ALTER PUBLICATION supabase_realtime ADD TABLE public.contracts;
ALTER PUBLICATION supabase_realtime ADD TABLE public.work_orders;
ALTER PUBLICATION supabase_realtime ADD TABLE public.boq;
ALTER PUBLICATION supabase_realtime ADD TABLE public.rate_analysis;
ALTER PUBLICATION supabase_realtime ADD TABLE public.purchase_orders;
ALTER PUBLICATION supabase_realtime ADD TABLE public.expenses;
ALTER PUBLICATION supabase_realtime ADD TABLE public.bills;
ALTER PUBLICATION supabase_realtime ADD TABLE public.receipts;
ALTER PUBLICATION supabase_realtime ADD TABLE public.user_profiles;

-- ============================================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================================
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.clients ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.vendors ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.materials ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.employees ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.contracts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.work_orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.boq ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.rate_analysis ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.purchase_orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.expenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bills ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.receipts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.archive ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.material_categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.activity_log ENABLE ROW LEVEL SECURITY;

-- Helper function: get current user role
CREATE OR REPLACE FUNCTION public.get_my_role()
RETURNS TEXT AS $$
  SELECT role FROM public.user_profiles WHERE id = auth.uid();
$$ LANGUAGE SQL SECURITY DEFINER STABLE;

-- Helper function: is current user active
CREATE OR REPLACE FUNCTION public.is_active_user()
RETURNS BOOLEAN AS $$
  SELECT EXISTS (
    SELECT 1 FROM public.user_profiles 
    WHERE id = auth.uid() AND status = 'active'
  );
$$ LANGUAGE SQL SECURITY DEFINER STABLE;

-- user_profiles: users can read their own row, admin reads all
CREATE POLICY "users_read_own" ON public.user_profiles
  FOR SELECT USING (id = auth.uid() OR public.get_my_role() = 'admin');

CREATE POLICY "users_insert_own" ON public.user_profiles
  FOR INSERT WITH CHECK (id = auth.uid());

CREATE POLICY "users_update" ON public.user_profiles
  FOR UPDATE USING (id = auth.uid() OR public.get_my_role() = 'admin');

-- material_categories: all active users can read, admin manages
CREATE POLICY "cats_read" ON public.material_categories
  FOR SELECT USING (public.is_active_user());
CREATE POLICY "cats_write" ON public.material_categories
  FOR ALL USING (public.get_my_role() = 'admin');

-- Generic policy factory for main tables (active users read all, role-based write)
-- CLIENTS
CREATE POLICY "clients_read" ON public.clients FOR SELECT USING (public.is_active_user());
CREATE POLICY "clients_insert" ON public.clients FOR INSERT WITH CHECK (public.is_active_user() AND public.get_my_role() IN ('admin','account','site_head'));
CREATE POLICY "clients_update" ON public.clients FOR UPDATE USING (public.get_my_role() IN ('admin','account'));
CREATE POLICY "clients_delete" ON public.clients FOR DELETE USING (public.get_my_role() = 'admin');

-- PROJECTS
CREATE POLICY "projects_read" ON public.projects FOR SELECT USING (public.is_active_user());
CREATE POLICY "projects_insert" ON public.projects FOR INSERT WITH CHECK (public.get_my_role() IN ('admin','site_head'));
CREATE POLICY "projects_update" ON public.projects FOR UPDATE USING (public.get_my_role() IN ('admin','site_head'));
CREATE POLICY "projects_delete" ON public.projects FOR DELETE USING (public.get_my_role() = 'admin');

-- VENDORS
CREATE POLICY "vendors_read" ON public.vendors FOR SELECT USING (public.is_active_user());
CREATE POLICY "vendors_write" ON public.vendors FOR INSERT WITH CHECK (public.get_my_role() IN ('admin','purchase','site_head'));
CREATE POLICY "vendors_update" ON public.vendors FOR UPDATE USING (public.get_my_role() IN ('admin','purchase'));
CREATE POLICY "vendors_delete" ON public.vendors FOR DELETE USING (public.get_my_role() = 'admin');

-- MATERIALS
CREATE POLICY "materials_read" ON public.materials FOR SELECT USING (public.is_active_user());
CREATE POLICY "materials_write" ON public.materials FOR INSERT WITH CHECK (public.get_my_role() IN ('admin','purchase','site_head','site_engineer'));
CREATE POLICY "materials_update" ON public.materials FOR UPDATE USING (public.get_my_role() IN ('admin','purchase'));
CREATE POLICY "materials_delete" ON public.materials FOR DELETE USING (public.get_my_role() = 'admin');

-- EMPLOYEES
CREATE POLICY "employees_read" ON public.employees FOR SELECT USING (public.is_active_user());
CREATE POLICY "employees_write" ON public.employees FOR ALL USING (public.get_my_role() IN ('admin','site_head'));

-- CONTRACTS
CREATE POLICY "contracts_read" ON public.contracts FOR SELECT USING (public.is_active_user());
CREATE POLICY "contracts_write" ON public.contracts FOR ALL USING (public.get_my_role() IN ('admin','account'));

-- WORK ORDERS
CREATE POLICY "wo_read" ON public.work_orders FOR SELECT USING (public.is_active_user());
CREATE POLICY "wo_write" ON public.work_orders FOR ALL USING (public.get_my_role() IN ('admin','site_head','purchase'));

-- BOQ
CREATE POLICY "boq_read" ON public.boq FOR SELECT USING (public.is_active_user());
CREATE POLICY "boq_write" ON public.boq FOR ALL USING (public.get_my_role() IN ('admin','site_head','site_engineer'));

-- RATE ANALYSIS
CREATE POLICY "rates_read" ON public.rate_analysis FOR SELECT USING (public.is_active_user());
CREATE POLICY "rates_write" ON public.rate_analysis FOR ALL USING (public.get_my_role() IN ('admin','site_head'));

-- PURCHASE ORDERS
CREATE POLICY "po_read" ON public.purchase_orders FOR SELECT USING (public.is_active_user());
CREATE POLICY "po_write" ON public.purchase_orders FOR ALL USING (public.get_my_role() IN ('admin','purchase','site_head'));

-- EXPENSES
CREATE POLICY "expenses_read" ON public.expenses FOR SELECT USING (public.is_active_user());
CREATE POLICY "expenses_write" ON public.expenses FOR INSERT WITH CHECK (public.get_my_role() IN ('admin','site_head','site_engineer','account'));
CREATE POLICY "expenses_update" ON public.expenses FOR UPDATE USING (public.get_my_role() IN ('admin','account','site_head'));
CREATE POLICY "expenses_delete" ON public.expenses FOR DELETE USING (public.get_my_role() = 'admin');

-- BILLS
CREATE POLICY "bills_read" ON public.bills FOR SELECT USING (public.is_active_user());
CREATE POLICY "bills_write" ON public.bills FOR ALL USING (public.get_my_role() IN ('admin','account'));

-- RECEIPTS
CREATE POLICY "receipts_read" ON public.receipts FOR SELECT USING (public.is_active_user());
CREATE POLICY "receipts_write" ON public.receipts FOR ALL USING (public.get_my_role() IN ('admin','account'));

-- ARCHIVE
CREATE POLICY "archive_read" ON public.archive FOR SELECT USING (public.get_my_role() = 'admin');
CREATE POLICY "archive_insert" ON public.archive FOR INSERT WITH CHECK (public.get_my_role() = 'admin');
CREATE POLICY "archive_delete" ON public.archive FOR DELETE USING (public.get_my_role() = 'admin');

-- ACTIVITY LOG
CREATE POLICY "log_read" ON public.activity_log FOR SELECT USING (public.get_my_role() = 'admin');
CREATE POLICY "log_insert" ON public.activity_log FOR INSERT WITH CHECK (public.is_active_user());

-- ============================================================
-- AUTO-INSERT PROFILE ON SIGNUP (Supabase Auth Trigger)
-- ============================================================
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.user_profiles (id, email, full_name, role, status)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email,'@',1)),
    CASE 
      WHEN NEW.email = 'ambrish.srmd@gmail.com' THEN 'admin'
      ELSE 'pending'
    END,
    CASE 
      WHEN NEW.email = 'ambrish.srmd@gmail.com' THEN 'active'
      ELSE 'pending'
    END
  )
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger fires on every new signup
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ============================================================
-- AUTO-UPDATE updated_at TRIGGER
-- ============================================================
CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER AS $$
BEGIN NEW.updated_at = NOW(); RETURN NEW; END;
$$ LANGUAGE plpgsql;

DO $$
DECLARE t TEXT;
BEGIN
  FOREACH t IN ARRAY ARRAY['clients','projects','vendors','materials','employees',
    'contracts','work_orders','boq','rate_analysis','purchase_orders','expenses','bills','receipts']
  LOOP
    EXECUTE format('DROP TRIGGER IF EXISTS set_updated_at ON public.%I', t);
    EXECUTE format('CREATE TRIGGER set_updated_at BEFORE UPDATE ON public.%I FOR EACH ROW EXECUTE FUNCTION public.set_updated_at()', t);
  END LOOP;
END $$;

-- ============================================================
-- DONE! Your database is ready.
-- ============================================================
