-- Create cart items table
CREATE TABLE public.mojtaba_tahrir_cart_items_2025_01_05_21_00 (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  product_id UUID NOT NULL REFERENCES public.mojtaba_tahrir_products_2025_01_05_21_00(id) ON DELETE CASCADE,
  quantity INTEGER NOT NULL DEFAULT 1,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
  UNIQUE(user_id, product_id)
);

-- Enable RLS on cart items
ALTER TABLE public.mojtaba_tahrir_cart_items_2025_01_05_21_00 ENABLE ROW LEVEL SECURITY;

-- Create policies for cart items
CREATE POLICY "Users can view their own cart items" 
ON public.mojtaba_tahrir_cart_items_2025_01_05_21_00 
FOR SELECT 
USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own cart items" 
ON public.mojtaba_tahrir_cart_items_2025_01_05_21_00 
FOR INSERT 
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own cart items" 
ON public.mojtaba_tahrir_cart_items_2025_01_05_21_00 
FOR UPDATE 
USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own cart items" 
ON public.mojtaba_tahrir_cart_items_2025_01_05_21_00 
FOR DELETE 
USING (auth.uid() = user_id);

-- Create trigger for automatic timestamp updates
CREATE TRIGGER update_cart_items_updated_at
BEFORE UPDATE ON public.mojtaba_tahrir_cart_items_2025_01_05_21_00
FOR EACH ROW
EXECUTE FUNCTION public.update_updated_at_column();