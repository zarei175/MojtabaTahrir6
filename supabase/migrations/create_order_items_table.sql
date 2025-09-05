-- Create order items table
CREATE TABLE public.mojtaba_tahrir_order_items_2025_01_05_21_00 (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  order_id UUID NOT NULL REFERENCES public.mojtaba_tahrir_orders_2025_01_05_21_00(id) ON DELETE CASCADE,
  product_id UUID NOT NULL REFERENCES public.mojtaba_tahrir_products_2025_01_05_21_00(id) ON DELETE RESTRICT,
  quantity INTEGER NOT NULL,
  unit_price DECIMAL(10,2) NOT NULL,
  total_price DECIMAL(10,2) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable RLS on order items
ALTER TABLE public.mojtaba_tahrir_order_items_2025_01_05_21_00 ENABLE ROW LEVEL SECURITY;

-- Create policies for order items
CREATE POLICY "Users can view order items for their orders" 
ON public.mojtaba_tahrir_order_items_2025_01_05_21_00 
FOR SELECT 
USING (
  EXISTS (
    SELECT 1 FROM public.mojtaba_tahrir_orders_2025_01_05_21_00 
    WHERE mojtaba_tahrir_orders_2025_01_05_21_00.id = mojtaba_tahrir_order_items_2025_01_05_21_00.order_id 
    AND mojtaba_tahrir_orders_2025_01_05_21_00.user_id = auth.uid()
  )
);

CREATE POLICY "Users can create order items for their orders" 
ON public.mojtaba_tahrir_order_items_2025_01_05_21_00 
FOR INSERT 
WITH CHECK (
  EXISTS (
    SELECT 1 FROM public.mojtaba_tahrir_orders_2025_01_05_21_00 
    WHERE mojtaba_tahrir_orders_2025_01_05_21_00.id = mojtaba_tahrir_order_items_2025_01_05_21_00.order_id 
    AND mojtaba_tahrir_orders_2025_01_05_21_00.user_id = auth.uid()
  )
);