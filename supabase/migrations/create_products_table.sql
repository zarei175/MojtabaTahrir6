-- Create products table
CREATE TABLE public.mojtaba_tahrir_products_2025_01_05_21_00 (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  slug TEXT NOT NULL UNIQUE,
  description TEXT,
  short_description TEXT,
  sku TEXT NOT NULL UNIQUE,
  category_id UUID NOT NULL REFERENCES public.mojtaba_tahrir_categories_2025_01_05_21_00(id) ON DELETE RESTRICT,
  brand TEXT,
  images JSONB DEFAULT '[]'::jsonb,
  base_price DECIMAL(10,2) NOT NULL,
  wholesale_price DECIMAL(10,2),
  stock_quantity INTEGER NOT NULL DEFAULT 0,
  min_order_quantity INTEGER NOT NULL DEFAULT 1,
  weight DECIMAL(8,2),
  dimensions JSONB,
  is_active BOOLEAN NOT NULL DEFAULT true,
  is_featured BOOLEAN NOT NULL DEFAULT false,
  kara_product_id TEXT,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable RLS on products
ALTER TABLE public.mojtaba_tahrir_products_2025_01_05_21_00 ENABLE ROW LEVEL SECURITY;

-- Create policies for products (public read access for active products)
CREATE POLICY "Anyone can view active products" 
ON public.mojtaba_tahrir_products_2025_01_05_21_00 
FOR SELECT 
USING (is_active = true);

-- Authenticated users can view all products
CREATE POLICY "Authenticated users can view all products" 
ON public.mojtaba_tahrir_products_2025_01_05_21_00 
FOR SELECT 
USING (auth.uid() IS NOT NULL);

-- Create trigger for automatic timestamp updates
CREATE TRIGGER update_products_updated_at
BEFORE UPDATE ON public.mojtaba_tahrir_products_2025_01_05_21_00
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();

-- Create indexes for better performance
CREATE INDEX idx_products_category_id ON public.mojtaba_tahrir_products_2025_01_05_21_00(category_id);
CREATE INDEX idx_products_slug ON public.mojtaba_tahrir_products_2025_01_05_21_00(slug);
CREATE INDEX idx_products_sku ON public.mojtaba_tahrir_products_2025_01_05_21_00(sku);
CREATE INDEX idx_products_active ON public.mojtaba_tahrir_products_2025_01_05_21_00(is_active);
CREATE INDEX idx_products_featured ON public.mojtaba_tahrir_products_2025_01_05_21_00(is_featured);
CREATE INDEX idx_products_kara_id ON public.mojtaba_tahrir_products_2025_01_05_21_00(kara_product_id);