-- Create bulk pricing table
CREATE TABLE public.mojtaba_tahrir_bulk_pricing_2025_01_05_21_00 (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  product_id UUID NOT NULL REFERENCES public.mojtaba_tahrir_products_2025_01_05_21_00(id) ON DELETE CASCADE,
  min_quantity INTEGER NOT NULL,
  max_quantity INTEGER,
  price DECIMAL(10,2) NOT NULL,
  discount_percentage DECIMAL(5,2),
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable RLS on bulk pricing
ALTER TABLE public.mojtaba_tahrir_bulk_pricing_2025_01_05_21_00 ENABLE ROW LEVEL SECURITY;

-- Create policies for bulk pricing (public read access)
CREATE POLICY "Anyone can view bulk pricing" 
ON public.mojtaba_tahrir_bulk_pricing_2025_01_05_21_00 
FOR SELECT 
USING (true);

-- Authenticated users can view all bulk pricing
CREATE POLICY "Authenticated users can view all bulk pricing" 
ON public.mojtaba_tahrir_bulk_pricing_2025_01_05_21_00 
FOR SELECT 
USING (auth.uid() IS NOT NULL);