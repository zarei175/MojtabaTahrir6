-- Create categories table
CREATE TABLE public.mojtaba_tahrir_categories_2025_01_05_21_00 (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  description TEXT,
  image_url TEXT,
  parent_id UUID REFERENCES public.mojtaba_tahrir_categories_2025_01_05_21_00(id) ON DELETE SET NULL,
  sort_order INTEGER DEFAULT 0,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable RLS on categories
ALTER TABLE public.mojtaba_tahrir_categories_2025_01_05_21_00 ENABLE ROW LEVEL SECURITY;

-- Create policies for categories (public read access)
CREATE POLICY "Anyone can view active categories" 
ON public.mojtaba_tahrir_categories_2025_01_05_21_00 
FOR SELECT 
USING (is_active = true);

-- Admin policy for full access (will be handled by admin role)
CREATE POLICY "Authenticated users can view all categories" 
ON public.mojtaba_tahrir_categories_2025_01_05_21_00 
FOR SELECT 
USING (auth.uid() IS NOT NULL);

-- Create index for better performance
CREATE INDEX idx_categories_parent_id ON public.mojtaba_tahrir_categories_2025_01_05_21_00(parent_id);
CREATE INDEX idx_categories_slug ON public.mojtaba_tahrir_categories_2025_01_05_21_00(slug);
CREATE INDEX idx_categories_active ON public.mojtaba_tahrir_categories_2025_01_05_21_00(is_active);